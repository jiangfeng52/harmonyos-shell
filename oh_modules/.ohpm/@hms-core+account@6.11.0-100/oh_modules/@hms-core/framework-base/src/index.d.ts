export { hmsjsb, callbackMap, eventMap } from './hmsjsb';
export { hmsbase } from './hmsbase';
export {
  HError, HHeader, HParcel, HBaseAdapter, HJSBAdapter, HObject, HUnknownObject, HServiceManager,
  HServiceRegistry, HServiceRegistryInfo, IClassFactory, HViewHolder, IXPSFSolution
} from './xpsf';
export { XPSFServiceInfo, MainEntry, KitRegisterCenter, JsServiceInfo, CppServiceInfo } from './xpsf';

export {
  HAppInfoManager, HPreferencesManager, HPageStarter, HPageInfo,
  HCommonMessenger, HGlobalVariableManager, HLogger, HTrace
} from './apis';

export * from './xpsf/HErrorCode';

export { JSBCompat } from './compat';

// 弃用接口
export { PageInfo } from './apis/HPageInfo';
