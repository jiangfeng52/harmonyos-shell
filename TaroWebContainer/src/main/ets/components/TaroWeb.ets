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
import { RawUtils } from '../utils/RawUtils'
import webview from '@ohos.web.webview';

@Observed
export class TaroWebController {
  public webController: webview.WebviewController;
  public hasBindedTaroWeb: boolean;

  constructor() {
    this.webController = new webview.WebviewController();
    this.hasBindedTaroWeb = false;
  }

  loadUrl(url: string | Resource, headers?: Array<webview.WebHeader>){
    if (!this.hasBindedTaroWeb) {
      return;
    }
    this.webController.loadUrl(url)
    this.webController.accessBackward();
  }

  accessBackward(): boolean{
    if (!this.hasBindedTaroWeb) {
      return false;
    }
    return this.webController.accessBackward();
  }

  backward(){
    if (!this.hasBindedTaroWeb) {
      return ;
    }
    this.webController.backward();
  }

}

/**
 * TaroWeb，定制化Web组件
 */
@Component
export struct TaroWeb {
  @Prop currentUrl: string;
  onTitleReceive?: (title: string) => void;
  onRefreshAccessedHistory?: ()=>void;
  src: string = '';

  @Prop entryDomain: string;
  @Prop useBuildIn: boolean;
  @ObjectLink taroWebController: TaroWebController;
  apiAdapter: ApiAdapter = new ApiAdapter();

  aboutToAppear() {
    this.taroWebController.hasBindedTaroWeb = true
  }

  aboutToDisappear() {
    this.taroWebController.hasBindedTaroWeb = false
  }

  build() {
    Web({ src: this.src, controller: this.taroWebController.webController })
      .fileAccess(true)
      .domStorageAccess(true)
      .mixedMode(MixedMode.All)
      .databaseAccess(true)
      .geolocationAccess(true)
      .javaScriptAccess(true)
      .javaScriptProxy({
        object: this.apiAdapter.getAdapterProxy(),
        name: 'as',
        methodList: this.apiAdapter.getMethodList() || [],
        controller: this.taroWebController.webController,
      })
      .onConsole((event) => {
        console.log('[TaroWeb] ' + event?.message.getMessage())
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
                console.error(`[TaroWeb] Run JavaScript error: ` + JSON.stringify(error))
                return;
              }
              if (result) {
                console.info(`[TaroWeb] The asFinish() return value is: ${result}`)
              }
            });
        } catch (error) {
          console.error(`[TaroWeb] runJavaScript error: ${(error as BusinessError).message}`);
        }
      })
      .onInterceptRequest((event) => { // 当web组件加载url之前触发该回调，用于拦截url并返回响应数据。
        const url = event?.request.getRequestUrl()
        if (url && url.startsWith('internal:')) {
          const responseWeb = new WebResourceResponse();
          const path: string = switchInternalToHapSandBox(url);
          if (File.accessSync(path)) {
            const file: File.File = File.openSync(path, File.OpenMode.READ_ONLY);
            const fd: number = file.fd;
            responseWeb.setResponseData(fd);
            responseWeb.setResponseCode(200);
            responseWeb.setReasonMessage('OK');
            responseWeb.setResponseIsReady(true)
            console.info(`[ADSAPI] responseWeb`)
          }
          else {
            console.info(`[ADSAPI] This file is not exist`)
          }
          return responseWeb
        }
        else if( this.useBuildIn && url && url.startsWith(this.entryDomain)) {
          const path: string|undefined = url?.replace(this.entryDomain,'');
          if (!path || !RawUtils.rawfileExist(path)) {
            return null;
          }

          return RawUtils.getRawfileOnResponseWeb(path)
        }
        return null
      })
      .onSslErrorEventReceive((event) => { // 通知用户加载资源时发生SSL错误
        console.info(`[TaroWeb] onSslErrorEventReceive:${event.error}`)
        event.handler.handleConfirm() // 通知Web组件继续使用SSL证书
        return true
      })
      .onTitleReceive((event) => {
        this.onTitleReceive && this.onTitleReceive(event?.title ?? '')
        // if (event && this.currentUrl !== event.title) {
        //   this.naviController.title = event.title;
        // }
        // this.naviController.canBackward = this.routerController.webController.accessBackward();
      })
      .onRefreshAccessedHistory(() => {
        this.onRefreshAccessedHistory && this.onRefreshAccessedHistory();
        // this.naviController.loading = false;
      })
    }
}
