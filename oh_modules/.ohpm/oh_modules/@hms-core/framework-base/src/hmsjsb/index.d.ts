// 缓存回调信息
export const callbackMap: object;

// 缓存用户监听的事件
export const eventMap: object;

export interface InvokeCallback {
  (data: {
    errCode: number,
    errMsg: string,
    data: object,
    extras: object
  }): void;
}

export interface InvokeParams {
  apiName: string, 
  args: object, 
  success?: InvokeCallback, 
  fail?: InvokeCallback, 
  complete?: InvokeCallback 
}

export interface CreateViewParams extends InvokeParams {
  containerId: string;
}

/**
 * 提供 js 代码调用 HMS CORE 接口能力
 * @alias hmsjsb
 */
export const hmsjsb: {
  
  /**
   * 设置子应用appid，设置后每次调用invoke会自动带上subId。
   * @param appId 子应用appid
   */
  initAppId(appId: string): void,

  /**
   * 调用 HMS CORE 方法
   * @param apiName - HMS CODE 的方法名称
   * @param args - HMS CORE 的传入参数，如果没参数可以不传
   * @param success - 接口调用成功的回调函数
   * @param fail - 接口调用失败的回调函数
   * @param complete - 接口调用完成的回调函数
   */
  invoke(params: InvokeParams): void | Promise<object>,

  /**
   * 监听 HMS CORE 的事件，接口调用后会自动开始监听，可使用 hmsjsb.off 停止监听
   * @param eventName 事件名
   * @param callback 事件的回调函数
   */
  on(eventName: string, callback: (data: object) => void, eventCallbackMap: object): void | string,

  /**
   * 停止监听 HMS CORE 的事件，页面销毁的时候需要调用
   * @param eventName 事件名
   * @param offKey 类型是 Function/String 事件的回调函数 或者 监听事件调用时返回的 offKey
   */
  off(eventName: string, offKey: string, eventCallbackMap: string): void,

  /**
   * 显示视图（如：地图、等）
   * @param apiName HMS CODE 的方法名称
   * @param args HMS CORE 的传入参数，如果没参数可以不传
   * @param containerId 视图标签的 ID
   * @param success 接口调用成功的回调函数
   * @param fail 接口调用失败的回调函数
   * @param complete 接口调用结束的回调函数（调用成功、失败都会执行）
   */
  createView(params: CreateViewParams): void,

  /**
   * 移动视图Y方向
   * <br>注意：现在只有 `WebView` 平台需要调用该方法，其它平台可以忽略。
   * @param containerId 视图标签的 ID
   * @param top Y方向的像素值
   */
  scrollViewToY(containerId: string, top: number): void,

  /**
   * 在调用 jsb 接口之前，先调用该方法进行初始化
   * <br>注意：现在只有 `React Native` 平台需要调用该方法，其它平台可以忽略。
   * @param params { NativeModules, DeviceEventEmitter }
   */
  init(params: object): void,

  /**
   * 在页面销毁前，调用该方法进行销毁
   * <br>注意：现在只有 `React Native` 平台需要调用该方法，其它平台可以忽略。
   */
  destroy(): void
};
