import { wbLogger } from '../../utils/Logger';
import { WebManager } from '../webmanager/webManager';
import { WebNode } from '../webmanager/WebNode';
import { router } from '@kit.ArkUI';
import { GlobalRouter } from '../globalrouter/GlobalRouter';
import { RouterStorage } from '../globalrouter/RouterStorage';
import { ChannelInstance } from '../../inject_adapter/Channel';
import { RouterUtils } from '../../utils/RouterUtils';

const TAG: string = 'zhou PageTemplate'

@Entry
@Component
struct PageTemplate {
  @State url: string = 'resource://rawfile/index.html?from=native';
  @State isRefresh: boolean = false;
  @State isDownTree: boolean = false;
  @Provide index: number = 1;
  @StorageProp('tabBarVisible') tabBarVisible: boolean = true;
  webId = 1;
  node?: WebNode;
  @State i: number = 0

  onPageShow(): void {
    wbLogger.info(TAG, `onPageShow 执行上树 this.isDownTree=` + this.isDownTree);
    this.node = WebManager.getInstance().getNode(this.webId);
    this.node?.add();
    if (this.node !== undefined && this.isDownTree) {
      wbLogger.info(TAG, `onPageShow rebuild`);
      this.node.rebuild();
    }
    this.isRefresh = !this.isRefresh;
  }

  aboutToAppear(): void {
    wbLogger.info(TAG, `aboutToAppear`);
    if (router.getParams()) {
      this.url = (router.getParams() as routerParam).url;
      this.index = (router.getParams() as routerParam).index ? (router.getParams() as routerParam).index : 1;
      this.tabBarVisible = this.index < 3 ? true : false
    }else {
      WebManager.getInstance().loadUrl(this.url)
    }
  }

  onPageHide(): void {
    wbLogger.info(TAG, `onPageHide 执行下树`);
    if (this.node !== undefined) {
      this.node.remove();
      this.node = undefined;
      this.isRefresh = !this.isRefresh;
      this.isDownTree = true;
    }
  }

  //右滑回退，web回退web/原生
  onBackPress(): boolean | void {
    let controller = RouterStorage.getInstance().getController();
    let curUrl: string = controller.webController.getUrl();
    wbLogger.info(TAG, `onBackPress curUrl=` + curUrl);
    //处理二次回退逻辑
    // if (curUrl === 'resource://rawfile/index.html?from=native#/pages/api/device/screen/index' && this.i<1) {
    if (curUrl.includes('screen') && this.i<1) {
      wbLogger.info(TAG, `处理二次回退逻辑`);
      let object:ESObject= {"call":"","args":["ohos not support path"],"stubId":0}
      ChannelInstance.jsCall("MethodChannel", object)
      this.i = this.i + 1
      return true
    } else {
      this.i = 0
      return GlobalRouter.getInstance().onBackPress();
    }
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      main().visibility(this.index === 1 ? Visibility.Visible : Visibility.Hidden)
      NodeContainer(this.isRefresh ? this.node : this.node)
        .visibility(this.index != 1 ? Visibility.Visible : Visibility.Hidden)
      customTabBar().visibility(this.tabBarVisible ? Visibility.Visible : Visibility.Hidden)
    }
  }
}

interface routerParam {
  url: string,
  index: number
}

@Component
struct main {
  @Consume index: number

  build() {
    Column({ space: 20 }) {
      Text('首页原生')
      Button('原生到原生').onClick(() => {
        router.pushUrl({ url: 'pages/Developer' })
      })
      Button('原生到web').onClick(() => {
        RouterUtils.LoadPageWithWebUrl("resource://rawfile/index.html#/pages/api/device/bluetoothGeneral/index?from=native", 5);
      })
    }.width('100%').height('100%').justifyContent(FlexAlign.Center)
  }
}


@Component
struct customTabBar {
  @Consume index: number

  build() {
    Row() {
      Column() {
        Image(this.index == 0 ? $r('app.media.component_select') : $r('app.media.component'))
          .size({ width: 25, height: 25 })
        Text('组件')
          .fontSize(16)
          .fontColor(this.index == 0 ? '#4A90E2' : '#000000')
      }
      .alignItems(HorizontalAlign.Center)
      .height('100%')
      .layoutWeight(1)
      .onClick(() => {
        let curUrl = RouterStorage.getInstance().getController().webController.getUrl()
        if (curUrl != "resource://rawfile/index.html#/pages/component/index/index") {
          WebManager.getInstance().loadUrl("resource://rawfile/index.html#/pages/component/index/index");
        }
        this.index = 0;
      })

      Column() {
        Image(this.index == 1 ? $r('app.media.home_select') : $r('app.media.home'))
          .size({ width: 25, height: 25 })
        Text('首页')
          .fontSize(16)
          .fontColor(this.index == 1 ? '#4A90E2' : '#000000')
      }
      .alignItems(HorizontalAlign.Center)
      .height('100%')
      .layoutWeight(1)
      .onClick(() => {
        this.index = 1;
      })

      Column() {
        Image(this.index == 2 ? $r('app.media.api_select') : $r('app.media.api'))
          .size({ width: 25, height: 25 })
        Text('接口')
          .fontSize(16)
          .fontColor(this.index == 2 ? '#4A90E2' : '#000000')
      }
      .alignItems(HorizontalAlign.Center)
      .height('100%')
      .layoutWeight(1)
      .onClick(() => {
        let curUrl = RouterStorage.getInstance().getController().webController.getUrl()
        if (curUrl != "resource://rawfile/index.html#/pages/api/index/index") {
          WebManager.getInstance().loadUrl("resource://rawfile/index.html#/pages/api/index/index");
        }
        this.index = 2;
      })
    }
    .backgroundColor('#DBDBDB')
    .width('100%')
    .height(60)
  }
}