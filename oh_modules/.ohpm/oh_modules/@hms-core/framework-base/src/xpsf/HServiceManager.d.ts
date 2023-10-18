import { HBaseAdapter } from './HBaseAdapter';
import { HError } from './HError';
import { HObject } from './HObject';


/**
 * Hms Core服务管理
 */
export class HServiceManager {

  static mSupprotAdapters: Map<string, () => HBaseAdapter>;

  /**
   * 管理服务初始化
   */
  static init(): void;

  /**
   * 注册适配器
   * @param type 类型
   * @param adapter 适配器回调，返回一个适配器
   */
  static registerAdapter(type: string, adapter: object): void;


  /**
   * 创建服务实例
   * @param params.progId (必须)服务应用ID
   * @param params.iId (必须)接口ID
   * @param params.apiLevel api版本
   * @param params.success 成功回调，回调参数为HObject
   * @param params.failed 失败回调，回调参数为HError
   */
  static hCreateInstance(params: {
    progId: string, 
    iId: string, 
    apiLevel?: number, 
  }): Promise<HObject>;
  static hCreateInstance(params: {
    progId: string, 
    iId: string, 
    apiLevel?: number, 
    success: (hobject: HObject) => void, 
    failed?: (error: HError) => void,
  }): void;

  /**
   * 创建远程对象
   * @param progId 服务应用ID
   * @param iid 接口ID
   * @param success 成功返回回调，回调参数为HObject
   */
  static hGetClassObject(progId: string, iId: string, success: (hobject: HObject) => void): void;
}
