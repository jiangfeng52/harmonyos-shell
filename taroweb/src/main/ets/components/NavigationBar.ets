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

import router from '@ohos.router';
import { RouterUtils } from '../utils/RouterUtils'

@Preview
@Component
export struct NavigationBar {
  @Prop navVisible: boolean = true;
  @Prop title: string = '导航栏';
  @Prop canBackward: boolean = true;
  @Prop navLoading: boolean = true;
  @Prop showCapsule: boolean = true;


  build() {
    RelativeContainer() {
      if(this.navVisible) {
        if (this.canBackward) {
          Image($r('app.media.back'))
            .width(25)
            .height(25)
            .margin({ left: 20 })
            .objectFit(ImageFit.Contain)
            .alignRules({
              left: {anchor: '__container__', align: HorizontalAlign.Start},
              center: {anchor: '__container__', align: VerticalAlign.Center}
            })
            .onClick(() => {
              router.back()
            })
            .id('backBtn')
        }
        Text(this.title)
          .fontSize(20)
          .margin({left: 20})
          .alignRules({
            left: {anchor: 'backBtn', align: HorizontalAlign.End},
            center: {anchor: '__container__', align: VerticalAlign.Center}
          })
          .id('title')
        if (this.navLoading) {
          LoadingProgress()
            .color(Color.Blue)
            .width(30)
            .height(30)
            .margin({ left: 5 })
            .alignRules({
              left: {anchor: 'title', align: HorizontalAlign.End},
              center: {anchor: '__container__', align: VerticalAlign.Center}
            })
            .id('loading')
        }
      }

      if(this.showCapsule) {
        Image($r("app.media.capsule"))
          .width(50)
          .height(25)
          .borderRadius(10)
          .borderColor('#FFFFFF')
          .borderWidth(1)
          .backgroundColor('#FFFFFF')
          .margin({right: 5})
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            RouterUtils.pushUrlWithLog('pages/Capsule')
          })
          .alignRules({
            right: {anchor: '__container__', align: HorizontalAlign.End},
            center: {anchor: '__container__', align: VerticalAlign.Center}
          })
          .id('capsuleBtn')
      }
    }
    .width('100%')
    .height(40)
  }
}