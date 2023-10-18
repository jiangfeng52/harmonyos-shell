/**
 * 消息通知处理类
 */
export class HCommonMessenger {
  
  /**
   * 开启监听
   * @param method 事件名
   * @param callback 监听回调
   */
  static on(method: string, callback: (data: any) => void): void
  
  /**
   * 停止监听
   * @param method 事件名
   */
  static off(method: string): void;
}