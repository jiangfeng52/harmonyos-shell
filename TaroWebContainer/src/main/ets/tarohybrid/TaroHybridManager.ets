import { BuilderNode } from '@ohos.arkui.node';
import { TaroHybridCoreBuilder, TaroHybridCoreBuilderData } from './TaroHybridCore';
import common from '@ohos.app.ability.common';
import HashMap from '@ohos.util.HashMap';
import { TaroHybridUtils } from './TaroHybridUtils';
import { GlobalThis } from '../utils/GlobalThis';
import { TaroWebController } from '../components/TaroWeb';
import { InjectObject } from '../interfaces/InjectObject';

interface TaroHybridWrapBuilderInstance {
  builderNode: BuilderNode<TaroHybridCoreBuilderData[]>,
  builderData: TaroHybridCoreBuilderData
}

export interface TaroHybridManagerOptions {
  uiAbilityContex: common.UIAbilityContext
  domain: string
  injectNativeMethod: (uiAbilityContext: common.UIAbilityContext) => InjectObject
}

export class TaroHybridManager {
  private static options: TaroHybridManagerOptions | null = null
  private static builderInstanceMaps: HashMap<string, TaroHybridWrapBuilderInstance> = new HashMap();

  static init(options: TaroHybridManagerOptions){
    TaroHybridManager.options = options
    GlobalThis.getInstance().setContext('context', options.uiAbilityContex);
  }
  static getInjectNativeMethod(): InjectObject{
    return TaroHybridManager?.options?.injectNativeMethod(GlobalThis.getInstance().getContext('context') as common.UIAbilityContext) ?? {}
  }

  static preLoader(uiContext: UIContext, indexHtmlPath: string, taroPath: string){
    TaroHybridManager.createBuilderInstance(uiContext, indexHtmlPath, taroPath)
  }
  private static createBuilderInstance(uiContext: UIContext, indexHtmlPath: string, taroPath: string){
    const builderInstance:TaroHybridWrapBuilderInstance = {
      builderNode: new BuilderNode(uiContext),
      builderData: {
        domain: TaroHybridManager?.options?.domain??'',
        indexHtmlPath: indexHtmlPath, // 注意：此处需求/开头
        taroPath: taroPath, // 注意：此处需要/开头
        taroWebController: new TaroWebController()
      }
    }

    // 一定要先保存到Map里，再build
    TaroHybridManager.builderInstanceMaps.set(indexHtmlPath, builderInstance)

    builderInstance.builderNode.build(
      wrapBuilder<TaroHybridCoreBuilderData[]>(TaroHybridCoreBuilder),
      builderInstance.builderData
    )
    return builderInstance;
  }

  static getBuilderInstance(indexHtmlPath: string){
    return TaroHybridManager.builderInstanceMaps.get(indexHtmlPath)
  }

  static getBuilderNode(uiContext: UIContext, indexHtmlPath: string, taroPath: string) {
    let builderInstance = TaroHybridManager.builderInstanceMaps.get(indexHtmlPath)
    if (!builderInstance){
      builderInstance = TaroHybridManager.createBuilderInstance(uiContext, indexHtmlPath, taroPath)
    }
    return builderInstance.builderNode;
  }

  // private static sTaroWebController: TaroWebController = new TaroWebController()
  static loadUrl(indexHtmlPath: string, taroPath: string){
    const builderInstance = TaroHybridManager.builderInstanceMaps.get(indexHtmlPath)
    if (!builderInstance) {
      return ;
    }

    let webUrl = `${builderInstance.builderData.domain}${indexHtmlPath}#${taroPath}`
    webUrl = TaroHybridUtils.addQueryParamToHash(webUrl, 'from', 'native')

    //如果处于未激活状态loadUrl会失效
    builderInstance.builderData.taroWebController.webController.onActive();
    builderInstance.builderData.taroWebController.loadUrl(webUrl);
  }


  static onBack(indexHtmlPath: string): boolean {
    const builderInstance = TaroHybridManager.builderInstanceMaps.get(indexHtmlPath)
    if (!builderInstance) {
      return false
    }

    let controller = builderInstance.builderData.taroWebController;
    let curUrl = controller.webController.getUrl();

    if (curUrl?.endsWith('?from=native')) {  //web回退到原生
      // Web先返回
      if (controller.accessBackward()) {
        setTimeout(()=>{
          controller.backward();
        }, 200)
      }
      // 回退到原生
      return false;
    }

    if (controller?.accessBackward()) { // web回退
      controller?.backward();
      // 保留在当前Web页面
      return true;
    }

    // 回退到原生
    return false;
  }

}