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
import { NaviController } from '../controllers/NaviController';
import { RouterController } from '../controllers/RouterController';

const DEFAULT_TITLE_LEFT = 40;

/**
 * NavigationBar，自定义导航栏
 */
@Component
export struct NavigationBar {
  @ObjectLink naviController: NaviController;
  @Consume routerController: RouterController;

  build() {
    if (this.naviController.visible) {
      Column() {
        Row() {
          if (this.naviController.canBackward) {
            Image($r('app.media.back'))
              .fillColor(this.naviController.barFrontColor)
              .width(25)
              .height(25)
              .margin({ left: 26 })
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                this.routerController.backWord();
              })
              .id('backBtn')
          }
          Text(this.naviController.title)
            .fontSize(20)
            .margin({ left: this.naviController.canBackward ? 0 : DEFAULT_TITLE_LEFT })
            .align(Alignment.Start)
          if (this.naviController.loading) {
            LoadingProgress()
              .width(25)
              .height(25)
              .margin({ left: 5 })
              .foregroundColor(this.naviController.barFrontColor)
          }
          Blank()
        }
        .height(this.naviController.titleHeight + this.naviController.paddingBottom + this.naviController.systemBarHeight)
        .width('100%')
        .alignItems(VerticalAlign.Bottom)
        .padding({ bottom: this.naviController.paddingBottom })
      }
      .backgroundColor(this.naviController.barColor)
      .foregroundColor(this.naviController.barFrontColor)
      .animation({
        duration: this.naviController.animationDuration,
        curve: this.naviController.animationCurve,
        delay: 0,
        iterations: 1,
        playMode: PlayMode.Normal
      })
      .justifyContent(FlexAlign.End)
    }
  }
}
