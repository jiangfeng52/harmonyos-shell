import { FrameNode, NodeController } from '@ohos.arkui.node'
import { TaroHybridManager } from './TaroHybridManager'
import { HostPageState } from '../interfaces/HostPageState'
import { TaroHybridCoreInstance } from './TaroHybridCoreInstance'

@Component
export struct TaroHybrid {
  private taroHybridCoreController: TaroWebNodeController | null = null;
  @Prop indexHtmlPath: string
  @Prop taroPath: string
  // 同步宿主页面的状态
  @Prop @Watch('onPageStateUpdated') pageState: HostPageState;

  onPageStateUpdated(): void {
    switch (this.pageState) {
      case HostPageState.PageInit:
        break;
      case HostPageState.PageOnShow:
        this.taroHybridCoreController?.onPageShow();
        break;
      case HostPageState.PageOnHide:
        this.taroHybridCoreController?.onPageHide()
        break;
    }
  }

  aboutToAppear(): void {
    const instance = TaroHybridManager.getOrCreateCoreInstance(this.indexHtmlPath, this.taroPath)
    this.taroHybridCoreController = new TaroWebNodeController(instance)
    TaroHybridManager.appear(this.indexHtmlPath)
  }
  aboutToDisappear(): void {
    TaroHybridManager.disappear(this.indexHtmlPath)
  }

  build() {
      NodeContainer(this.taroHybridCoreController)
  }
}

class TaroWebNodeController extends NodeController {

  private isPageShow: boolean = false
  private coreInstance: TaroHybridCoreInstance

  constructor(coreInstance: TaroHybridCoreInstance) {
    super();
    this.coreInstance = coreInstance
  }


  onPageShow() {
    this.isPageShow = true
    this.rebuild();
  }

  onPageHide() {
    this.isPageShow = false
    this.rebuild();
  }

  makeNode(uiContext: UIContext): FrameNode | null {
    if(!this.isPageShow) {
      return null
    }

    return this.coreInstance.getBuilderNode(uiContext).getFrameNode()
  }
}
