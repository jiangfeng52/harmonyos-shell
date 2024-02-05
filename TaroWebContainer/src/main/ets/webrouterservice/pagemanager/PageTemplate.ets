import { wbLogger } from '../../utils/Logger';
import { WebManager } from '../webmanager/webManager';
import { WebNode } from '../webmanager/WebNode';
import { router } from '@kit.ArkUI';
import { GlobalRouter } from '../globalrouter/GlobalRouter';
import { RouterStorage } from '../globalrouter/RouterStorage';

const TAG: string = 'zhou PageTemplate'

@Entry
@Component
struct PageTemplate {
  @State url: string = '';
  @State isRefresh: boolean = false;
  @State isDownTree: boolean = false;
  webId = 1;
  node?: WebNode;

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
    if (curUrl === 'resource://rawfile/index.htmlxxxx') {
      wbLogger.info(TAG, `处理二次回退逻辑`);
    } else {
      return GlobalRouter.getInstance().onBackPress();
    }
  }

  build() {
    Row() {
      NodeContainer(this.isRefresh ? this.node : this.node)
    }
  }
}

interface routerParam {
  url: string
}