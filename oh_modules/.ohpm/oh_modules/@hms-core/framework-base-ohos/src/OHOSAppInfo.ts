import agconnect from '@hw-agconnect/api-ohos';
import { AGConnectServicesConfig } from '@hw-agconnect/core-ohos/types';
import '@hw-agconnect/core-ohos'
import { HMSLogger } from './HMSLogger';

export class OHOSAppInfo {
  private context: any;

  private appid: string = '';

  private projectId: string = '';

  private cpId: string = '';

  private cpAppId: string = '';

  constructor(context: any) {
    this.context = context;
  }

  /**
   * 通过agc获取appid
   * @returns appid
   */
  private async getAgcConfig(): Promise<AGConnectServicesConfig> {
      agconnect.instance().init(this.context);
      return await agconnect.instance().getConfig();
  }

  /**
   * 获取appid，获取失败则返回空字符串''。
   * @returns appid
   */
  async getAppId(): Promise<string> {
    if (this.appid) {
      return this.appid;
    }
    try {
      const config = await this.getAgcConfig();
      this.appid = config?.oauth_client?.client_id;
    } catch (e) {
      HMSLogger.error(HMSLogger.DEFAULT_TAG, `get agc config fail. code = ${e.code}, message = ${e.message}`);
    }
    return this.appid;
  }

  /**
   * 获取项目id，获取失败则返回空字符串''。
   * @returns 项目id
   */
  async getProjectId(): Promise<string> {
    if (this.projectId) {
      return this.projectId;
    }
    try {
      const config = await this.getAgcConfig();
      this.projectId = config.client?.project_id;
    } catch (e) {
      HMSLogger.error(HMSLogger.DEFAULT_TAG, `get config fail.  code = ${e.code}, message = ${e.message}`);
    }
    return this.projectId;
  }

  /**
   * 获取包名
   * @returns {Promise<string>} 返回包名
   */
   async getPackageName(): Promise<string> {
    return this.context?.applicationInfo?.name;
  }

  /**
   * 获取cpId，获取失败则返回空字符串''。
   * @returns cpId
   */
   async getCpId(): Promise<string> {
    if(this.cpId) {
      return this.cpId;
    }
    try {
      const config = await this.getAgcConfig();
      this.cpId = config.client?.cp_id;
    } catch (e) {
      HMSLogger.error(HMSLogger.DEFAULT_TAG, `get age config fail.  code = ${e.code}, message = ${e.message}`);
    }
    return this.cpId;
  }
  
  /**
   * 获取cpAppId，获取失败则返回空字符串''。
   * @returns cpAppId
   */
   async getCpAppId(): Promise<string> {
    if(this.cpAppId) {
      return this.cpAppId;
    }
    try {
      const config = await this.getAgcConfig();
      this.cpAppId = config.app_info?.app_id;
    } catch (e) {
      HMSLogger.error(HMSLogger.DEFAULT_TAG, `get age config fail.  code = ${e.code}, message = ${e.message}`);
    }
    return this.cpAppId;
  }
}