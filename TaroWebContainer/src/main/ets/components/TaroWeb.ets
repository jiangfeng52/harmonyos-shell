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

import File from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';
import { ApiAdapter } from '../inject_adapter/ApiAdapter';
import { switchInternalToHapSandBox } from '../utils/InternalPath';
import { RawUtils } from '../utils/RawUtils';
import webview from '@ohos.web.webview';
import { wbLogger } from '../utils/Logger';
import { FileUtils } from '../utils/FileUtils';
import { LocalUpdateManagerInstance } from '../update/LocalUpdateManager';
import { AlbumBackward } from '../interfaces/Media'
import webView from '@ohos.web.webview';
import { NativeApi } from '../inject_adapter/NativeApi';
import { Channel, MethodChannel } from '../inject_adapter/Channel';
import { getAuthResults } from '../utils/PermissionMapScopeUtil';
import { as } from '../utils/advancedapi.min';
import { customPermissionPrompt } from '../utils/MediaUtil';

const TARO_WEB_TAG = 'TaroWeb';
const locationPermissionArray: number[] = [];
const playerPermissionArray: number[] = [];
const phonePermissionArray: number[] = [];


export type InterceptRequestHandler = (request: WebResourceRequest) => WebResourceResponse | null;

@Observed
export class TaroWebController {
  public webController: webview.WebviewController;
  public hasBindedTaroWeb: boolean;
  public callbacks: InterceptRequestHandler[];
  public albumBackward?: AlbumBackward;

  constructor() {
    this.webController = new webview.WebviewController();
    this.hasBindedTaroWeb = false;
    this.callbacks = [];
  }

  loadUrl(url: string | Resource, headers?: Array<webview.WebHeader>) {
    if (!this.hasBindedTaroWeb) {
      return;
    }
    try {
      this.webController.loadUrl(url);
      this.webController.accessBackward();
    } catch(err) {
      const error: BusinessError = err as BusinessError;
      wbLogger.error(TARO_WEB_TAG, `fail loadUrl, error code: ${error.code}`);
    }
  }

  setAlbumBackward(albumBackward: AlbumBackward) {
    this.albumBackward = albumBackward;
  }

  accessBackward(): boolean {
    if (this.albumBackward?.accessBackward()) {
      return this.albumBackward.accessBackward()
    }
    if (!this.hasBindedTaroWeb) {
      return false;
    }
    return this.webController.accessBackward();
  }

  backward() {
    if (this.albumBackward && this.albumBackward.accessBackward()) {
      this.albumBackward.backward();
      return;
    }
    if (!this.hasBindedTaroWeb) {
      return;
    }
    this.webController.backward();
  }

  addRequestHandler(callback: InterceptRequestHandler) {
    this.callbacks.push(callback);
  }

  interceptRequest(request: WebResourceRequest): WebResourceResponse | null {
    for (const callback of this.callbacks) {
      const response = callback(request);
      if (response) {
        return response;
      }
    }
    return null;
  }
}

/**
 * TaroWeb，定制化Web组件
 */
@Component
export struct TaroWeb {

  onTitleReceive?: (title: string) => void;
  onRefreshAccessedHistory?: () => void;
  @Prop webUrl: string;
  @Prop webUrlPrefix: string;
  @Prop useCache: boolean;
  @ObjectLink taroWebController: TaroWebController;
  apiAdapter: ApiAdapter = new ApiAdapter();
  scriptProxy: Object | undefined = undefined;
  enableWebDebug: boolean = true;
  @Link channel: Channel
  @Link methodChannel: MethodChannel
  private nativeAPI: NativeApi = new NativeApi()
  phoneContactApi: Array<string> = ['addPhoneContact']
  locationApi: Array<string> = ['getLocation', 'startLocationUpdate', 'startLocationUpdateBackground']
  playerApi: Array<string> = ['saveImageToPhotosAlbum']

  setupGlobalInterceptor() {
    as.addInterceptor({
      invoke: (args: ESObject) => {
        wbLogger.info(TARO_WEB_TAG, `[AdvancedAPI] 全局拦截器 invoke args = ` + JSON.stringify(args));
      },
      returnValue: (args: ESObject): ESObject => {
        wbLogger.info(TARO_WEB_TAG, `[AdvancedAPI] 全局拦截器 returnValue args = ` + JSON.stringify(args));
        return args
      },
      success: (args: ESObject) => {
        wbLogger.info(TARO_WEB_TAG, `[AdvancedAPI] 全局拦截器 success args = ` + JSON.stringify(args));
      },
      fail: (err: ESObject) => {
        wbLogger.info(TARO_WEB_TAG, `[AdvancedAPI] 全局拦截器 fail  ` + JSON.stringify(err));
        const errCode: string = err?.errCode
        const moduleName: string = err?.moduleName
        if (errCode && errCode == '201') {
          if (moduleName === null || moduleName === undefined) {
            return
          }

          if (this.locationApi.includes(moduleName)) {
            locationPermissionArray.push(getAuthResults())
            if (locationPermissionArray[locationPermissionArray.length - 1] === -1) {
              if (locationPermissionArray.length === 1) {
                wbLogger.info(TARO_WEB_TAG, '首次询问拒绝');
              } else {
                // 后续拒绝
                customPermissionPrompt('定位')
              }
            }
          } else if (this.playerApi.includes(moduleName)) {
            playerPermissionArray.push(getAuthResults())
            if (playerPermissionArray[playerPermissionArray.length - 1] === -1) {
              if (playerPermissionArray.length === 1) {
                wbLogger.info(TARO_WEB_TAG, '首次询问拒绝');
              } else {
                // 后续拒绝
                customPermissionPrompt('文件')
              }
            } 
          } else if (this.phoneContactApi.includes(moduleName)) {
            phonePermissionArray.push(getAuthResults())
            if (phonePermissionArray[phonePermissionArray.length - 1] === -1) {
              if (phonePermissionArray.length === 1) {
                wbLogger.info(TARO_WEB_TAG, '首次询问拒绝');
              } else {
                // 后续拒绝
                customPermissionPrompt('通讯录')
              }
            } 
          } else {
            return
          }
        }
      },
      complete: (res: ESObject) => {
        wbLogger.info(TARO_WEB_TAG, `[AdvancedAPI] 全局拦截器 complete ` + JSON.stringify(res));
      }
    })
  }

  aboutToAppear() {
    webView.WebviewController.setWebDebuggingAccess(this.enableWebDebug);
    this.taroWebController.hasBindedTaroWeb = true
    this.taroWebController.addRequestHandler(this.handleInternalResource);
    this.taroWebController.addRequestHandler(this.useLocalCacheResource);

    this.methodChannel.registerMethods('NativeApi', this.nativeAPI.nativeObj)
    this.setupGlobalInterceptor()
  }

  aboutToDisappear() {
    this.taroWebController.hasBindedTaroWeb = false
  }

  handleInternalResource: InterceptRequestHandler = (request) => {
    const url = request.getRequestUrl();
    if (url && url.startsWith('internal:')) {
      const responseWeb = new WebResourceResponse();
      const path: string = switchInternalToHapSandBox(url);
      if (File.accessSync(path)) {
        const file: File.File = File.openSync(path, File.OpenMode.READ_ONLY);
        const fd: number = file.fd;
        responseWeb.setResponseData(fd);
        responseWeb.setResponseCode(200);
        responseWeb.setReasonMessage('OK');
        responseWeb.setResponseIsReady(true);
        wbLogger.info(TARO_WEB_TAG, 'responseWeb for internal resources');
      }
      else {
        wbLogger.info(TARO_WEB_TAG, 'file resource is not exist');
      }
      return responseWeb;
    }
    return null;
  }

  useLocalCacheResource: InterceptRequestHandler = (request) => {
    const url = request.getRequestUrl();
    if (url && this.useCache && this.webUrlPrefix) {
      // const path: string | undefined = url?.replace(this.webUrlPrefix, '');
      let path: string = url.replace(this.webUrlPrefix, '');
      path = path.split('#')[0]
      wbLogger.debug('TaroWeb', 'intercepter path=%{public}s', path)

      const localLastPath = LocalUpdateManagerInstance.getLastVersionPath()
      if (localLastPath != '') {
        wbLogger.debug('TaroWeb', 'useLocalCacheResource path=%{public}s', path)
        // 走本地缓存
        if(!path || !FileUtils.fileExist(localLastPath, path)) {
          return null;
        }
        return FileUtils.getFileOnResponseWeb(localLastPath, path)
      }

      // 走App内置的Raw缓存
      if (!path || !RawUtils.rawfileExist(path)) {
        return null;
      }
      return RawUtils.getRawfileOnResponseWeb(path)
    }
    return null;
  }

  build() {
    Web({ src: this.webUrl, controller: this.taroWebController.webController })
      .fileAccess(true)
      .domStorageAccess(true)
      .mixedMode(MixedMode.All)
      .databaseAccess(true)
      .geolocationAccess(true)
      .javaScriptAccess(true)
      .javaScriptProxy({
        object: {
          nativeMethod: (channelType: string, objectJson: string) => {
            wbLogger.debug('nativeApi', `channelType ${channelType} objectJson(${objectJson})`)
            return this.channel.call(channelType, objectJson) as object
          },
        },
        name: 'JSBridge',
        methodList: ['nativeMethod'],
        controller: this.taroWebController.webController,
      })
      .onConsole((event) => {
        wbLogger.debug(TARO_WEB_TAG, `${event?.message.getMessage()}`)
        return false
      })
      .zoomAccess(false)
      .horizontalScrollBarAccess(false)
      .onPageBegin(() => {
        try {
          this.taroWebController.webController.runJavaScript(
            this.apiAdapter.getRunJavaScript(),
            (error, result) => {
              if (error) {
                wbLogger.error(TARO_WEB_TAG, `Run JavaScript error: ${JSON.stringify(error)}`)
                return;
              }
              if (result) {
                wbLogger.info(TARO_WEB_TAG, `The asFinish() return value is: ${result}`)
              }
            });
        } catch (error) {
          wbLogger.error(TARO_WEB_TAG, `runJavaScript error: ${(error as BusinessError).message}`);
        }
      })
      .onInterceptRequest((event) => { // 当web组件加载url之前触发该回调，用于拦截url并返回响应数据。
        const request = event?.request;
        if (!request) {
          return null;
        }
        return this.taroWebController.interceptRequest(request);
      })
      .onSslErrorEventReceive((event) => { // 通知用户加载资源时发生SSL错误
        wbLogger.info(TARO_WEB_TAG, `onSslErrorEventReceive:${event.error}`)
        event.handler.handleConfirm() // 通知Web组件继续使用SSL证书
        return true
      })
      .onTitleReceive((event) => {
        this.onTitleReceive && this.onTitleReceive(event?.title ?? '')
      })
      .onRefreshAccessedHistory(() => {
        this.onRefreshAccessedHistory && this.onRefreshAccessedHistory();
      })
      // .webLite(true)  // 需要 osChannel sdk
  }
}
