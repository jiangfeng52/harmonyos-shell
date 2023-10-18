/**
 * XPSF可调用服务的信息描述
 *
 * @deprecated since 6.7.0-107 移动到inner sdk,请使用@ohos/hms-framework-inner-sdk导入
 */
export abstract class XPSFServiceInfo {

  static JS_SERVICE_TYPE: number;

  static CPP_SERVICE_TYPE: number;

  /**
   * 服务类别 1: js 2:cpp
   */
  abstract getType(): number;

  /**
   * 服务ID
   */
  abstract getSId(): string;

  /**
   * 应用ID
   */
  abstract getProgId(): string;

  /**
   * 这类服务的信息
   */
  abstract getServiceApiLevel(): Map<string, number>;


  /**
   * 配置需要校验的权限
   */
  abstract initPermissions(): void;

  /**
   * 配置服务是否对外暴露
   */
  abstract initIsServiceIidExport(): void;

  /**
   * 基于iId配置抽象接口类的校验权限
   *
   * @param iId
   * @param permission 权限
   */
  registerPermission(iId: string, permission: string): void;

  /**
   * 基于iId及方法编号配置抽象接口类的特定接口的校验权限
   *
   * @param iId
   * @param method 方法编号
   * @param permission 权限
   */
  registerApiPermission(iId: string, method: number, permission: string): void;

  /**
   * 基于iId配置抽象接口类不鉴权。默认都鉴权，调用该接口修改抽象接口类不鉴权。
   *
   * @param iId
   */
  disableAuth(iId: string): void;

  /**
   * 抽象服务是否对外暴露iId的方法，export为false的iId不允许外部调用，只能内部调用
   *
   * @param iId
   * @param isExport 是否对外暴露
   */
  registerIsServiceIidExport(iId: string, isExport: boolean): void;

  /**
   * 获取抽象接口类的校验权限
   * @param iId
   */
  getPermission(iId: string): string | undefined;

  /**
   * 获取抽象接口类中接口的校验权限
   *
   * @param iId
   */
  getApiPermissions(iId: string): Map<number, string> | undefined;

  /**
   * 获取抽象接口类是否不鉴权
   * 
   * @param iId
   */
  isAuthDisabled(iId: string): boolean;

  /**
   * 获取抽象接口类中接口是否对外暴露
   *
   * @param iId
   */
  getIsServiceIidExport(iId: string): boolean | undefined;
}

/**
 * kit业务主入口, Kit需要在该类中完成初始化业务逻辑
 *
 * @deprecated since 6.7.0-107 移动到inner sdk,请使用@ohos/hms-framework-inner-sdk导入
 */
export abstract class MainEntry {

  /*
   * Kit启动接口, 框架调用所有kit的该接口, 如服务注册
   */
  abstract onCreate(context: any): void;

}

/**
 * @deprecated since 6.7.0-107 移动到inner sdk,请使用@ohos/hms-framework-inner-sdk导入
 */
export class KitRegisterCenter {
  static registerServiceInfo(info: XPSFServiceInfo): void;
}
