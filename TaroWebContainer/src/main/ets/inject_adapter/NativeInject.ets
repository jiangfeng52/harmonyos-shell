/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import uri from '@ohos.uri';
import window from '@ohos.window';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@ohos.base';
import Want from '@ohos.app.ability.Want';
import bundleManager from '@ohos.bundle.bundleManager';
import fs from '@ohos.file.fs';

import {
  CapsuleController,
  ErrorMsg,
  InnerInjectObj,
  MenuButtonOptions,
  PermissionInfo,
  RequestSubscribeMessageOptions,
  SaveDataUrlOptions,
  SubscribeMessageOptions,
  SubscriptionsSetting,
  ChooseMediaOptions,
  ExitMiniProgramOptions,
} from '../interfaces/InjectObject';
import {
  getBundleUsedPermission,
  getBundleUserPermissions,
  getBundleWxScopeList,
  openPermissionsInSystemSettings,
} from '../utils/PermissionMapScopeUtil';
import {
  addNotificationManagerSlot,
  cancelMessage,
  CancelMessageOptions,
  enableNotification,
  getMassageList,
  NotificationBasicContent,
  NotificationContent,
  NotificationRequest,
  sendMessage,
  SendMessageOptions
} from '../utils/SubscribeMessageUtil';
import { NavigationBarData } from '../components/NavigationBar';
import { setSystemBarProperties } from '../utils/WindowUtil';
import { wbLogger } from '../utils/Logger';
import { switchHapSandBoxToInternal, switchInternalToHapSandBox } from '../utils/InternalPath';
import { LocalUpdateManagerInstance } from '../update/LocalUpdateManager';
import util from '@ohos.util';
import { selectMediaAssets } from '../utils/MediaUtil';
import { MediaItemData, ChooseAlbumResult, chooseAlbumOptions } from '../interfaces/Media';


const NATIVE_TAG = 'NativeInject';

/**
 * Native注入类，实现一些跟壳工程比较紧密关联的Taro API。
 */

export class NativeInject {
  // 用于更新控制导航栏
  private navigationBarData: NavigationBarData;
  // 系统状态栏高度，包含avoid区域高度
  private systemBarHeight: number;
  // 应用宽度
  private windowWidth: number;
  // 权限信息
  private permissionInfo: bundleManager.ReqPermissionDetail[];
  // 胶囊的尺寸
  private capsuleOptions: MenuButtonOptions;
  // 胶囊显示控制
  private capsuleController: CapsuleController;
  private chooseAlbumCallback?: (options: chooseAlbumOptions, mediaItems: MediaItemData[]) => Promise<ChooseAlbumResult>;

  constructor(navigationBarData: NavigationBarData, capsuleOptions: MenuButtonOptions, capsuleController: CapsuleController) {
    this.navigationBarData = navigationBarData;
    this.systemBarHeight = 0;
    this.windowWidth = 0;
    this.permissionInfo = [];
    this.capsuleOptions = capsuleOptions
    this.capsuleController = capsuleController
  }

  private setStatusBarFrontColor(barFrontColor: string) {
    const context = getContext(this) as common.UIAbilityContext;
    window.getLastWindow(context).then((windowClass) => {
      setSystemBarProperties(windowClass, barFrontColor);
    });
  }

  public setChooseAlbumCallback(cb: (options: chooseAlbumOptions, mediaItems: MediaItemData[]) => Promise<ChooseAlbumResult>) {
    this.chooseAlbumCallback = cb;
  }

  public setSystemBarHeight(systemBarHeight: number) {
    this.systemBarHeight = systemBarHeight;
  }

  public setWindowWidth(windowWidth: number) {
    this.windowWidth = windowWidth;
  }

  public setPermissionInfo(permissionInfo: bundleManager.ReqPermissionDetail[]) {
    this.permissionInfo = permissionInfo;
  }

  public buildInjectObj(context: common.UIAbilityContext): InnerInjectObj {
    return {
      copyFileToSandboxCache: (src: string) => {
        const context = getContext() as common.UIAbilityContext;
        const fileName = src.substring(src.lastIndexOf('/') + 1);
        const sandboxPath = `${context.cacheDir}/${Date.now()}_${fileName}`;
        const fd = fs.openSync(src, fs.OpenMode.READ_ONLY).fd;
        fs.copyFileSync(fd, sandboxPath);
        return { internalCachePath: switchHapSandBoxToInternal(sandboxPath) }
      },
      setNavigationBarColor: (options) => {
        wbLogger.info(NATIVE_TAG, `setNavigationBarColor: ${JSON.stringify(options || {})}`)
        this.navigationBarData.barColor = options.backgroundColor ?? this.navigationBarData.barColor;
        this.navigationBarData.barFrontColor = options.frontColor ?? this.navigationBarData.barFrontColor;
        if (options.animation) {
          this.navigationBarData.animationDuration = options.animation.duration ?? 0;
          const timingFuncMap = new Map([
            ['linear', Curve.Linear],
            ['easeIn', Curve.EaseIn],
            ['easeOut', Curve.EaseOut],
            ['easeInOut', Curve.EaseInOut],
          ])
          if (options.timingFunc && timingFuncMap.has(options.timingFunc)) {
            this.navigationBarData.animationCurve = Number(timingFuncMap.get(options.timingFunc) ?? Curve.Linear);
          }
        }
        this.setStatusBarFrontColor(this.navigationBarData.barFrontColor);
      },
      showNavigationBarLoading: () => {
        this.navigationBarData.loading = true;
      },
      hideNavigationBarLoading: () => {
        this.navigationBarData.loading = false;
      },
      getMenuButtonBoundingClientRect: () => {
        return {
          left: this.windowWidth - this.capsuleOptions.marginRight - this.capsuleOptions.width,
          right: this.windowWidth - this.capsuleOptions.marginRight,
          top: this.systemBarHeight,
          bottom: this.systemBarHeight + this.capsuleOptions.height,
          width: this.capsuleOptions.width,
          height: this.capsuleOptions.height,
        }
      },
      navigateToMiniProgram: (options) => {
        // options.path 格式:
        // - EntryAbility:///pages/api/framework/index?paramA=good
        // - /pages/api/framework/index?paramA=good
        return new Promise((resolve, reject) => {
          resolve({ errMsg: '' });
          wbLogger.info(NATIVE_TAG, 'navigateToMiniProgram options:' + JSON.stringify(options));
          const entryAbility = 'EntryAbility';
          let abilityName = entryAbility;
          let path = '';
          let query = '';
          if (options.path) {
            const targetUri: string = options.path.startsWith('/') ? `${entryAbility}://${options.path}` : options.path;
            const uriInfo = new uri.URI(targetUri);
            abilityName = uriInfo.scheme;
            path = uriInfo.path;
            query = (!uriInfo.query || uriInfo.query === 'null') ? '' : uriInfo.query;
          }
          const wantInfo: Want = {
            deviceId: '',
            bundleName: options.appId,
            abilityName,
            parameters: {
              extraData: options.extraData || {},
              path,
              query,
            },
          };
          wbLogger.debug(NATIVE_TAG, `navigateToMiniProgram: ${JSON.stringify(wantInfo)}`);
          try {
            const context = getContext(this) as common.UIAbilityContext;
            context.startAbility(wantInfo).then(() => {
              resolve({ errMsg: '' });
            }).catch(() => {
              reject({ errMsg: 'invalid appid or path scheme' } as ErrorMsg);
            })
          } catch (paramError) {
            wbLogger.warn(NATIVE_TAG, `navigateToMiniProgram failed: ${JSON.stringify(paramError)}`);
            reject({
              errMsg: `code: ${(paramError as BusinessError).code}, message ${(paramError as BusinessError).message}`
            } as ErrorMsg
            );
          }
        })
      },
      setNavigationStyle: (style, textStyle, backgroundColor) => {
        this.navigationBarData.visible = style !== 'custom';
        this.navigationBarData.barFrontColor = textStyle === 'white' ? '#ffffff' : '#000000';
        this.navigationBarData.barColor = backgroundColor;
        this.navigationBarData.animationDuration = 0;
        this.setStatusBarFrontColor(this.navigationBarData.barFrontColor);
      },
      openSetting: (options) => {
        const apiName: string = 'openSetting';
        // 接口返回
        return new Promise(async (resolve, reject) => {
          try {
            const curPermissions: Array<PermissionInfo> = getBundleUserPermissions(this.permissionInfo);
            const bundleScope = await getBundleWxScopeList(curPermissions);
            const bundleUsedScope = getBundleUsedPermission(bundleScope.allScope, bundleScope.bundleScope);
            // 打开应用的权限列表
            openPermissionsInSystemSettings();
            if (options.withSubscriptions) {
              let NotificationBasicContent: NotificationBasicContent = {
                title: '设置',
                text: '获取中',
                additionalText: "",
              }
              let NotificationContent: NotificationContent = {
                contentType: 'NOTIFICATION_CONTENT_BASIC_TEXT',
                normal: NotificationBasicContent
              }
              let notificationRequests: NotificationRequest = {
                id: 1222287986,
                slotType: 'OTHER_TYPES',
                content: NotificationContent,
                path: ''
              }
              let sendMessageOption: SendMessageOptions = {
                notificationRequest: notificationRequests
              }
              let subscriptionsSetting: SubscriptionsSetting = {
                mainSwitch: false,
                itemSettings: []
              }
              await sendMessage(sendMessageOption).then(async (res) => {
                let cancelMessageOptions: CancelMessageOptions = {
                  id: 1222287986
                }
                await cancelMessage(cancelMessageOptions).then((res) => {
                  subscriptionsSetting.mainSwitch = true
                }).catch((err: Error) => {
                  subscriptionsSetting.mainSwitch = false
                })
              }).catch((err: Error) => {
                console.log('requestSubscribeMessage', JSON.stringify(err))
              })
              const subscribeCode = await getMassageList()
              subscriptionsSetting.itemSettings = subscribeCode.massageList
              return resolve({
                authSetting: bundleUsedScope.allScope,
                subscriptionsSetting: subscriptionsSetting,
                errMsg: `${apiName}:ok`
              });
            }
            return resolve({ authSetting: bundleUsedScope.allScope, errMsg: `${apiName}:ok` });
          } catch (paramError) {
            wbLogger.warn(NATIVE_TAG, `openSetting: ${JSON.stringify(paramError)}`);
            return reject(
              {
                errMsg: `${apiName}:fail error code: ${(paramError as BusinessError).code} ${(paramError as BusinessError).message}`
              } as ErrorMsg
            );
          }
        })
      },
      getSetting: (options) => {
        const apiName: string = 'getSetting';
        // 接口返回
        return new Promise(async (resolve, reject) => {
          try {
            const curPermissions: Array<PermissionInfo> = getBundleUserPermissions(this.permissionInfo);
            const bundleScope = await getBundleWxScopeList(curPermissions);
            const bundleUsedScope = getBundleUsedPermission(bundleScope.allScope, bundleScope.bundleScope);
            if (options.withSubscriptions) {
              let NotificationBasicContent: NotificationBasicContent = {
                title: '设置',
                text: '获取中',
                additionalText: "",
              }
              let NotificationContent: NotificationContent = {
                contentType: 'NOTIFICATION_CONTENT_BASIC_TEXT',
                normal: NotificationBasicContent
              }
              let notificationRequests: NotificationRequest = {
                id: 1222287986,
                slotType: 'OTHER_TYPES',
                content: NotificationContent,
                path: ''
              }
              let sendMessageOption: SendMessageOptions = {
                notificationRequest: notificationRequests
              }
              let subscriptionsSetting: SubscriptionsSetting = {
                mainSwitch: false,
                itemSettings: []
              }
              await sendMessage(sendMessageOption).then(async (res) => {
                let cancelMessageOptions: CancelMessageOptions = {
                  id: 1222287986
                }
                await cancelMessage(cancelMessageOptions).then((res) => {
                  subscriptionsSetting.mainSwitch = true
                }).catch((err: Error) => {
                  subscriptionsSetting.mainSwitch = false
                })
              }).catch((err: Error) => {
                console.log('requestSubscribeMessage', JSON.stringify(err))
              })
              const subscribeCode = await getMassageList()
              subscriptionsSetting.itemSettings = subscribeCode.massageList
              return resolve({
                authSetting: bundleUsedScope.allScope,
                subscriptionsSetting: subscriptionsSetting,
                errMsg: `${apiName}:ok`
              });
            }
            return resolve({ authSetting: bundleUsedScope.allScope, errMsg: `${apiName}:ok` });
          } catch (paramError) {
            return reject(
              {
                errMsg: `${apiName}:fail error code: ${(paramError as BusinessError).code} ${(paramError as BusinessError).message}`
              } as ErrorMsg
            );
          }
        })
      },
      getUpdateManager: () => {
        return LocalUpdateManagerInstance;
      },
      requestSubscribeMessage: async (options: RequestSubscribeMessageOptions) => {
        const apiName: string = 'requestSubscribeMessage';
        return new Promise(async (resolve) => {
          try {
            const enableCode = await enableNotification();
            if (enableCode.errMsg === 'success') {
              const addSlotCode = await addNotificationManagerSlot(options)
              console.log('requestSubscribeMessage', JSON.stringify(addSlotCode))
              if (addSlotCode.errMsg == 'success') {
                return resolve(addSlotCode);
              } else {
                return resolve(addSlotCode);
              }
            } else {
              return resolve(enableCode);
            }
          } catch (paramError) {
            let enableCode: SubscribeMessageOptions = {
              errCode: (paramError as BusinessError).code,
              errMsg: `${apiName}:fail error ${(paramError as BusinessError).message}`
            }
            return resolve(enableCode);
          }
        })
      },
      saveDataUrlToFile: (options: SaveDataUrlOptions) => {
        try {
          let tmpFilePath = `internal://cache/${Date.now()}_${options.url.split('/').splice(-1, 1).toString()}`;
          const data = options.data.split(',');
          if (data.length !== 2) {
            options.fail({ errMsg: 'Invalid data' })
            return;
          }
          if (data[0].startsWith('data:text/html')) {
            tmpFilePath += '.html';
          }
          const cachePath = switchInternalToHapSandBox(options.filePath || tmpFilePath);
          const base64 = new util.Base64Helper();
          const buf = base64.decodeSync(data[1]);
          const file = fs.openSync(cachePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
          fs.write(file.fd, buf.buffer).then(() => {
            options.success({ tempFilePath: options.filePath || tmpFilePath });
          }).catch((err: BusinessError) => {
            options.fail({ errMsg: err.message });
          }).finally(() => {
            fs.closeSync(file.fd);
          })
        } catch (err) {
          options.fail({ errMsg: 'error' });
        }
      },
      setCapsuleState: (visible: boolean) => {
        this.capsuleController.changeCapsuleState(visible);
      },
      getCapsuleState: () => {
        return { visible: this.capsuleController.getCapsuleState() }
      },
      chooseMediaAssets: (options: ChooseMediaOptions) => {
          selectMediaAssets(options, this.chooseAlbumCallback!)
      },
      exitMiniProgram: (options?: ExitMiniProgramOptions) => {
        try {
          context.terminateSelf()
            .then(() => {
              options && options.success()
            })
            .catch((err: BusinessError) => {
              options && options.fail()
            });
        } catch (err) {
          options && options.fail()
        }
        options && options.complete()
      }
    };
  }
}
