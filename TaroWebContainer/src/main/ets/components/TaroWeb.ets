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

    MethodChannelInstance.registerMethod('NativeApi$getWindowInfo', (options: ESObject) => {
      return NativeApiImplInstance.getWindowInfo()
    })

    MethodChannelInstance.registerMethod('NativeApi$getSystemInfoSync', (options: ESObject) => {
      return NativeApiImplInstance.getSystemInfoSync(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$getSystemSetting', (options: ESObject) => {
      return NativeApiImplInstance.getSystemSetting(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$getAppBaseInfo', (options: ESObject) => {
      return NativeApiImplInstance.getAppBaseInfo(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$getAppAuthorizeSetting', (options: ESObject) => {
      return NativeApiImplInstance.getAppAuthorizeSetting(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$request', (options: ESObject) => {
      return NativeApiImplInstance.request(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$downloadFile', (options: ESObject) => {
      return NativeApiImplInstance.downloadFile(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$getUserInfo', (options: ESObject) => {
      return NativeApiImplInstance.getUserInfo(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$saveImageToPhotosAlbum', (options: ESObject) => {
      return NativeApiImplInstance.saveImageToPhotosAlbum(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$getVideoInfo', (options: ESObject) => {
      return NativeApiImplInstance.getVideoInfo(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$getImageInfo', (options: ESObject) => {
      return NativeApiImplInstance.getImageInfo(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$getLocation', (options: ESObject) => {
      return NativeApiImplInstance.getLocation(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$openDocument', (options: ESObject) => {
      return NativeApiImplInstance.openDocument(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$setKeepScreenOn', (options: ESObject) => {
      return NativeApiImplInstance.setKeepScreenOn(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$onUserCaptureScreen', (options: ESObject) => {
      return NativeApiImplInstance.onUserCaptureScreen(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$hideKeyboard', (options: ESObject) => {
      return NativeApiImplInstance.hideKeyboard(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$makePhoneCall', (options: ESObject) => {
      return NativeApiImplInstance.makePhoneCall(options)
    })

    // NativeFileSystemManager
    MethodChannelInstance.registerMethod('NativeApi$saveFile', (options: ESObject) => {
      return NativeApiImplInstance.saveFile(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$access', (options: ESObject) => {
      return NativeApiImplInstance.access(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$getFileInfo', (options: ESObject) => {
      return NativeApiImplInstance.getFileInfo(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$readFile', (options: ESObject) => {
      return NativeApiImplInstance.readFile(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$readFileSync', (options: ESObject) => {
      return NativeApiImplInstance.readFileSync(options)
    })

    //NativeAContextApi
    MethodChannelInstance.registerMethod('NativeApi$createInnerAudioContext', (options: ESObject) => {
      return NativeApiImplInstance.createInnerAudioContext(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$innerAudioStop', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.innerAudioStop(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$innerAudioPlay', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.innerAudioPlay(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$innerAudioOnPlay', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.innerAudioOnPlay(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$innerAudioOnStop', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.innerAudioOnStop(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$innerAudioOnError', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.innerAudioOnError(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$innerAudioOnEnded', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.innerAudioOnEnded(options, objectId)
    })

    // NativeUploadFile
    MethodChannelInstance.registerMethod('NativeApi$uploadFile', (options: ESObject) => {
      return NativeApiImplInstance.uploadFile(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$abort', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.abort(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$offHeadersReceived', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.offHeadersReceived(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$offProgressUpdate', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.offProgressUpdate(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$onHeadersReceived', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.onHeadersReceived(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$onProgressUpdate', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.onProgressUpdate(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$getAudioContextVolume', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.getAudioContextVolume(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$setAudioContextVolume', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.setAudioContextVolume(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$getAudioContextStartTime', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.getAudioContextStartTime(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$setAudioContextStartTime', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.setAudioContextStartTime(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$getAudioContextPlaybackRate', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.getAudioContextPlaybackRate(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$setAudioContextPlaybackRate', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.setAudioContextPlaybackRate(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$getAudioContextPaused', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.getAudioContextPaused(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$setAudioContextPaused', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.setAudioContextPaused(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$getAudioContextObeyMuteSwitch', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.getAudioContextObeyMuteSwitch(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$setAudioContextObeyMuteSwitch', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.setAudioContextObeyMuteSwitch(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$getAudioContextLoop', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.getAudioContextLoop(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$setAudioContextLoop', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.setAudioContextLoop(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$getAudioContextDuration', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.getAudioContextDuration(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$setAudioContextDuration', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.setAudioContextDuration(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$getAudioContextCurrentTime', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.getAudioContextCurrentTime(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$setAudioContextCurrentTime', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.setAudioContextCurrentTime(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$getAudioContextBuffered', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.getAudioContextBuffered(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$setAudioContextBuffered', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.setAudioContextBuffered(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$getAudioContextAutoplay', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.getAudioContextAutoplay(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$setAudioContextAutoplay', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.setAudioContextAutoplay(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$getAudioContextSrc', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.getAudioContextSrc(options, objectId)
    })

    MethodChannelInstance.registerMethod('NativeApi$setAudioContextSrc', (options: ESObject, objectId: number) => {
      return NativeApiImplInstance.setAudioContextSrc(options, objectId)
    })
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
