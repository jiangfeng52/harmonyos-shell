import common from '@ohos.app.ability.common';
import HashMap from '@ohos.util.HashMap';
import { GlobalThis } from '../utils/GlobalThis';
import { InjectObject, InjectObjectController } from '../interfaces/InjectObject';
import { taroLogger } from '../utils/Logger';
import { taroTrace } from '../utils/Trace';
import { taroStorage } from '../inject_adapter/TaroStorage';
import { bundleManager } from '@kit.AbilityKit';
import { TaroHybridCoreInstance } from './TaroHybridCoreInstance';
import AdvancedAPI from '../utils/advancedapi.min';
import { window } from '@kit.ArkUI';
import { DiskCacheUpdateManagerInstance } from '../update/DiskCacheUpdateManager';
import { MiniRepository } from '../data/source/MiniRepository';
import { LocalMiniInfo } from '../data/source/bean/LocalMiniInfo';
import { NetworkMiniInfo } from '../data/source/bean/NetworkMiniInfo';

export interface TaroHybridManagerOptions {
  uiAbilityContext: common.UIAbilityContext,
  windowClass: window.Window,
  domain?: string,
  injectObjectController? : () => InjectObjectController,
  rootIndexHtmlPath?: string,
  nativeBack?: () => void,
  forceDarkAccess?: boolean,
  rawFileName: string,
  diskCacheEnable?: boolean
}

export class TaroHybridManager {
  private static options: TaroHybridManagerOptions | null = null
  private static builderInstanceMaps: HashMap<string, TaroHybridCoreInstance> = new HashMap();
  // 回收机制：引用计数
  private static referenceCountMap: HashMap<string, number> = new HashMap();
  // 添加自定义的user-agent
  private static customUserAgent: string = ''
  private static debuggable = false
  private static loadCommittedDetailsMaps: Map<string, Function> = new Map()

  static init(options: TaroHybridManagerOptions) {
    TaroHybridManager.options = options
    options.rawFileName && GlobalThis.getInstance().setRawFile(options.rawFileName)
    if (options.diskCacheEnable != undefined) {
      GlobalThis.getInstance().setDiskUpdateEnable(options.diskCacheEnable)
    }
    GlobalThis.getInstance().setContext('context', options.uiAbilityContext)
    MiniRepository.getInstance().initMiniInfo(options.uiAbilityContext)
    DiskCacheUpdateManagerInstance.updateDiskCache(options.uiAbilityContext)
    AdvancedAPI.init(options.uiAbilityContext, options.windowClass)
    taroStorage.init(options.uiAbilityContext,
      bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).name)
  }

  static getOptions(): TaroHybridManagerOptions | null {
    return TaroHybridManager.options
  }

  /**
   * 开始从网络更新小程序缓存，独立方法可在隐私弹窗之后调用
   * @param context
   * @param getNeedUpdateNetworkInfos 业务自定义获取小程序缓存方法
   */
  static startUpdateDiskCacheFromNetwork(context: common.ApplicationContext,
    getNeedUpdateNetworkInfos: (localVersions: Array<LocalMiniInfo>) => Promise<Array<NetworkMiniInfo> | undefined>) {
    DiskCacheUpdateManagerInstance.updateDiskCacheFromNetwork(context, getNeedUpdateNetworkInfos)
  }

  static setCustomUserAgent(customUserAgent: string) {
    TaroHybridManager.customUserAgent = customUserAgent;
  }

  static getCustomUserAgent(): string {
    return TaroHybridManager.customUserAgent
  }

  static initLoadCommittedDetails(indexHtmlPath: string, getDetails: (value: LoadCommittedDetails) => void): void {
    if (!TaroHybridManager.loadCommittedDetailsMaps.get(indexHtmlPath)) {
      TaroHybridManager.loadCommittedDetailsMaps.set(indexHtmlPath, getDetails)
    }
  }

  static getDetails(indexHtmlPath: string): boolean {
    if (TaroHybridManager.loadCommittedDetailsMaps.get(indexHtmlPath)) {
      return true
    }
    return false
  }

  static setLoadCommittedDetails(indexHtmlPath: string, options: LoadCommittedDetails): void {
    const getDetails = TaroHybridManager.loadCommittedDetailsMaps.get(indexHtmlPath)
    if (getDetails) {
      getDetails(options)
    }
  }

  static removeLoadCommittedDetails(indexHtmlPath: string): void {
    if (TaroHybridManager.loadCommittedDetailsMaps.get(indexHtmlPath)) {
      TaroHybridManager.loadCommittedDetailsMaps.delete(indexHtmlPath)
    }
  }

  static setDebuggable(debuggable: boolean) {
    TaroHybridManager.debuggable = debuggable
    taroLogger.setLoggable(debuggable)
  }

  static openTrace() {
    taroTrace.setOpen(true)
  }

  static getDebuggable() {
    return TaroHybridManager.debuggable
  }

  static isRootContainer(indexHtmlPath: string) {
    const rootIndexHtmlPath = TaroHybridManager.options?.rootIndexHtmlPath
    if (!rootIndexHtmlPath) {
      // 默认情况，如果没有设置rootIndexHtmlPath，默认都是true
      return true
    }
    return indexHtmlPath === rootIndexHtmlPath
  }

  static preLoader(uiContext: UIContext, indexHtmlPath: string, taroPath: string) {
    const instance = TaroHybridManager.getOrCreateCoreInstance(indexHtmlPath, taroPath)
    instance.getBuilderNode(uiContext)
  }

  static getOrCreateCoreInstance(indexHtmlPath: string, taroPath: string): TaroHybridCoreInstance {
    let builderInstance = TaroHybridManager.builderInstanceMaps.get(indexHtmlPath)
    if (!builderInstance) {
      builderInstance = new TaroHybridCoreInstance(
        TaroHybridManager?.options?.domain ?? '',
        indexHtmlPath,
        taroPath,
        TaroHybridManager?.options?.forceDarkAccess ?? false
      )
      // 一定要先保存到Map里，再build
      TaroHybridManager.builderInstanceMaps.set(indexHtmlPath, builderInstance)
    }

    return builderInstance
  }

  static appear(indexHtmlPath: string) {
    let count = TaroHybridManager.referenceCountMap.get(indexHtmlPath) ?? 0;
    TaroHybridManager.referenceCountMap.set(indexHtmlPath, count + 1)
  }

  static disappear(indexHtmlPath: string) {
    let count = TaroHybridManager.referenceCountMap.get(indexHtmlPath) ?? 0;
    if (count > 1) {
      TaroHybridManager.referenceCountMap.set(indexHtmlPath, count - 1)
    } else {
      // 回收
      TaroHybridManager.referenceCountMap.remove(indexHtmlPath)
      const instance = TaroHybridManager.builderInstanceMaps.remove(indexHtmlPath)
      instance.dispose()
    }
  }

  static getCoreInstance(indexHtmlPath: string): TaroHybridCoreInstance | undefined {
    return TaroHybridManager.builderInstanceMaps.get(indexHtmlPath)
  }

  static loadUrl(indexHtmlPath: string, taroPath: string): boolean {
    const instance = TaroHybridManager.getCoreInstance(indexHtmlPath)
    instance?.navigateTo(taroPath)
    // instance存在，说明容器复用，loadUrl成功
    return instance !== undefined
  }

  static nativeBack() {
    TaroHybridManager.options?.nativeBack?.()
  }

  static onBack(indexHtmlPath: string, rootTaroPage: string): boolean {
    const instance = TaroHybridManager.getCoreInstance(indexHtmlPath)
    return instance?.navigateBack(rootTaroPage) ?? false;
  }
}