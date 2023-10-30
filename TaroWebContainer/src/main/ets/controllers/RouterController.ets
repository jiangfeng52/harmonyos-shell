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

import webView from '@ohos.web.webview';
import router from '@ohos.router';

/**
 * 路由控制，当页面栈不空则弹页面
 */
export class RouterController {
  public webController: webView.WebviewController;

  constructor() {
    this.webController = new webView.WebviewController();
  }

  // 当页面栈不空则弹页面, 否则则web页面回退
  public backWord(): boolean {
    if (Number(router.getLength()) > 1) {
      router.back();
      return true;
    } else if (this.webController.accessBackward()) {
      console.log("[TaroWeb] backWord:webViewController")
      this.webController.backward();
      return true;
    }
    return false;
  }
}
