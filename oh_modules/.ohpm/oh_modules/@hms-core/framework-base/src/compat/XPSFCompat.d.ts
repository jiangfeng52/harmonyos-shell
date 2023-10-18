import { ErrorCode, HServiceManager } from '../xpsf';
import { JSBCompat } from './JSBCompat';

/**
 * 兼容老的JSB操作
 */
export const XPSFCompat: {

  /**
   * 兼容 现有Kit Js
   * @param apiName
   * @param args
   */
  requestCompat(apiName: string, args: string | object): Promise<object>;
}
