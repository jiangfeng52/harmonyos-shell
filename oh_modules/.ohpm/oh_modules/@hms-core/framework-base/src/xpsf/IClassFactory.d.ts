import { HObject } from './HObject.js';

/**
 * 提供一个标准的类工厂
 */
export class IClassFactory {

  // 类厂统一接口ID
  static IID_IClassFactory: string;

  /**
   * 针对于接口进行转型
   * @param hObject 远程对象
   * @returns 返回远程调用代理
   */
  static asInterface(hObject: HObject): any;
}
