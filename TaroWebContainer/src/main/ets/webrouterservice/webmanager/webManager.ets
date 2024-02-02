import web_webview from '@ohos.web.webview'
import { NavigationBarData } from '../../components/NavigationBar';
import { ApiAdapter } from '../../inject_adapter/ApiAdapter';
import { CapsuleController, MenuButtonOptions } from '../../interfaces/InjectObject';
import { wbLogger } from '../../utils/Logger';
import { WebNode } from './WebNode';
import { RouterStorage } from '../globalrouter/RouterStorage';
import { common } from '@kit.AbilityKit';
import { NativeInject } from '../../inject_adapter/NativeInject';

const TAG: string = 'zhou WebManager'

export class WebManager {
  private static instance: WebManager;
  private context: UIContext | null = null;
  private webIdleMap: Map<number, WebNode> = new Map();
  private adapter: ApiAdapter | undefined;
  // 显示胶囊
  showCapsule: boolean = true;
  // 导航栏状态控制器
  navigationBarData: NavigationBarData = new NavigationBarData();
  capsuleOptions: MenuButtonOptions = { width: 50, height: this.navigationBarData.titleHeight, marginRight: 16 };
  capsuleController: CapsuleController = {
    changeCapsuleState: (visible: boolean) => {
      this.showCapsule = visible;
    },
    getCapsuleState: () => {
      return this.showCapsule;
    }
  }

  public static getInstance(): WebManager {
    if (!WebManager.instance) {
      WebManager.instance = new WebManager();
    }
    return WebManager.instance;
  }

  getNode(webId: number) {
    return this.webIdleMap.get(webId);
  }

  public initNode(context: UIContext) {
    wbLogger.info(TAG, `createWebInstance`);
    this.context = context;
    let webIndex = 1;
    let webNode = new WebNode();
    let controller: web_webview.WebviewController = new web_webview.WebviewController();
    this.adapter = new ApiAdapter();
    this.adapter.setWebController(controller);
    RouterStorage.getInstance().setController(controller);
    RouterStorage.getInstance().setAdapter(this.adapter);
    RouterStorage.getInstance().setWebNode(webNode);

    const nativeInject = new NativeInject(this.navigationBarData, this.capsuleOptions, this.capsuleController);
    const contexts = getContext(this) as common.UIAbilityContext;
    this.adapter.mergeInjectObj(nativeInject.buildInjectObj(contexts));

    webNode?.initWeb('', this.context as UIContext, controller, webIndex, this.adapter);
    this.webIdleMap.set(webIndex, webNode);
  }

  public loadUrl(url: string) {
    wbLogger.info(TAG, `loadUrl, url = ` + url);
    let controller = RouterStorage.getInstance().getController();
    controller?.loadUrl(url);
  }
}