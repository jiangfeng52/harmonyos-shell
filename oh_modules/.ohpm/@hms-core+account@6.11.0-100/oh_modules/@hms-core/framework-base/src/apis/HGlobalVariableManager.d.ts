/**
 * 全局变量管理工具类
 */
export class HGlobalVariableManager {
  
  /**
   * 设置全局变量
   * @param moduleName 模块名
   * @param key 键
   * @param value 值
   */
  static set(moduleName: string, key: string, value: any): void

  /**
   * 获取全局变量
   * @param moduleName 模块名
   * @param key 键
   * @returns 全局变量值
   */
  static get(moduleName: string, key: string): any;
}