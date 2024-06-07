import { BuilderNode } from '@ohos.arkui.node';
import { TaroHybridCoreBuilder, TaroHybridCoreBuilderData } from './TaroHybridCore';
import common from '@ohos.app.ability.common';
import HashMap from '@ohos.util.HashMap';
import { TaroHybridUtils } from './TaroHybridUtils';
import { GlobalThis } from '../utils/GlobalThis';
import { TaroWebController } from '../components/TaroWeb';
import { InjectObject } from '../interfaces/InjectObject';
import { taroLogger } from '../utils/Logger';
import { taroTrace } from '../utils/Trace';
import { taroStorage } from '../inject_adapter/TaroStorage';
import { bundleManager } from '@kit.AbilityKit';

export class TaroHybridCoreInstance {
  private builderNode: BuilderNode<TaroHybridCoreBuilderData[]> | undefined
  builderData: TaroHybridCoreBuilderData

  constructor(domain: string, indexHtmlPath: string, taroPath: string, injectObj: InjectObject, forceDarkAccess: boolean) {
    this.builderData = {
      domain: domain,
      indexHtmlPath: indexHtmlPath,
      taroPath: taroPath,
      taroWebController: new TaroWebController(),
      injectObj: injectObj,
      forceDarkAccess: forceDarkAccess
    }
  }

  getBuilderNode(uiContext: UIContext){
    if (!this.builderNode) {
      this.builderNode = new BuilderNode(uiContext)
      this.builderNode.build(
          wrapBuilder<TaroHybridCoreBuilderData[]>(TaroHybridCoreBuilder),
          this.builderData
        )
      taroLogger.debug(
        'TaroHybrid',
        '%{public}s create BuilderNode',
        [this.builderData.indexHtmlPath]);
    }
    return this.builderNode
  }

  dispose(){
    if (this.builderNode) {
      this.builderNode.dispose()
      this.builderNode = undefined

      taroLogger.debug(
        'TaroHybrid',
        '%{public}s dispose BuilderNode',
        [this.builderData.indexHtmlPath]);
    }
  }
}

export interface TaroHybridManagerOptions {
  uiAbilityContex: common.UIAbilityContext
  domain: string
  injectNativeMethod: (indexHtmlPath: string, uiAbilityContext: common.UIAbilityContext) => InjectObject,
  rootIndexHtmlPath?: string,
  nativeBack: ()=>void,
  forceDarkAccess: boolean
}

export class TaroHybridManager {
  private static options: TaroHybridManagerOptions | null = null
  private static builderInstanceMaps: HashMap<string, TaroHybridCoreInstance> = new HashMap();
  // 回收机制：引用计数
  private static referenceCountMap: HashMap<string, number> = new HashMap();

  private static debuggable = false

  static init(options: TaroHybridManagerOptions){
    TaroHybridManager.options = options
    GlobalThis.getInstance().setContext('context', options.uiAbilityContex);
    taroStorage.init(options.uiAbilityContex, bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).name)
  }

  static setDebuggable(debuggable: boolean) {
    TaroHybridManager.debuggable = debuggable
    taroLogger.setLoggable(debuggable)
  }

  static openTrace(){
    taroTrace.setOpen(true)
  }

  static getDebuggable() {
    return TaroHybridManager.debuggable
  }

  static isRootContainer(indexHtmlPath: string){
    const rootIndexHtmlPath = TaroHybridManager.options?.rootIndexHtmlPath
    if(!rootIndexHtmlPath) {
      // 默认情况，如果没有设置rootIndexHtmlPath，默认都是true
      return true
    }
    return indexHtmlPath === rootIndexHtmlPath
  }

  static preLoader(uiContext: UIContext, indexHtmlPath: string, taroPath: string){
    const instance = TaroHybridManager.getOrCreateCoreInstance(indexHtmlPath, taroPath)
    instance.getBuilderNode(uiContext)
  }
  static getOrCreateCoreInstance(indexHtmlPath: string, taroPath: string): TaroHybridCoreInstance{
    let builderInstance = TaroHybridManager.builderInstanceMaps.get(indexHtmlPath)
    if (!builderInstance){
      builderInstance = new TaroHybridCoreInstance(
        TaroHybridManager?.options?.domain??'',
        indexHtmlPath,
        taroPath,
        TaroHybridManager?.options?.injectNativeMethod(indexHtmlPath, GlobalThis.getInstance().getContext('context') as common.UIAbilityContext) ?? {},
        TaroHybridManager?.options?.forceDarkAccess?? false
      )
      // 一定要先保存到Map里，再build
      TaroHybridManager.builderInstanceMaps.set(indexHtmlPath, builderInstance)
    }

    return builderInstance
  }
  static appear(indexHtmlPath: string){
    let count = TaroHybridManager.referenceCountMap.get(indexHtmlPath) ?? 0;
    TaroHybridManager.referenceCountMap.set(indexHtmlPath, count + 1)
  }
  static disappear(indexHtmlPath: string){
    let count = TaroHybridManager.referenceCountMap.get(indexHtmlPath) ?? 0;
    if(count > 1) {
      TaroHybridManager.referenceCountMap.set(indexHtmlPath, count - 1)
    } else {
      // 回收
      TaroHybridManager.referenceCountMap.remove(indexHtmlPath)
      const instance = TaroHybridManager.builderInstanceMaps.remove(indexHtmlPath)
      instance.dispose()
    }
  }

  static getCoreInstance(indexHtmlPath: string): TaroHybridCoreInstance | undefined{
    return TaroHybridManager.builderInstanceMaps.get(indexHtmlPath)
  }
  static loadUrl(indexHtmlPath: string, taroPath: string){
    const instance = TaroHybridManager.getCoreInstance(indexHtmlPath)
    if (!instance) {
      return ;
    }
    const data = instance.builderData
    let webUrl = `${data.domain}${indexHtmlPath}#${taroPath}`
    webUrl = TaroHybridUtils.addQueryParamToHash(webUrl, 'from', 'native')

    //如果处于未激活状态loadUrl会失效
    data.taroWebController.webController.onActive();
    data.taroWebController.loadUrl(webUrl);
  }

  static nativeBack(){
    TaroHybridManager.options?.nativeBack()
  }

  static onBack(taroWebController: TaroWebController, indexHtmlPath: string, rootTaroPage: string): boolean {
    // const instance = TaroHybridManager.getCoreInstance(indexHtmlPath)
    // if (!instance) {
    //   return false;
    // }
    // const data = instance.builderData

    // let controller = data.taroWebController;

    const rootPagePath = `${indexHtmlPath}#${rootTaroPage}`

    let curUrl = taroWebController.webController.getUrl();

    // 当前如果是根页面，即使accessBackward = true，也不返回了，模拟原生的体验
    if(curUrl.includes(rootPagePath)) {
      // 回退到原生
      return false;
    }

    if (curUrl.includes('?from=native') || curUrl.includes('&from=native')) {  //web回退到原生
      // Web先返回
      if (taroWebController.accessBackward()) {
        setTimeout(()=>{
          taroWebController.backward();
        }, 200)
      }
      // 回退到原生
      return false;
    }

    if (taroWebController?.accessBackward()) { // web回退
      taroWebController?.backward();
      // 保留在当前Web页面
      return true;
    }

    // 回退到原生
    return false;
  }

}