import common from '@ohos.app.ability.common';
import { TaroWebController } from '../components/TaroWeb';
import { TaroWebContainer } from '../components/TaroWebContainer';
import { InjectObject } from '../interfaces/InjectObject';
import { GlobalThis } from '../utils/GlobalThis';
import { Storage } from '../utils/Storage';
import { DebugLayout } from './DebugDialog';
import { TaroHybridManager } from './TaroHybridManager';
import { TaroHybridUtils } from './TaroHybridUtils';
import bundleManager from '@ohos.bundle.bundleManager';

export interface TaroHybridCoreBuilderData {
  domain: string
  indexHtmlPath: string
  taroPath: string
  taroWebController: TaroWebController
}

@Builder
export function TaroHybridCoreBuilder(builderData: TaroHybridCoreBuilderData) {
  TaroHybridCore({
    domain: builderData.domain,
    indexHtmlPath: builderData.indexHtmlPath,
    taroPath: builderData.taroPath
  })
}

@Component
struct TaroHybridCore {
  @Prop indexHtmlPath: string;
  @Prop taroPath: string;
  @Prop domain: string;
  @State taroWebController: TaroWebController = TaroHybridManager.getCoreInstance(this.indexHtmlPath)?.builderData.taroWebController ?? new TaroWebController()
  @State isDebug: boolean = (GlobalThis.getInstance().getContext('context') as common.UIAbilityContext).applicationInfo.debug
  @State useCache: boolean = true
  injectObj: InjectObject = TaroHybridManager.getInjectNativeMethod()
  @State storage: Storage = new Storage(GlobalThis.getInstance().getContext('context') as common.UIAbilityContext,
    bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).name)

  // debugLayout相关
  private debugLayoutHeight: number = 300;
  @State debugLayoutVisible: Visibility = Visibility.None

  aboutToAppear(): void {

  }

  webUrl(domain: string, indexHtmlPath: string, taroPath: string){
    let webUrl = `${domain}${indexHtmlPath}#${taroPath}`
    return TaroHybridUtils.addQueryParamToHash(webUrl, 'from', 'native')
  }

  @Builder
  taroWebLayout(){
    TaroWebContainer({
      webUrl: this.webUrl(this.domain, this.indexHtmlPath, this.taroPath),
      webUrlPrefix: `${this.domain}/`,
      // want: this.want, // want信息
      taroWebController: this.taroWebController,
      useCache: this.useCache,
      isFullScreen: false, // 是否全屏显示
      injectObj: this.injectObj,
      showCapsule: false,
      storage: this.storage
    })
      .width('100%')
      .height('100%')
  }

  @Builder
  debugFrameLayout(){
    Column(){
      DebugLayout({
        devDomain: this.domain,
        indexHtmlPath: this.indexHtmlPath,
        taroPath: this.taroPath,
        useCache: this.useCache,
        refresh: (domain: string, indexHtmlPath: string, taroPath: string, useCache: boolean)=>{
          this.useCache = useCache
          this.debugLayoutVisible = this.debugLayoutVisible == Visibility.Visible ? Visibility.None : Visibility.Visible
          if (useCache) {
            this.taroWebController.webController.loadUrl(this.webUrl(this.domain, this.indexHtmlPath, this.taroPath))
          } else {
            this.taroWebController.webController.loadUrl(this.webUrl(domain, indexHtmlPath, taroPath))
          }
        }
      })
        .height(this.debugLayoutHeight)
        .width('100%')
        .backgroundColor("#44bbccaa")
        .visibility(this.debugLayoutVisible)
        .position({
          x: 0,
          y: this.debugLayoutVisible == Visibility.Visible ? 0 : -this.debugLayoutHeight
        })
      Stack({alignContent: Alignment.TopEnd}){
        this.taroWebLayout()
        Button(`${this.debugLayoutVisible == Visibility.Visible ? '收起' : '调试'}`,  { type: ButtonType.Capsule, stateEffect: false })
          .backgroundColor(0x317aff)
          .height(25)
          .margin({top: 5, right: 5})
          .onClick(()=>{
            this.debugLayoutVisible = this.debugLayoutVisible == Visibility.Visible ? Visibility.None : Visibility.Visible
          })
      }
      .width("100%")
      .layoutWeight(1)
      .position({
        x: 0,
        y:  this.debugLayoutVisible == Visibility.Visible ? this.debugLayoutHeight : 0
      })
    }
    .width("100%")
    .height("100%")
  }

  build() {
    Column(){
      if (this.isDebug) {
        this.debugFrameLayout()
      } else {
        this.taroWebLayout()
      }
    }
  }
}