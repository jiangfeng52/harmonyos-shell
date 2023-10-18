export enum ErrorCode {

  /** 传入的参数错误。 */
  ARGUMENTS_INVALID = 907135000,

  /** 内部错误，表示内部出现异常且无法恢复。 */
  INTERNAL_ERROR = 907135001,

  /** 服务接口查询错误，指定服务接口不存在或创建服务接口实例失败。 */
  NAMING_INVALID = 907135002,

  /** ApiClent对象无效。 */
  CLIENT_API_INVALID = 907135003,

  /** 调用AIDL超时。 */
  EXECUTE_TIMEOUT = 907135004,

  /** 当前区域不支持此业务。 */
  NOT_IN_SERVICE = 907135005,

  /** HMS Core SDK内部错误，AIDL连接session无效。 */
  SESSION_INVALID = 907135006,

  /** OOBE（Out-of-box experience，开箱体验）阶段未同意隐私声明，不能访问网络。 */
  DENY_NETWORK = 907135007,

  /** 调用网关查询应用Scope失败。 */
  GET_SCOPE_ERROR = 907135700,

  /** OpenGW没有配置Scope。 */
  SCOPE_LIST_EMPTY = 907135701,

  /** OpenGW没有配置指纹证书。 */
  CERT_FINGERPRINT_EMPTY = 907135702,

  /** OpenGW没有配置Permission。 */
  PERMISSION_LIST_EMPTY = 907135703,

  /** 调用网关查询应用Scope失败，并且是服务器返回异常导致的。 */
  GET_SCOPE_NETWORK_ERROR = 907135704,

  /** 应用的鉴权信息不存在。 */
  AUTH_INFO_NOT_EXIST = 907135705,

  /** 证书指纹校验：签名证书指纹错误。 */
  CERT_FINGERPRINT_ERROR = 907135706,

  /** 接口鉴权：权限不存在，未在华为开发者联盟上申请。 */
  PERMISSION_NOT_EXIST = 907135707,

  /** 接口鉴权：未授权。 */
  PERMISSION_NOT_AUTHORIZED = 907135708,

  /** 接口鉴权：授权过期。 */
  PERMISSION_EXPIRED = 907135709,

  /** 鉴权模块非法参数。 */
  SCOPE_ILLEGAL_PARAMETER = 907135710,

  /** 鉴权模块内部错误 */
  SCOPE_INTERNAL_ERROR = 907135711,

  /** 快应用场景，有subAppId，但是没有配置checker校验函数 */
  SUBAPP_CHECKER_NOT_EXIST = 907135720,

  /** 快应用场景，subAppId鉴权失败，快应用引擎校验subAppId失败 */
  SUBAPP_AUTH_ERROR = 907135721,

  /** kit不存在。 */
  KIT_NOT_EXIST = 907135900,

  /** 请求的API module不存在。 */
  API_MODULE_NOT_EXIST = 1000,

  /** API_CLIENT会话过期。 */
  API_CLIENT_SESSION_EXPIRED = 1001,

  /** 调用未指定的API错误。 */
  CALL_UNASSIGNED_API_ERROR = 1002,

  /** AMS和PMS服务未准备好。 */
  HMS_CORE_NOT_READY = 1201,

  /** 无效参数。 */
  PARAMETER_INVALID = 1210,

  /** 无效session。 */
  CALLER_SESSION_INVALID = 1211,

  /** Kit需要升级。 */
  KIT_NEED_UPDATE = 1212,

  /** Kit需要熔断。 */
  KIT_BREAKER = 1213,

  /** 内存超限。 */
  MEMORY_OVER_LIMIT = 1215,

  /** API未注册。 */
  NOT_REGISTER_API = 1216,

  /** Kit鉴权失败。 */
  AUTH_FAILED = 1217,

  /** 其他类型错误。 */
  RUNTIME_OTHER = 1260,

  /** 未找到合适的stub。 */
  NOT_FOUND_STUB = 1303,

  /** Session鉴权失败。 */
  SESSION_AUTH_FAILED = 1304,

  // XPSF错误码码段范围为 907 180 000 ~ 907 180 999。

  /** API LEVEL 不符合规范/不满足请求方要求 */
  API_LEVEL_NOT_SUPPORT = 907180001,

  /** 获取 API LEVEL 失败 */
  API_LEVEL_NOT_EXIST = 907180002,

  /** 接口升级失败 */
  INTERFACE_UPDATE_FAILED = 907180003,

  /** 获取OHOS的上下文不存在/OHOSAdapter适配器未初始化 */
  ADAPTER_UNINITIALIZED = 907180004,

  /** OHOSAdapter 与 HMS Core Core Service 连接断开 */
  ADAPTER_DISCONNECT = 907180005,

  /** OHOSAdapter 与 HMS Core Core Service 连接失败 */
  ADAPTER_CONNECT_FAILED = 907180006,

  /** OHOSAdapter 与 HMS Core Core Service 连接超时 */
  ADAPTER_CONNECT_TIMEOUT = 907180007,

  /** 获取appid失败 */
  GET_APPID_FAILED = 907180008,

  /** 获取注册中心的ServiceInfo不存在 */
  GET_SERVICEINFO_FAILED = 907180009,

  /** 获取cp的bundleinfo失败 */
  GET_BUNDLEINFO_FAILED = 907180010,

  /** 基于uid获取cp的bundlename失败 */
  GET_BUNDLENAME_FAILED = 907180011,

  /** 获取cp的指纹失败 */
  GET_APP_FINGER_PRINT_ERROR = 907180012,

  /** 调用native服务接口状态为false */
  CALL_SERVICE_FAILED = 907180013,

  /** 未找到native侧缓存的Hobject对象 */
  NOT_FOUND_SERVICE = 907180014,

  /** Iid没有对外暴露。 */
  IID_NOT_EXPORTED = 907180016,

  /** header中的packagename和基于uid获取cp的bundlename不匹配 */
  BUNDLENAME_NOT_MATCH = 907180017,

  /** 服务端进程退出 */
  SERVICE_PROCESS_DIED = 907180020,

  /** 远程对象正在释放 */
  REMOTE_OBJECT_RELEASING = 907180021,

  /** 远程对象不存在 */
  REMOTE_OBJECT_NOT_EXIST = 907180022,

  /** 调用未实现方法 */
  INVOKE_UNIMPLEMENTED_METHOD = 907180023,
  
  /** 调用方法不存在 */
  METHOD_NOT_EXIST = 907180024,

  /** 平台不支持 */
  NOT_SUPPORTED_PLATFORM = 907180025,
}

export enum BaseCode {

  /** 返回对象为空。 */
  RETURN_PARAM_NULL = -1,
  
  /** 入参为空。 */
  PARAM_ERROR = -2,
  
  /** 表示成功。 */
  SUCCESS = 0,

  /** 服务停止原因：服务被杀。 */
  SERVICE_KILLED = 1,

  /** 服务停止原因：连接丢失。 */
  SERVICE_CONNECT_LOST = 2,
}


export enum ResolutionResult {
  
  /** 内部错误。 */
  INTERNAL_ERROR = 8,
}


export enum AvailableCode {
  
  /** 用户取消。 */
  CANCELED = 13,

  /** 当前应用在后台或者处于锁屏状态，无法弹出升级页面。 */
  APP_IS_BACKGROUND_OR_LOCKED = 28,

  /** HMS Core被仿冒。 */
  HMS_IS_SPOOF = 29,

  /** 设备未安装HMS Core或者HMS Core版本过低。 */
  USER_ALREADY_KNOWS_SERVICE_UNAVAILABLE = 30,

  /** 重复拉起未安装HMS Core或HMS Core版本过低的提示框。 */
  CURRENT_SHOWING_SERVICE_UNAVAILABLE = 31,
}
