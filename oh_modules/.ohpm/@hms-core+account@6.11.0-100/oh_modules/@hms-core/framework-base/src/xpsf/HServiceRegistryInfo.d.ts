/**
 * Hms服务信息
 */
export class HServiceRegistryInfo {
  // 服务ID
  mSId: string;
  // 应用ID
  mProgId: string;
  // 应用路径
  mPath: string;
  // 应用启动
  mTrigger: string;
  // 进程内还是进程外
  mProc: string;
  // api level
  mApiLevel: number;

  constructor(sid: string, progId: string, path: string, trigger: string, proc: string);
}
