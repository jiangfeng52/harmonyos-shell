import { WebManager } from '@hybrid/web-container/src/main/ets/webrouterservice/webmanager/webManager'
import { router } from '@kit.ArkUI';
import { RouterUtils } from '@hybrid/web-container/src/main/ets/utils/RouterUtils';
import { RouterStorage } from '@hybrid/web-container/src/main/ets/webrouterservice/globalrouter/RouterStorage';

@Entry
@Component
struct Page1 {
  @State message: string = '加 载 首 页';
  url: string = 'resource://rawfile/index.html?from=native'

  aboutToAppear(): void {
    WebManager.getInstance().initNode(RouterStorage.getInstance().getUIContext());
  }
  build() {
    Row() {
      Column() {
        Button(this.message)
          .width(120)
          .backgroundColor(0xF55A42)
          .onClick(() => {
            RouterUtils.LoadPageWithWebUrl(this.url);
          });
      }
      .width('100%')
    }
    .height('100%')
  }
}