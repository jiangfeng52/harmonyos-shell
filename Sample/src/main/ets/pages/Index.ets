import webView from '@ohos.web.webview';
import Want from '@ohos.app.ability.Want';
import { TaroWebContainer, InjectObject, HostPageState, TaroWebController, Logger, LoggerLevel } from 'web-container';

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
  @LocalStorageLink('refresh') refresh: boolean = false;

  @State taroWebController: TaroWebController = new TaroWebController()

  // 用户可以自定义对象注入到Web环境中，如使用native.sayHello格式进行调用
  nativeObj: InjectObject = {
    sayHello: () => console.log('Hello World'),
  };

  onBackPress() {
    if (this.taroWebController.accessBackward()) {
      this.taroWebController.backward();
      return true;
    }
    return false;
  }

  aboutToAppear() {
    webView.WebviewController.setWebDebuggingAccess(true);
    Logger.setLogLevel(LoggerLevel.LOG_DEBUG);
  }

  onPageShow() {
    this.pageState = HostPageState.PageOnShow;
    if (this.refresh) {
      this.taroWebController.loadUrl(this.entryUrl());
      this.refresh = false;
    }
  }

  onPageHide() {
    this.pageState = HostPageState.PageOnHide;
  }

  entryUrl(): string {
    return this.taroWebController.getIndexUrl(this.entryDomain, this.useBuildIn);
  }

  build() {
    Column() {
      TaroWebContainer({
        pageState: this.pageState, // 页面状态同步到组件
        indexUrl: this.entryUrl(), // 初始Url
        useBuildIn: this.useBuildIn, // 是否使用内置的rawfile资源
        entryDomain: this.entryDomain, // 远程资源域名
        want: this.want, // want信息
        taroWebController: this.taroWebController,
        isFullScreen: true, // 是否全屏显示
        injectObj: this.nativeObj, // 注入对象
      })
        .width('100%')
        .height('100%')
    }
  }
}
