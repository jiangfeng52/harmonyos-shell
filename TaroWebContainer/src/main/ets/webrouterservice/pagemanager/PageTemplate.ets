import { wbLogger } from '../../utils/Logger';
import { WebManager } from '../webmanager/webManager';
import { WebNode } from '../webmanager/WebNode';
import { router } from '@kit.ArkUI';
import { PageManager } from './PageManager';
import { GlobalRouter } from '../globalrouter/GlobalRouter';

const TAG: string = 'zhou PageTemplate'

@Entry
@Component
struct PageTemplate {
  @State url: string = '';
  @State isRefresh: boolean = false;
  @State canLoad: boolean = false;
  webId = 1;
  node?: WebNode;

  onPageShow(): void {
    wbLogger.info(TAG, `onPageShow 执行上树`);
    this.node = WebManager.getInstance().getNode(this.webId);
    this.node?.add();
    if (this.node !== undefined) {
      wbLogger.info(TAG, `onPageShow rebuild`);
      this.node.rebuild();
    }
    this.isRefresh = !this.isRefresh;
    this.canLoad = false;
  }

  aboutToAppear(): void {
    wbLogger.info(TAG, `aboutToAppear`);
    this.canLoad = true;
    if (router.getParams()) {
      this.url = (router.getParams() as routerParam).url;
    }
    this.isRefresh = !this.isRefresh;
  }

  onPageHide(): void {
    wbLogger.info(TAG, `onPageHide 执行下树`);
    if (this.node !== undefined) {
      this.node.remove();
      this.node = undefined;
      this.isRefresh = !this.isRefresh;
    }
  }

  onBackPress(): boolean | void {
    wbLogger.info(TAG, `onBackPress`);
    let curUrl = PageManager.getInstance().gerCurrentUrl();
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