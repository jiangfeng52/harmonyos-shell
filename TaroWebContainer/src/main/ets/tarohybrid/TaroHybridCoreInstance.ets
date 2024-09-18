import { BuilderNode } from '@kit.ArkUI'
import { TaroWebController } from '../components/TaroWeb'
import { taroLogger } from '../utils/Logger'
import { TaroHybridCoreBuilder, TaroHybridCoreBuilderData } from './TaroHybridCore'

export function getFromParameter(url: string): number {
  const fromMatch = url.match(/[?&]tarofrom=(native(?:_\d+)?)(?:&|$)/);
  const from = fromMatch ? fromMatch[1] : null;
  let number: number = -1;

  if (from) {
    // 尝试从from参数中提取数字
    const numberMatch = from.match(/native_(\d+)/);
    number = numberMatch ? parseInt(numberMatch[1], 10) : 1;
  }
  return number
}

export interface NativeNavigateListener {
  nativeNavigateTo(url: string): void;
  nativeNavigateBack(delta: number): void;
}


export class TaroHybridCoreInstance {
  private builderNode: BuilderNode<TaroHybridCoreBuilderData[]> | undefined
  builderData: TaroHybridCoreBuilderData
  nativeNavigateListener: NativeNavigateListener | undefined

  constructor(domain: string, indexHtmlPath: string, taroPath: string, forceDarkAccess: boolean) {
    this.builderData = {
      domain: domain,
      indexHtmlPath: indexHtmlPath,
      taroPath: taroPath,
      taroWebController: new TaroWebController(),
      forceDarkAccess: forceDarkAccess
    }
  }
  setNativeNavigateListener(nativeNavigateListener: NativeNavigateListener){
    this.nativeNavigateListener = nativeNavigateListener;
  }

  navigateTo(taroPath: string) {
    let taroPathFromNative = taroPath.includes('?') ? `${taroPath}&tarofrom=native` : `${taroPath}?tarofrom=native`
    this.nativeNavigateListener?.nativeNavigateTo(taroPathFromNative)
  }

  navigateBack(rootTaroPage: string): boolean {
    const taroWebController = this.builderData.taroWebController
    const indexHtmlPath = this.builderData.indexHtmlPath

    const rootPagePath = `${indexHtmlPath}#${rootTaroPage}`

    let curUrl = taroWebController.webController.getUrl();

    // 当前如果是根页面，即使accessBackward = true，也不返回了，模拟原生的体验
    if(curUrl.includes(rootPagePath)) {
      // 回退到原生
      return false;
    }

    const nativeBack = getFromParameter(curUrl)

    if(nativeBack > 0) { //web回退到原生
      // Web先返回
      setTimeout(()=>{
        this.nativeNavigateListener?.nativeNavigateBack(nativeBack)
      }, 200)
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