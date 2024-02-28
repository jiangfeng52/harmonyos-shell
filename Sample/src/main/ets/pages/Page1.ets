import { RouterUtils } from '@hybrid/web-container/src/main/ets/utils/RouterUtils';

@Entry
@Component
struct Page1 {
  @State message: string = '加 载 首 页';
  url: string = 'resource://rawfile/index.html?from=native'

  build() {
    Row() {
      Column() {
        Button(this.message)
          .width(120)
          .backgroundColor(0xF55A42)
          .onClick(() => {
            RouterUtils.LoadPageWithWebUrl(this.url, 1);
          });
      }
      .width('100%')
    }
    .height('100%')
  }
}