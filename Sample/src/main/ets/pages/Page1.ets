import { WebManager } from '@hybrid/web-container/src/main/ets/webrouterservice/webmanager/webManager'
import { router } from '@kit.ArkUI';
import { GlobalRouter } from '@hybrid/web-container/src/main/ets/webrouterservice/globalrouter/GlobalRouter';

@Entry
@Component
struct Page1 {
  @State message: string = '加 载 首 页';
  url: string = 'resource://rawfile/index.html'

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
              params: { url: this.url }
            });
          })
      }
      .width('100%')
    }
    .height('100%')
  }

  onBackPress(): boolean | void {
    return GlobalRouter.getInstance().onBackPress();
  }
}