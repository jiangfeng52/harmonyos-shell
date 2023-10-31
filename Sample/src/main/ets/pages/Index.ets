import webView from '@ohos.web.webview'
import Want from '@ohos.app.ability.Want'
import { TaroWebContainer, InjectObject, HostPageState, RouterController } from 'TaroWebContainer';

let storage = LocalStorage.getShared() // 获取共享的本地存储对象

PersistentStorage.persistProp('entryDomain', 'http://10.253.108.182:10086/')
PersistentStorage.persistProp('useBuildIn', true)

@Entry(storage)
@Component
struct TaroMpharmonySample {
  @LocalStorageProp('want') want: Want = {};
  @State pageState: HostPageState = HostPageState.PageInit;
  @StorageLink('entryDomain') entryDomain: string = '';
  @StorageLink('useBuildIn') useBuildIn: boolean = true;
  @LocalStorageLink('refresh') @Watch('refreshWeb') refresh: boolean = false;

  routerController: RouterController = new RouterController();

  // 用户可以自定义对象注入到Web环境中，如使用native.sayHello格式进行调用
  nativeObj: InjectObject = {
    sayHello: () => console.log('Hello World'),
  };

  onBackPress() {
    return this.routerController.backWord();
  }

  aboutToAppear() {
    webView.WebviewController.setWebDebuggingAccess(true);
  }

  onPageShow() {
    this.pageState = HostPageState.PageOnShow;
  }

  onPageHide() {
    this.pageState = HostPageState.PageOnHide;
  }

  refreshWeb() {
    if (this.refresh) {
      this.routerController.webController.loadUrl(this.entryUrl());
      this.refresh = false;
    }
  }

  entryUrl(): string{
    return `${this.entryDomain}index.html`
  }

  build() {
    Column() {
      TaroWebContainer({
        pageState: this.pageState, // 页面状态同步到组件
        indexUrl: this.entryUrl(), // 初始Url
        useBuildIn: this.useBuildIn, // 是否使用内置的rawfile资源
        entryDomain: this.entryDomain, // 远程资源域名
        want: this.want, // want信息
        routerController: this.routerController, // 页面路由控制
        isFullScreen: true, // 是否全屏显示
        injectObj: this.nativeObj, // 注入对象
      })
        .width('100%')
        .height('100%')
    }
  }
}
