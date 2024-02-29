import Want from '@ohos.app.ability.Want';
import Url from '@ohos.url';
import { TaroWebContainer, InjectObject, HostPageState, TaroWebController, Logger, LoggerLevel, wbLogger, Storage } from '@hybrid/web-container';
import bundleManager from '@ohos.bundle.bundleManager';
import common from '@ohos.app.ability.common';


const SAMPLE_INDEX_TAG = 'SampleIndex';
const defaultEntryDomain = 'resource://rawfile/';
let storage = LocalStorage.getShared() // 获取共享的本地存储对象

PersistentStorage.persistProp('enableDevDomain', false)
PersistentStorage.persistProp('devDomain', 'http://10.253.108.182:10086/')

@Entry(storage)
@Component
struct TaroMpharmonySample {
  @LocalStorageProp('want') want: Want = {};
  @State pageState: HostPageState = HostPageState.PageInit;
  @StorageLink('enableDevDomain') enableDevDomain: boolean = false;
  @StorageLink('devDomain') devDomain: string = '';
  @LocalStorageLink('refresh') refresh: boolean = false;

  @State taroWebController: TaroWebController = new TaroWebController();
  // 初始化数据库
  @State storage: Storage = new Storage(getContext(this) as common.UIAbilityContext,
    bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).name)

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
    Logger.setLogLevel(LoggerLevel.LOG_DEBUG);
  }

  onPageShow() {
    this.pageState = HostPageState.PageOnShow;
    if (this.refresh) {
      this.taroWebController.loadUrl(this.webUrl());
      this.refresh = false;
    }
  }

  onPageHide() {
    this.pageState = HostPageState.PageOnHide;
  }

  webUrl(): string {
    return `${this.enableDevDomain ? this.devDomain : defaultEntryDomain }index.html`;
  }

  webUrlPrefix() {
    try {
      const url = Url.URL.parseURL(this.webUrl());
      return `${url.protocol}//${url.host}/`;
    } catch (err) {
      wbLogger.error(SAMPLE_INDEX_TAG, `Invalid webUrl: ${this.webUrl()}`);
      return '';
    }
  }

  useCache() {
    return !this.enableDevDomain;
  }

  // 数据共享样例函数
  putData(){
    this.storage.put("11", 'hello world', () => {})
  }

  getData(){
    this.storage.get('onLaunch', (err, data) => {
      if (err) {
        console.log(JSON.stringify(err))
      } else {
        console.log(`success to get data: ${ data }`, )
      }
    })
  }

  build() {
    Column() {
      TaroWebContainer({
        pageState: this.pageState, // 页面状态同步到组件
        webUrl: this.webUrl(), // 初始Url
        webUrlPrefix: this.webUrlPrefix(),
        useCache: this.useCache(),
        want: this.want, // want信息
        taroWebController: this.taroWebController,
        isFullScreen: true, // 是否全屏显示
        injectObj: this.nativeObj, // 注入对象
        storage: this.storage,
      })
        .width('100%')
        .height('100%')
    }
  }
}
