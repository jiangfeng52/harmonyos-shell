import { InvokeParams } from '../hmsjsb';


interface SetSPParams extends InvokeParams {
  key: string,
  value: any,
  spname: any,
}

interface GetSPParams extends InvokeParams {
  key: string,
  spname: any,
}

interface GetMetadataParams extends InvokeParams {
  key: string,
  packagename: string,
}

interface GetAgcConfigParams extends InvokeParams {
  key: string,
}

interface ReportEntryParams extends InvokeParams {
  uri: string,
  kitSdkVersion: any,
}

interface ReportExitParams extends InvokeParams {
  uri: string,
  transactId: string, 
  statusCode: number, 
  errorCode: number, 
  kitSdkVersionName: string,
}

interface EncryptParams extends InvokeParams {
  encryptWord: string,
}
  
interface ConfigParams extends InvokeParams {
  subId: string,
}

interface IsJsbKitAvailableParams extends InvokeParams {
  min_api_level: number,
}

/**
 * basement 对外 JS API
 * @alias basement
 */
export const hmsbase: {

  /**
   * JSB接口sharedpreference赋值
   * @param key key值
   * @param value value值
   */
  setSPvalue(data: SetSPParams): void | Promise<object>,

  /**
   * JSB接口sharedpreference获取值
   * @param key key值
   */
  getSPvalue(data: GetSPParams): void | Promise<object>,


  /**
   * JSB接口sharedpreference删除
   * @param key key值
   */
  removeSPvalue(data: GetSPParams): void | Promise<object>,

  /**
   * JSB接口获取应用metadata值
   * @param key key值
   */
  getMetadata(data: GetMetadataParams): void | Promise<object>,

  /**
   * JSB接口获取宿主包名
   * @param key key值
   */
  getPackageName(data: InvokeParams): void | Promise<object>,

  /**
   * JSB接口获取Appid
   * @param key key值
   */
  getAppId(data: InvokeParams): void | Promise<object>,

  /**
   * JSB接口获取aaid
   * @param key key值
   */
  getAaId(data: InvokeParams): void | Promise<object>,

  /**
   * JSB接口获取Uid
   * @param key key值
   */
  getUid(data: InvokeParams): void | Promise<object>,

  /**
   * JSB接口获取app version
   * @param key key值
   */
  getAppVersion(data: InvokeParams): void | Promise<object>,

  /**
   * JSB接口获取AgcConfig
   * @param key key值
   */
  getAgcConfig(data: GetAgcConfigParams): void | Promise<object>,

  /**
   * JSB接口打点
   * @param key key值 uri, kitSdkVersion
   */
  reportEntry(data: ReportEntryParams): void | Promise<object>,
  
  /**
   * JSB接口打点
   * @param key key值 uri, transactId, statusCode, errorCode, kitSdkVersionName
   */
  reportExit(data: ReportExitParams): void | Promise<object>,
  
  /**
   * JSB接口获取加密
   * @param encryptWord
   */
  encrypt(data: EncryptParams): void | Promise<object>,

  /**
   * JSB接口解密
   * @param encryptWord
   */
  decrypt(data: EncryptParams): void | Promise<object>,

  /**
   * JSB接口鉴权
   * @param {'args':{'subId':'123456'}}
   */
  config(data: ConfigParams): void | Promise<object>,

  /**
   * JSB接口 是否需要升级jsb kit
   * @param {'args':{'min_api_level':123456}}
   */

  isJsbKitAvailable(data: IsJsbKitAvailableParams): void | Promise<object>,

  /**
   * JSB接口 jsb kit的升级
   * @param  data
   */
  upgrade(data: InvokeParams): void | Promise<object>,

  /**
   * JSB接口 在升级成功后，重新加载新的jsb kit初始化jsb框架
   * @param  data
   */
  reload(data: InvokeParams): void | Promise<object>,
};
