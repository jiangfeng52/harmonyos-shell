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
import uri from '@ohos.uri'
import common from '@ohos.app.ability.common'
import { BusinessError } from '@ohos.base'
import Want from '@ohos.app.ability.Want'
import bundleManager from '@ohos.bundle.bundleManager';
import { InnerInjectObj, MenuButtonOptions, ErrorMsg } from '../interfaces/InjectObject';
import {
  getBundleUsedPermission,
  getBundleWxScopeList,
  openPermissionsInSystemSettings
} from '../utils/PermissionMapScopeUtil';
import { NavigationBarData } from '../components/NavigationBar';
import { wbLogger } from '../utils/Logger';

const NATIVE_TAG = 'NativeInject';

/**
 * Native注入类，实现一些跟壳工程比较紧密关联的Taro API
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

  constructor(navigationBarData: NavigationBarData, capsuleOptions: MenuButtonOptions) {
    this.navigationBarData = navigationBarData;
    this.systemBarHeight = 0;
    this.windowWidth = 0;
    this.permissionInfo = [];
    this.capsuleOptions = capsuleOptions
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

  public buildInjectObj(): InnerInjectObj {
    return {
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
          resolve({errMsg: ''});
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
            query = uriInfo.query;
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
              reject({ errMsg: 'invalid appid or path scheme' }  as ErrorMsg);
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
      },
      openSetting: (options) => {
        const apiName: string = 'openSetting';
         // 接口返回
        return new Promise(async (resolve, reject) => {
          try {
            const bundleScope = await getBundleWxScopeList(this.permissionInfo);
            const bundleUsedScope = getBundleUsedPermission(bundleScope.allScope, bundleScope.bundleScope);
            // 打开应用的权限列表
            openPermissionsInSystemSettings();
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
            const bundleScope = await getBundleWxScopeList(this.permissionInfo);
            const bundleUsedScope = getBundleUsedPermission(bundleScope.allScope, bundleScope.bundleScope);
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
    };
  }
}
