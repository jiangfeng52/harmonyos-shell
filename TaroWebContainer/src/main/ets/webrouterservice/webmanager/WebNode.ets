import { FrameNode, BuilderNode, NodeController, Size } from '@ohos.arkui.node';
import { ApiAdapter } from '../../inject_adapter/ApiAdapter';
import { wbLogger } from '../../utils/Logger';
import { BuilderData } from '../common/entity/BuilderData';
import { WebBuilder } from './WebBuilder';
import { UIContext } from '@kit.ArkUI';

const TAG: string = 'zhou WebNode';

export class WebNode extends NodeController {
  private rootNode: BuilderNode<BuilderData[]> | null = null;
  private isRemove: boolean = false;

  makeNode(uiContext: UIContext): FrameNode | null {
    wbLogger.info(TAG, 'makeNode isRemove : ' +this.isRemove);
    if (this.isRemove) {
      return null;
    }
    if (this.rootNode !== null) {
      return this.rootNode.getFrameNode();
    }
    return null;
  }

  aboutToResize(size: Size): void {
  }

  aboutToAppear(): void {
    if (this.rootNode == undefined) {
      return;
    }
  }

  aboutToDisappear(): void {
  }

  remove() {
    this.isRemove = true;
  }

  initWeb(url: string, uiContext: UIContext, controller: WebviewController, webId: number, apiAdapter: ApiAdapter) {
    console.info(TAG, 'initWeb');
    if (this.rootNode !== null) {
      console.info(TAG, 'this.rootNode !== null');
      return;
    }
    this.rootNode = new BuilderNode(uiContext)
    this.rootNode.build(wrapBuilder<BuilderData[]>(WebBuilder),
      {url: url, controller: controller, webId: webId, apiAdapter: apiAdapter})
  }

  release() {
    console.info(TAG, 'release');
    this.rootNode = null;
  }

  add() {
    console.info(TAG, 'add');
    this.isRemove = false;
  }
}