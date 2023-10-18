import { HPageInfo, PageInfo } from './HPageInfo';

export const HPageStarter: {

  // 支持的适配器
  mSupprotAdapters: object[],

  init(): void,

  /**
   * 注册适配器
   * @param type 平台信息
   * @param adapter 平台适配器
   */
  registerAdapter(type: string, adapter: object): void,

  /**
   * 启动页面
   * @param fgTransaction 启动页面信息
   * @param context 启动页面的上下文
   * @param options 启动模式信息
   * @returns Promise形式返回执行结果
   */
  start(fgTransaction: HPageInfo | PageInfo, context?: any, options?: any): Promise<any>;
}