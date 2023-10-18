import { XPSFServiceInfo } from './XPSFServiceInfo';

/**
 * @deprecated since 6.7.0-107 移动到inner sdk,请使用@ohos/hms-framework-inner-sdk导入
 *
 * XPSF可调用服务的信息描述
 */
export abstract class CppServiceInfo extends XPSFServiceInfo {

  /**
   * 服务类别 1: js, 2:cpp
   */
  getType(): number;

  /**
   * 服务路径
   */
  abstract getPath(): string;

  /**
   * 服务启动方式
   */
  abstract getTrigger(): string;
}