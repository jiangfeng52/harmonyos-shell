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
import { GlobalRouter } from '../webrouterservice/globalrouter/GlobalRouter';

const DEFAULT_TITLE_LEFT = 40;

@Observed
export class NavigationBarData {
  public title: string = '';
  public canBackward: boolean = false;
  public titleHeight: number = 32;
  public loading: boolean = false;
  public barColor: string = '#FFFFFF'
  public barFrontColor: string = '#000000';
  public animationDuration: number = 0;
  public animationCurve: number = Curve.Linear;
  public systemBarHeight: number = 40;
  public visible: boolean = true;
  public paddingBottom: number = 8;
}

/**
 * NavigationBar，自定义导航栏
 */
@Component
export struct NavigationBar {
  @ObjectLink navigationBarData: NavigationBarData;
  onBackPressed?: ()=>void;
  // @Consume routerController: RouterController;

  build() {
    if (this.navigationBarData.visible) {
      Column() {
        Row() {
          if (this.navigationBarData.canBackward) {
            Image($r('app.media.back'))
              .fillColor(this.navigationBarData.barFrontColor)
              .width(25)
              .height(25)
              .margin({ left: 26 })
              .objectFit(ImageFit.Contain)
              .onClick(() => {
                GlobalRouter.getInstance().onBackPress();
                // if (this.onBackPressed) {
                //   this.onBackPressed();
                // } else {
                //   router.back()
                // }
              })
              .id('backBtn')
          }
          Row() {
            Text(this.navigationBarData.title)
              .fontSize(20)
              .margin({ left: this.navigationBarData.canBackward ? 0 : DEFAULT_TITLE_LEFT })
              .align(Alignment.Start)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
            if (this.navigationBarData.loading) {
              LoadingProgress()
                .width(25)
                .height(25)
                .margin({ left: 5 })
                .foregroundColor(this.navigationBarData.barFrontColor)
            }
          }
          .width('60%')
          .height(25)

          Blank()
        }
        .height(this.navigationBarData.titleHeight + this.navigationBarData.paddingBottom + this.navigationBarData.systemBarHeight)
        .width('100%')
        .alignItems(VerticalAlign.Bottom)
        .padding({ bottom: this.navigationBarData.paddingBottom })
      }
      .backgroundColor(this.navigationBarData.barColor)
      .foregroundColor(this.navigationBarData.barFrontColor)
      .animation({
        duration: this.navigationBarData.animationDuration,
        curve: this.navigationBarData.animationCurve,
        delay: 0,
        iterations: 1,
        playMode: PlayMode.Normal
      })
      .justifyContent(FlexAlign.End)
    }
  }
}
