import { HServiceRegistryInfo } from './HServiceRegistryInfo';

/**
 * Hms Core服务注册中心
 */
export class HServiceRegistry {
  static defaultTrigger: string;

  /**
   * 初始化注册信息
   */
  initPolicy(): void;

  /**
   * 添加服务信息
   * @param sid 服务ID
   * @param progId 应用ID
   * @param path 应用路径
   * @param trigger 应用启动
   * @param proc 进程内还是进程外, "INPROC_SERVER"
   */
  addProgInfos(sid: string, progId: string, path: string, trigger: string, proc: string): void;

  /**
   * 获取服务信息
   * @param sid 服务ID
   */
  findInfoByProgId(progId: string): HServiceRegistryInfo;

  findInfo(progId: string, sid: string, apiLevel: number): HServiceRegistryInfo;
}
