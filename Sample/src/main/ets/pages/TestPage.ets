import { RouterUtils } from '@hybrid/web-container/src/main/ets/utils/RouterUtils';

@Entry
@Component
struct TestPage {
  @State message: string = '原生跳转到web';
  @State url: string = 'resource://rawfile/index.html#/pages/api/redirection/index?from=native'

  build() {
    Row() {
      Column() {
        Button(this.message)
          .width(150)
          .backgroundColor(0xF55A42)
          .onClick(() => {
            RouterUtils.LoadPageWithWebUrl(this.url, 4);
          });
      }
      .width('100%')
    }
    .height('100%')
  }
}