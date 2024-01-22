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
import { NativeApiImplInstance } from '../inject_adapter/NativeApi';
import { ChannelInstance, MethodChannelInstance } from '../inject_adapter/Channel';

const TARO_WEB_TAG = 'TaroWeb';

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

  aboutToAppear() {
    webView.WebviewController.setWebDebuggingAccess(this.enableWebDebug);
    // this.scriptProxy = this.apiAdapter.getAdapterProxy();
    this.taroWebController.hasBindedTaroWeb = true
    this.taroWebController.addRequestHandler(this.handleInternalResource);
    this.taroWebController.addRequestHandler(this.useLocalCacheResource);

    MethodChannelInstance.registerMethod('NativeApi$getWindowInfoBridgeSync', (options: ESObject) => {
      return NativeApiImplInstance.getWindowInfoBridgeSync()
    })

    MethodChannelInstance.registerMethod('NativeApi$getSystemInfoSyncBridgeSync', (options: ESObject) => {
      return NativeApiImplInstance.getSystemInfoSyncBridgeSync(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$getSystemSettingBridgeSync', (options: ESObject) => {
      return NativeApiImplInstance.getSystemSettingBridgeSync(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$getAppBaseInfoBridgeSync', (options: ESObject) => {
      return NativeApiImplInstance.getAppBaseInfoBridgeSync(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$getAppAuthorizeSettingBridgeSync', (options: ESObject) => {
      return NativeApiImplInstance.getAppAuthorizeSettingBridgeSync(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$requestBridgeAsync', (options: ESObject) => {
      return NativeApiImplInstance.requestBridgeAsync(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$downloadFileBridgeAsync', (options: ESObject) => {
      return NativeApiImplInstance.downloadFileBridgeAsync(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$uploadFileBridgeAsync', (options: ESObject) => {
      return NativeApiImplInstance.uploadFileBridgeAsync(options)
    })

    // MethodChannelInstance.registerMethod('NativeApi$getUserInfoBridgeSync', (options: ESObject) => {
    //   return NativeApiImplInstance.getUserInfoBridgeSync(options)
    // })

    MethodChannelInstance.registerMethod('NativeApi$saveImageToPhotosAlbumBridgeAsync', (options: ESObject) => {
      return NativeApiImplInstance.saveImageToPhotosAlbumBridgeAsync(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$getVideoInfoBridgeAsync', (options: ESObject) => {
      return NativeApiImplInstance.getVideoInfoBridgeAsync(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$getImageInfoBridgeAsync', (options: ESObject) => {
      return NativeApiImplInstance.getImageInfoBridgeAsync(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$getLocationBridgeAsync', (options: ESObject) => {
      return NativeApiImplInstance.getLocationBridgeAsync(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$openDocumentBridgeAsync', (options: ESObject) => {
      return NativeApiImplInstance.openDocumentBridgeAsync(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$setKeepScreenOnBridgeAsync', (options: ESObject) => {
      return NativeApiImplInstance.setKeepScreenOnBridgeAsync(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$onUserCaptureScreenBridgeSync', (options: ESObject) => {
      return NativeApiImplInstance.onUserCaptureScreenBridgeSync(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$hideKeyboardBridgeSync', (options: ESObject) => {
      return NativeApiImplInstance.hideKeyboardBridgeAsync(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$makePhoneCall', (options: ESObject) => {
      return NativeApiImplInstance.makePhoneCall(options)
    })

    //NativeFileSystemManager
    // MethodChannelInstance.registerMethod('NativeApi$saveFileBridgeAsync', (options: ESObject) => {
    //   return NativeApiImplInstance.saveFileBridgeAsync(options)
    // })
    //
    // MethodChannelInstance.registerMethod('NativeApi$accessBridgeAsync', (options: ESObject) => {
    //   return NativeApiImplInstance.accessBridgeAsync(options)
    // })
    //
    // MethodChannelInstance.registerMethod('NativeApi$getFileInfoBridgeAsync', (options: ESObject) => {
    //   return NativeApiImplInstance.getFileInfoBridgeAsync(options)
    // })
    //
    // MethodChannelInstance.registerMethod('NativeApi$readFileBridgeAsync', (options: ESObject) => {
    //   return NativeApiImplInstance.readFileBridgeAsync(options)
    // })
    //
    // MethodChannelInstance.registerMethod('NativeApi$readFileSyncBridgeSync', (options: ESObject) => {
    //   return NativeApiImplInstance.readFileSyncBridgeSync(options)
    // })

    // //NativeAContextApi
    // MethodChannelInstance.registerMethod('NativeApi$createInnerAudioContextBridgeSync', (options: ESObject) => {
    //   return NativeApiImplInstance.createInnerAudioContextBridgeSync(options)
    // })
    //
    // MethodChannelInstance.registerMethod('NativeApi$stopBridgeSync', (options: ESObject) => {
    //   return NativeApiImplInstance.stopBridgeSync()
    // })
    //
    // MethodChannelInstance.registerMethod('NativeApi$playBridgeSync', (options: ESObject) => {
    //   return NativeApiImplInstance.playBridgeSync()
    // })
    //
    // MethodChannelInstance.registerMethod('NativeApi$onPlayBridgeSync', (options: ESObject) => {
    //   return NativeApiImplInstance.onPlayBridgeSync(options)
    // })
    //
    // MethodChannelInstance.registerMethod('NativeApi$onStopBridgeSync', (options: ESObject) => {
    //   return NativeApiImplInstance.onStopBridgeSync(options)
    // })
    //
    // MethodChannelInstance.registerMethod('NativeApi$onErrorBridgeSync', (options: ESObject) => {
    //   return NativeApiImplInstance.onErrorBridgeSync(options)
    // })
    //
    // MethodChannelInstance.registerMethod('NativeApi$onEndedBridgeSync', (options: ESObject) => {
    //   return NativeApiImplInstance.onEndedBridgeSync(options)
    // })
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
    if (this.useCache && this.webUrlPrefix) {
      const path: string | undefined = url?.replace(this.webUrlPrefix, '');
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
            return ChannelInstance.call(channelType, objectJson) as object
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
  }
}
