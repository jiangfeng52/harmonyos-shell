import { BuilderNode } from '@kit.ArkUI'
import { TaroWebController } from '../components/TaroWeb'
import { InjectObject } from '../interfaces/InjectObject'
import { taroLogger } from '../utils/Logger'
import { TaroHybridCoreBuilder, TaroHybridCoreBuilderData } from './TaroHybridCore'

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
        this.builderData.indexHtmlPath);
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
        this.builderData.indexHtmlPath);
    }
  }
}