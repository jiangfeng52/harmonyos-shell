export default interface utils {
  uniqueId(prefix: string): string,

  log(...args: any): void,

  info(...args: any): void,
  
  error(...args: any): void,

  getJSCore(): object,

  setJSCore(jsc: object): void,

  isWebView(): boolean,

  isWeex(): boolean,

  isRN(): boolean,

  isCordova(): boolean,

  isCapacitor(): boolean,

  // 双框架鸿蒙
  isHarmony(): boolean,

  // 单框架鸿蒙 Open Harmony
  isOHOS(): boolean,

  // PAF 移动中台
  isSupportPAF(): boolean,
  
  /**
   * 是否鸿蒙平台的WebView
   * @returns true 鸿蒙平台WebView
   */
  isHarmonyWebview(): boolean,

  isQickApp(): boolean,

  getPositionInfoById(containerId: string): {
    left: number,
    top: number,
    width: number,
    height: number,
  },
}
