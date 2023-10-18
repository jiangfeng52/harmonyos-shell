import { HObject } from './HObject';
import { HParcel } from './HParcel';
import { HServiceRegistryInfo } from './HServiceRegistryInfo';

/**
 * 适配器基类，各个平台的Adapter需继承自此类。
 */
export abstract class HBaseAdapter {
  // 传输type定义
  static type: string;

  /**
   * 获取远端对象
   * @param registryInfo 注册信息
   * @param iId 接口ID
   * @returns class被包装成HObject返回
   */
  abstract hGetClassObject(registryInfo: HServiceRegistryInfo, iId: string): Promise<HObject>;

  /**
   * 远程调用
   * @param hObject 远程对象
   * @param code 方法序号
   * @param hParcel 数据
   * @returns 调用成功后返回HParcel对象
   */
  abstract transact(hObject: HObject, code: number, hParcel: HParcel): Promise<HParcel>;

  /**
   * 获取远程对象
   * @param hObject 远程对象
   * @returns 返回远程对象HObject
   */
  abstract newStub(hObject: HObject): Promise<HObject>;
}
