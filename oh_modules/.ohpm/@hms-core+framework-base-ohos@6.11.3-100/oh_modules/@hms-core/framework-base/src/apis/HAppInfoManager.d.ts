/**
 * App相关信息管理类
 */
export class HAppInfoManager {

  /**
   * 获取appid，未找到appid则返回''。
   * @returns appid
   */
  static getAppId(): Promise<string>;

  /**
   * 获取项目id，未找到则返回''。
   * @returns 项目ID
   */
  static getProjectId(): Promise<string>;

  /**
   * 获取app包名
   * @returns app包名
   */
  static getPackageName(): Promise<string>;

  /**
   * 获取cpId，未找到cpId则返回''。
   * @returns cpId
   */
  static getCpId(): Promise<string>;

  /**
   * 获取cpAppId，未找到cpAppId则返回''。
   * @returns cpAppId
   */
  static getCpAppId(): Promise<string>;
}