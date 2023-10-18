import { AGCApi } from '@hw-agconnect/api-ohos';
import common from '@ohos.app.ability.common';

declare module '@hw-agconnect/api-ohos' {
  interface AGCApi {
    instance(name?: string): AGCInstance;
    aaid(): Aaid;
  }
}

declare module './index' {
  interface _ extends AGCApi { }
}

/**
 * agc sdk会根据agconnect-services.json文件的版本号，对json文件进行处理，严禁修改json文件内容。
 * 获取config对象的数值，推荐使用 'getString(path: string): Promise<string>' 方法
 */
export declare type AGConnectServicesConfig = {
  agcgw: any;
  agcgw_all?: any;
  client: any;
  service: any;
  oauth_client?: any;
  app_info?: any;
  region?: string;
  configuration_version?: string;
  [string: string]: any;

  /**
   * 获取agconnect-services.json具体的配置项
   * 获取的数据为agc sdk 解密后的最终数据。
   * @param path 配置项在 agconnect-services.json 文件中的位置，用'/'分隔。
   * 比如：
   * 1.获取client_id：client.client_id：调用方式getString('/client/client_id')
   * 2.获取client_secret：client.client_secret：调用方式getString('/client/client_secret'),获取的client_secret为最终的解密后的数据。
   * 2.获取collector_url_cn：service.analytics.collector_url_cn：调用方式getString('/service/analytics/collector_url_cn'),
   */
  getString(path: string): Promise<string>;

  /**
   * 获取config对象的routePolicy
   */
  getRoutePolicy(): number

  /**
 * 修改当前的存储地，AGC SDK 支持多存储地的切换，默认存储地为agconnect-services.json文件中的region 字段
 * 调用此方法可以修改存储地
 * @param routePolicy AGCRoutePolicy.CHINA|AGCRoutePolicy.GERMANY|AGCRoutePolicy.RUSSIA|AGCRoutePolicy.SINGAPORE
 */
  setRoutePolicy(routePolicy: number): void;

  /**
   * 获取config对象的client_secret
   * 如果开发者调用了'setClientSecret()',获取的将是开发者设置的值,
   * 如果开发者没有调用'setClientSecret()'，获取到的将是有sdk解析出来的agconnect-services.json对应路径的数据值（与getString('/client/client_secret')功能相同）。
   */
  getClientSecret(): Promise<string>;

  /**
   * 手动设置SDK鉴权秘钥。
   * 下载最新版本的agconnect-services.json 和 sdk 版本1.0.4以上 ,此方法无需开发者手动调用
   * @param clientSecret 获取方式：登录AGC控制台->项目设置->项目->客户端ID->Client Secret
   */
  setClientSecret(clientSecret: string): void;

  /**
   * 获取config对象的api_key
   * 如果开发者调用了'setApiKey()',获取的将是开发者设置的值,
   * 如果开发者没有调用'setApiKey()'，获取到的将是有sdk解析出来的agconnect-services.json对应路径的数据值（与getString('/client/api_key')功能相同）。
   */
  getApiKey(): Promise<string>;

  /**
   * 设置API密钥
   * 下载最新版本的agconnect-services.json 和 sdk 版本1.0.4以上 ,此方法无需开发者手动调用
   * 需要开发者下载最新的json，已开发的输入为主
   * @param apiKey 获取方式：登录AGC控制台->项目设置->项目->API密钥（凭据）
   */
  setApiKey(apiKey: string): void;
};

/**
 * AGC SDK 初始化
 */
export declare interface AGCInstance {
  /**
   * 初始化AGC SDK
   * 
   * @param applicationContext ohos应用的applicationContext
   * @param config? [可选] agconnect-services.json文件内容。
   * 
   * AGC SDK 初始化需要依赖agconnect-services.json文件,开发者可以通过两种方式设置
   * 1.将 agconnect-services.json复制到代码中:
   * 
   * @example
   * 
   * ```javascript
   * var config = {
   *    "agcgw": { "url" :""},
   *    "client":{},
   *    "app_info":{}
   *     ...
   * }
   * agconnect.instance().init(applicationContext, config);
   * ```
   * 
   * 2.将agconnect-services.json文件放置在AppScope/resources/rawfile目录下,SDK 会自动到该目录下去读取
   * 
   * @example
   * 
   * ```javascript
   * agconnect.instance().init(applicationContext);
   *  ```
   * 
   */
  init(applicationContext: common.Context, config?: any): AGCInstance;

  /**
   * 获取初始化的applicationContext
   */
  getContext(): common.Context;

  /**
   * 返回AGConnectServicesConfig 对象
   */
  getConfig(): Promise<AGConnectServicesConfig>;

  /**
   * 修改当前的存储地
   * @deprecated 推荐使用'getConfig().setRoutePolicy()'
   */
  setRoutePolicy(routePolicy: number): void;

  /**
   * 获取当前的存储地
   * deprecated 推荐使用'getConfig().getRoutePolicy()'
   */
  getRoutePolicy(): Promise<number>;

  /**
   * 设置API密钥
   * @deprecated 推荐使用'getConfig().setApiKey()'
   */
  setApiKey(apiKey: string): void;

  /**
   * 设置SDK鉴权秘钥。
   * @deprecated 推荐使用'getConfig().setClientSecret()'
   */
  setClientSecret(clientSecret: string): void;

  getService<T>(name: string): T | null;

  /**
    * 当前AGCInstance实例名称，默认实例名称 '[DEFAULT_CATEGORY]'
    * 开发者可以通过name来获取agconnect 各个服务的实例(每个实例都需要初始化)。
    * 获取默认实例：
    * 
    * @example
    * 
    * ```javascript
    * agconnect.instance();
    *  ```
    * 获取自定义name的实例：
    * 
    * @example
    * 
    * ```javascript
    * let name = "custom_name"
    * agconnect.instance(name);
    *  ```
    */
  name(): string;

}

export declare interface Aaid {
  /**
   * 获取应用的aaid
   * 调用方式：agconnect.aaid().getAaid()
   */
  getAaid(): Promise<string>;
}

export enum AGCRoutePolicy {
  UNKNOWN,
  CHINA,
  GERMANY,
  RUSSIA,
  SINGAPORE
}

export { Singleton, InstanceMap } from '../src/main/ets/singleton'
export { AGCError, AGCErrorCode } from "../src/main/ets/AGCError";
