import { XPSFServiceInfo } from './XPSFServiceInfo'

/**
 * XPSF可调用服务的信息描述
 *
 * @deprecated since 6.7.0-107 移动到inner sdk,请使用@ohos/hms-framework-inner-sdk导入
 */
export abstract class JsServiceInfo extends XPSFServiceInfo {
  
  /**
   * 服务类别 1: js, 2:cpp
   */
  getType(): number;

  /**
   * 实现对象
   */
  abstract getClassObject(iID: string): any;
}