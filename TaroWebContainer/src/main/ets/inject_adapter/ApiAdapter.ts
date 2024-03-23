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

/**
 * 注入（API）对象适配器
 */


export class ApiAdapter {
  constructor(useOsChannel) {
    this.navigationBarHeight = 0;
    this.systemBarHeight = 0;
    this.launchOptions = '';
    this.useOsChannel = useOsChannel
  }

  launchOptions: string
  navigationBarHeight: number
  systemBarHeight: number
  useOsChannel: boolean

  setLaunchOptions(launchOptions: string) {
    this.launchOptions = launchOptions
  }

  setNavigationBarHeight(height: number) {
    this.navigationBarHeight = height
  }

  setSystemBarHeight(height: number) {
    this.systemBarHeight = height
  }

  readRawFileSync(relativePath: string, decoder: util.TextDecoder, context: common.UIAbilityContext){
    let content = context.resourceManager.getRawFileContentSync(relativePath)
    return decoder.decodeWithStream(content, { stream: false });
  }

  getRunJavaScript(): string {
    let context = GlobalThis.getInstance().getContext('context') as common.UIAbilityContext;
    let textDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: true });

    const jsBridgeChannel = this.readRawFileSync('app.js', textDecoder, context)
    const osChannel = this.readRawFileSync('osChannelApi.js', textDecoder, context)

    let result: string = `
      window.addEventListener('unhandledrejection', (event) => {
         console.info('[ADSAPI] unhandledrejection: ', event);
      })
      if(typeof(adapterInited) === 'undefined'){
          var navigationHeight = ${this.navigationBarHeight};
          var systemBarHeight = ${this.systemBarHeight};
          var customLaunchOptions = '${this.launchOptions}';
          var isOsChannel = ${this.useOsChannel};
          ${jsBridgeChannel};
          ${this.useOsChannel? osChannel : ''};
          adapterInited = true;
      }`
    return result
  }
}
