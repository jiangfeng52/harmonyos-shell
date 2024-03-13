import { FrameNode, NodeController } from '@ohos.arkui.node'
import { TaroHybridManager } from './TaroHybridManager'
import { HostPageState } from '../interfaces/HostPageState'

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
    this.taroHybridCoreController = new TaroWebNodeController(this.indexHtmlPath, this.taroPath)
  }

  build() {
      NodeContainer(this.taroHybridCoreController)
  }
}

class TaroWebNodeController extends NodeController {

  private isPageShow: boolean = false
  private randomNum = Math.random();
  private indexHtmlPath: string
  private taroPath: string

  constructor(indexHtmlPath: string, taroPath: string) {
    super();
    this.indexHtmlPath = indexHtmlPath;
    this.taroPath = taroPath
  }


  onPageShow() {
    this.isPageShow = true
    this.rebuild();
  }

  onPageHide() {
    this.isPageShow = false
  }

  makeNode(uiContext: UIContext): FrameNode | null {
    if(!this.isPageShow) {
      return null
    }

    return TaroHybridManager.getBuilderNode(uiContext, this.indexHtmlPath, this.taroPath)?.getFrameNode() ?? null
  }
}
