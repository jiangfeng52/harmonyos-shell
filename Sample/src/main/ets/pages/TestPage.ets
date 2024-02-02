import { WebManager } from '@hybrid/web-container/src/main/ets/webrouterservice/webmanager/webManager';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct TestPage {
  @State message: string = '从原生页面跳转到web页面';
  @State url: string = 'resource://rawfile/index.html#/pages/api/redirection/index?from=native'

  build() {
    Row() {
      Column() {
        Button(this.message)
          .width(120)
          .backgroundColor(0xF55A42)
          .onClick(() => {
            WebManager.getInstance().loadUrl(this.url)
            router.pushUrl({
              url: '@bundle:com.advanced.temp/TaroWebContainer/ets/webrouterservice/pagemanager/PageTemplate',
              params: { url: this.url}
            });
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}