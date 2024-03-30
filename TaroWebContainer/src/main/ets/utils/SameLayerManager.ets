/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { BuilderNode, FrameNode, NodeController, NodeRenderType } from '@kit.ArkUI';
import { wbLogger } from './Logger';

const TAG: string = 'SameLayerRender';

const nodeContainerArgMap: Map<string, EmbedNodeController> = new Map();
const sameLayerArgsMap: Map<string, object> = new Map();
const nativeComponentBuilderMap: Map<string, (...args: Object[]) => void> = new Map();

interface RenderParams {
  embedId: string;
  embedType: string;
  embedWidth: number;
  embedHeight: number;
  surfaceId: string;
  componentId: string;
}

// 重新设置渲染参数中的宽高，但不修改原始数据中的宽高
function getRenderOptions(originalArgs: object, embedWidth: number | undefined, embedHeight: number | undefined): object {
  const args: ESObject = {};
  Object.keys(originalArgs).forEach(key => {
    args[key] = originalArgs[key]
  })
  args['width'] = embedWidth || 0;
  args['height'] = embedHeight || 0;
  return args;
}

class EmbedNodeController extends NodeController {
  private rootNode: BuilderNode<[Object]> | undefined | null;
  private embedId: string | undefined; // 分配给embed的ID
  private embedType: string | undefined; // 对应html中embed元素的type属性
  private embedWidth: number | undefined; // 对应html中embed元素的height属性转换后的值
  private embedHeight: number | undefined; // 对应html中embed元素的width属性转换后的值
  private surfaceId: string | undefined; // 分配给embed的surfaceId
  private componentId: string | undefined; // 对应html中embed元素的id属性
  private renderType: NodeRenderType = NodeRenderType.RENDER_TYPE_TEXTURE;

  makeNode(uiContext: UIContext): FrameNode | null {
    if (this.rootNode === null) {
      // 动态下树
      return null;
    }
    if (!this.embedType || !this.componentId) {
      wbLogger.warn(TAG, 'The id or type attribute of the embed tag is undefined.');
      return null;
    }
    // 未定义根节点则创建
    if (!this.rootNode) {
      const builder = sameLayerArgsMap.get(this.componentId);
      const originalArgs = sameLayerArgsMap.get(this.componentId);
      if (builder && originalArgs) {
          this.rootNode = new BuilderNode<[Object]>(uiContext, { surfaceId: this.surfaceId, type: this.renderType });
          const renderOptions = getRenderOptions(originalArgs, this.embedWidth, this.embedHeight);
          const wrapBuilder: WrappedBuilder<[Object]> = new WrappedBuilder(builder as (...args: Object[]) => void);
          this.rootNode.build(wrapBuilder, renderOptions);
      } else {
        wbLogger.warn(TAG, `Native component builder is not registered or args is undefined, type: ${this.embedType}.`);
        return null;
      }
    }
    // 动态上树
    return this.rootNode.getFrameNode();
  }

  setRenderParams(params: RenderParams) {
    this.embedId = params.embedId;
    this.embedType = params.embedType;
    this.embedWidth = params.embedWidth;
    this.embedHeight = params.embedHeight;
    this.surfaceId = params.surfaceId;
    this.componentId = params.componentId;
  }

  release() {
    this.rootNode?.dispose();
  }

  setEmbedWidth(width: number): void {
    this.embedWidth = width;
  }

  getEmbedWidth(): number | undefined {
    return this.embedWidth;
  }

  setEmbedHeight(height: number): void {
    this.embedHeight = height;
  }

  getEmbedHeight(): number | undefined {
    return this.embedHeight;
  }

  setBuilderNode(rootNode: BuilderNode<[Object]> | null): void {
    this.rootNode = rootNode;
  }

  getBuilderNode(): BuilderNode<[Object]> | undefined | null {
    return this.rootNode;
  }

  getEmbedId(): string | undefined {
    return this.embedId;
  }
}

class SameLayerManager {
  private static instance: SameLayerManager;

  static getInstance(): SameLayerManager {
    if (!SameLayerManager.instance) {
      SameLayerManager.instance = new SameLayerManager();
    }
    return SameLayerManager.instance;
  }

  getNodeController(componentId: string): EmbedNodeController | undefined {
    return nodeContainerArgMap.get(componentId)
  }

  getSameLayerArgs(componentId: string): object | undefined {
    return sameLayerArgsMap.get(componentId)
  }

  handleNativeEmbedLifecycleChange(embed: NativeEmbedDataInfo, createCallback: Function, destroyCallback: Function) {
    // 获取web侧embed元素的id
    if (!embed.info?.type || !embed.info?.id || !embed.info?.width || !embed.info?.height) {
      wbLogger.warn(TAG, 'The embed tag is set incorrectly.');
      return
    }
    const componentId = embed.info.id;
    if (embed.status == NativeEmbedStatus.CREATE) {
      wbLogger.info(TAG, 'onNativeEmbedLifecycleChange CREATE')
      const nodeController = new EmbedNodeController();
      wbLogger.info(TAG, embed.info.width.toString())
      wbLogger.info(TAG, embed.info.height.toString())
      nodeController.setRenderParams({
        embedId: embed.embedId as string,
        embedType: embed.info.type,
        embedWidth: px2vp(embed.info.width), // 需要px2vp
        embedHeight: px2vp(embed.info.height), // 需要px2vp
        surfaceId: embed.surfaceId as string,
        componentId: componentId,
      })
      nodeContainerArgMap.set(componentId, nodeController)
      createCallback?.()
    } else if (embed.status == NativeEmbedStatus.UPDATE) {
      wbLogger.info(TAG, 'onNativeEmbedLifecycleChange UPDATE: Re-render native component')
      const nodeController = nodeContainerArgMap.get(componentId)!;
      const embedWidth = px2vp(embed.info.width);
      const embedHeight = px2vp(embed.info.height);
      nodeController.setEmbedWidth(embedWidth) // embed宽度发生变化，重新设置宽度
      nodeController.setEmbedHeight(embedHeight) // embed高度发生变化，重新设置高度
      const originalArgs = sameLayerArgsMap.get(componentId)!;
      const renderOptions = getRenderOptions(originalArgs, embedWidth, embedHeight);
      nodeController.getBuilderNode()?.update(renderOptions)
      nodeController.rebuild()
    } else {
      wbLogger.info(TAG, 'onNativeEmbedLifecycleChange DESTROY')
      const nodeController = nodeContainerArgMap.get(componentId)
      nodeController?.release()
      // 动态下树
      nodeController?.setBuilderNode(null)
      nodeController?.rebuild()
      // 清理节点控制器
      nodeContainerArgMap.delete(componentId)
      // 清理同层渲染组件数据
      sameLayerArgsMap.delete(componentId)
      // 清理数组元素，触发重新渲染
      destroyCallback?.()
    }
  }

  handleNativeEmbedGestureEvent(touch: NativeEmbedTouchInfo, componentIdArr: Array<string>) {
    wbLogger.info(TAG, `OnNativeEmbedGestureEvent: ${JSON.stringify(touch.touchEvent)}.`)
    componentIdArr.forEach((componentId: string) => {
      const nodeController = nodeContainerArgMap.get(componentId);
      if (nodeController?.getEmbedId() === touch.embedId) {
        const rootNode = nodeController?.getBuilderNode()
        let ret = rootNode?.postTouchEvent(touch.touchEvent);
        if (ret) {
          wbLogger.info(TAG, "onNativeEmbedGestureEvent success.")
        } else {
          wbLogger.info(TAG, "onNativeEmbedGestureEvent fail.")
        }
      }
    })
  }

  transferSameLayerArgs(args: object) {
    if (!args) {
      wbLogger.warn(TAG, 'Args from web side is undefined.')
      return
    }
    if (!args['componentId']) {
      wbLogger.warn(TAG, 'ComponentId is undefined.')
      return
    }
    if (sameLayerArgsMap.get(args['componentId']) === undefined) {
      wbLogger.info(TAG, `Create native component attributes: ${JSON.stringify(args)}`);
      // 创建同层组件时
      sameLayerArgsMap.set(args['componentId'], args)
    } else {
      const originalArgs = sameLayerArgsMap.get(args['componentId'])!;
      Object.keys(originalArgs).forEach(key => {
        if (args[key] === undefined) {
          args[key] = originalArgs[key];
        }
      })
      wbLogger.info(TAG, `Update native component attributes: ${JSON.stringify(args)}`);
      sameLayerArgsMap.set(args['componentId'], args)
      // 宽高均未发生变化时走此处重新渲染
      if (args['width'] === originalArgs['width'] && args['height'] === originalArgs['height']) {
        wbLogger.info(TAG, 'transferSameLayerArgs: Re-render native component');
        // 更新原生组件
        const nodeController = nodeContainerArgMap.get(args['componentId'])!;
        const embedWidth = nodeController.getEmbedWidth();
        const embedHeight = nodeController.getEmbedHeight();
        const renderOptions = getRenderOptions(args, embedWidth, embedHeight);
        nodeController.getBuilderNode()?.update(renderOptions);
        nodeController.rebuild()
      }
    }
  }

  registerNativeComponentBuilders(componentName: string, builder: (...args: ESObject[]) => void) {
    // 同层渲染传递到原生的type会被转换为全小写
    const embedType: string = `native/${componentName.toLowerCase()}`;
    nativeComponentBuilderMap.set(embedType, builder)
  }

  isAlreadyRegistered(componentName: string): boolean {
    const embedType: string = `native/${componentName.toLowerCase()}`;
    return nativeComponentBuilderMap.has(embedType)
  }
}

export const sameLayerManager = SameLayerManager.getInstance();