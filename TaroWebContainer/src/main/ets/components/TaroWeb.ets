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
import { NativeApiImplInstance } from '../inject_adapter/NativeApi'
import { ChannelInstance, MethodChannelInstance } from '../inject_adapter/Channel';

const TARO_WEB_TAG = 'TaroWeb';

export type InterceptRequestHandler = (request: WebResourceRequest) => WebResourceResponse | null;

@Observed
export class TaroWebController {
  public webController: webview.WebviewController;
  public hasBindedTaroWeb: boolean;
  public callbacks: InterceptRequestHandler[];

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

  accessBackward(): boolean {
    if (!this.hasBindedTaroWeb) {
      return false;
    }
    return this.webController.accessBackward();
  }

  backward() {
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
  scriptProxy: ESObject;
  localLastPath: string = ''

  aboutToAppear() {
    this.scriptProxy = this.apiAdapter.getAdapterProxy();
    this.taroWebController.hasBindedTaroWeb = true
    this.taroWebController.addRequestHandler(this.handleInternalResource);
    this.taroWebController.addRequestHandler(this.useLocalCacheResource);

    // TODO arkTS不支持，暂没有想到解决方案
    // MethodChannelInstance.registerMethods(NativeApiImplInstance)
    MethodChannelInstance.registerMethod('getWindowInfo', (options: ESObject)=>{
      return NativeApiImplInstance.getWindowInfo()
    })
    MethodChannelInstance.registerMethod('openSystemBluetoothSetting', (options: ESObject)=>{
      return NativeApiImplInstance.openSystemBluetoothSetting(options)
    })
    MethodChannelInstance.registerMethod('onWindowResize', (object: ESObject)=>{
      return NativeApiImplInstance.onWindowResize(object)
    })

    ChannelInstance.setRunJavascriptFun((jsCode: string)=>{
      try {
          this.taroWebController.webController.runJavaScript(jsCode, (error, result) => {
              if (error) {
                wbLogger.error(TARO_WEB_TAG, `Run JavaScript error: ${JSON.stringify(error)}`)
                return;
              }
              // if (result) {
              //   wbLogger.info(TARO_WEB_TAG, `The asFinish() return value is: ${result}`)
              // }
            });
        } catch (error) {
          wbLogger.error(TARO_WEB_TAG, `runJavaScript error: ${(error as BusinessError).message}`);
        }
    })
    // LocalUpdateManagerInstance.onUpdateReady((updatedPath: string)=>{
    //   this.localLastPath = updatedPath
    //   this.taroWebController.loadUrl(this.webUrl)
    //   wbLogger.debug('TaroWeb', 'onUpdateReady updatedPath=%{public}s', updatedPath)
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

      if (this.localLastPath != '') {
        wbLogger.debug('TaroWeb', 'useLocalCacheResource path=%{public}s', path)
        // 走本地缓存
        if(!path || !FileUtils.fileExist(this.localLastPath, path)) {
          return null;
        }
        return FileUtils.getFileOnResponseWeb(this.localLastPath, path)
      }

      // 走App内置的Raw缓存
      if (!path || !RawUtils.rawfileExist(path)) {
        return null;
      }
      return RawUtils.getRawfileOnResponseWeb(path)
    }
    return null;
  }

  // // TODO-ly 临时写法
  //     this.adapter.mergeInjectObj({
  //       nativeCall: (call: string, argsJson: string, objectId: number) => {
  //         wbLogger.debug('nativeObj', `nativeCall ${call}(${argsJson}) objectId=${objectId}`)
  //         // NativeApiStubInstance.onTransact(call, argsJson, objectId)
  //       },
  //     })

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
            wbLogger.debug('nativeObj', `channelType ${channelType} objectJson(${objectJson})`)
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
        // try {
        //   this.taroWebController.webController.runJavaScript(
        //     this.apiAdapter.getRunJavaScript(),
        //     (error, result) => {
        //       if (error) {
        //         wbLogger.error(TARO_WEB_TAG, `Run JavaScript error: ${JSON.stringify(error)}`)
        //         return;
        //       }
        //       if (result) {
        //         wbLogger.info(TARO_WEB_TAG, `The asFinish() return value is: ${result}`)
        //       }
        //     });
        // } catch (error) {
        //   wbLogger.error(TARO_WEB_TAG, `runJavaScript error: ${(error as BusinessError).message}`);
        // }
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
