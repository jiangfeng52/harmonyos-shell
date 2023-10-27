
import {PermissionInfo } from '../../../../../taroweb/src/main/ets/adapter/interface'
import { TaroWeb } from '@ohos/taroweb'

PersistentStorage.persistProp('entryDomain', 'http://10.253.108.182:10086/')
PersistentStorage.persistProp('useBuildIn', true)
let storage = LocalStorage.getShared() // 获取共享的本地存储对象
@Entry(storage)
@Component
struct WebComponent {
  @StorageLink('entryDomain') entryDomain: string = ''
  @StorageLink('useBuildIn') useBuildIn: boolean = true
  @LocalStorageLink('refresh') refresh:boolean = false

  @LocalStorageLink('launchOptions') launchOptions: string = '{}';
  @LocalStorageLink('windowWidth') windowWidth: number = 0;
  @LocalStorageLink('permissionInfos') permissionInfos: Array<PermissionInfo> = [];

  // 生命周期方法，返回
  onBackPress() {
    // try {
    //   if (this.controller.accessBackward()) { // 当前页面是否可以后退，即当前页面是否有返回历史记录
    //     this.controller.backward(); // 按照历史栈，后退一个页面。
    //     return true
    //   }
    // } catch (error) {
    //   console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
    // }
    // return false
  }

  onPageShow() {
    // try {
    //   if (this.controller.getUrl() !== this.url) {
    //     console.info("[ADSAPI] onPageShow load url: " + this.url);
    //     this.controller.loadUrl(this.url);
    //   }
    // } catch (e) {
    //   console.info("[ADSAPI] load url fail");
    // }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      TaroWeb({
        entryDomain: this.entryDomain,
        useBuildIn: this.useBuildIn,
        launchOptions: this.launchOptions,
        windowWidth: this.windowWidth,
        permissionInfos: this.permissionInfos
      })
        .width('100%')
        .height('100%')
    }
    .width('100%')
    .height('100%')
  }
}