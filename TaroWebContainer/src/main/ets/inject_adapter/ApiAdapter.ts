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
import util from '@ohos.util';
import { GlobalThis } from '../utils/GlobalThis';
import common from '@ohos.app.ability.common';
import AppContext from '@ohos.app.ability.common'

/**
 * 注入（API）对象适配器
 */


export class ApiAdapter {
  constructor() {
    this.navigationBarHeight = 0;
    this.systemBarHeight = 0;
    this.launchOptions = '';
  }

  launchOptions: string
  navigationBarHeight: number
  systemBarHeight: number

  setLaunchOptions(launchOptions: string) {
    this.launchOptions = launchOptions
  }

  setNavigationBarHeight(height: number) {
    this.navigationBarHeight = height
  }

  setSystemBarHeight(height: number) {
    this.systemBarHeight = height
  }

  getRunJavaScript(): string {
    let context = GlobalThis.getInstance().getContext('context') as common.UIAbilityContext;
    let manager = context.getApplicationContext().createModuleContext('TaroWebContainer').resourceManager;
    let fileContent = manager.getRawFileContentSync('app.js')
    console.log('zhou', 'getRawFileContentSync after')
    let textDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: true });
    let channelScript = textDecoder.decodeWithStream(fileContent, { stream: false });

    let result: string = `
      window.addEventListener('unhandledrejection', (event) => {
         console.info('[ADSAPI] unhandledrejection: ', event);
      })
        var pageMap = new Map();
        pageMap.set('/pages/api/routing/index', 'pages/TestPage');
        pageMap.set('/pages/api/routing/index1', 'pages/Developer1');

      if(typeof(adapterInited) === 'undefined'){
          var navigationHeight = ${this.navigationBarHeight};
          var systemBarHeight = ${this.systemBarHeight};
          var customLaunchOptions = '${this.launchOptions}';
          ${channelScript};
          adapterInited = true;
      }`

    return result
  }
}
