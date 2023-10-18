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

import web_webview from '@ohos.web.webview'

@Preview
@Component
export struct TitleBar {
  @Prop title: string = '';
  @Prop canBackward: boolean = false;
  @Prop navTitleHeight: number = 32;
  @Prop navLoading: boolean = false;
  @Prop navBarColor: string ='#FFFFFF'
  @Prop navBarFrontColor: string = '#000000';
  @Prop navAnimationDuration: number = 0;
  @Prop navAnimationCurve: number = Curve.Linear;
  @Prop systemBarHeight: number = 40;
  @Prop paddingBottom: number = 8;
  private webController: web_webview.WebviewController | undefined
  static readonly DEFAULT_TITLE_LEFT = 40

  build() {
    Column() {
      Row() {
        if (this.canBackward) {
          Image($r('app.media.back'))
            .width(25)
            .height(25)
            .margin({ left: 26 })
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              this.webController?.backward();
              this.navLoading = false;
            })
            .id('backBtn')
        }
        Text(this.title)
          .fontSize(20)
          .margin({ left: this.canBackward ? 0 : TitleBar.DEFAULT_TITLE_LEFT })
          .align(Alignment.Start)
        if (this.navLoading) {
          LoadingProgress()
            .width(25)
            .height(25)
            .margin({ left: 5 })
            .foregroundColor(this.navBarFrontColor)
         }
        Blank()
      }
      .height(this.navTitleHeight + this.paddingBottom + this.systemBarHeight)
      .width('100%')
      .alignItems(VerticalAlign.Bottom)
      .padding({ bottom: this.paddingBottom })
    }
    .backgroundColor(this.navBarColor)
    .foregroundColor(this.navBarFrontColor)
    .animation({
      duration: this.navAnimationDuration,
      curve: this.navAnimationCurve,
      delay: 0,
      iterations: 1,
      playMode: PlayMode.Normal
    })
    .justifyContent(FlexAlign.End)
  }
}