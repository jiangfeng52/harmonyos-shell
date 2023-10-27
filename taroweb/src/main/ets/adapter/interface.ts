// ------------------------ common -----------------------------
export interface ErrorMsg {
  errMsg: string
}

export interface WantInfo {
  deviceId: string;
  bundleName: string;
  abilityName: string;
  parameters: NavigateToMiniProgramOptionsExtraData | {};
}

// ------------------- NavigateToMiniProgram -------------------

export interface MenuButtonOptions {
  width: number;
  height: number;
  marginRight: number;
}

interface MenuButtonBoundingClientResult {
  left: number;
  right: number;
  top: number;
  bottom: number;
  width: number;
  height: number;
}

interface NavigationBarAnimationOptions {
  duration?: number;
}

interface NavigationBarOptions {
  backgroundColor?: string;
  frontColor?: string;
  timingFunc?: 'linear' | 'easeIn' | 'easeOut' | 'easeInOut';
  animation?: NavigationBarAnimationOptions;
}

interface NavigateToMiniProgramOptionsExtraData {
  [key: string]: any;
}

interface NavigateToMiniProgramOptions {
  appId: string;
  path: string;
  extraData: NavigateToMiniProgramOptionsExtraData;
}

interface UsedScene {
  abilities: Array<string>;
  when: string;
}

export interface PermissionInfo {
  name: string;
  moduleName: string;
  reason: string;
  reasonId: number;
  usedScene: UsedScene;
}

export interface AuthSetting {
  'scope.userInfo': boolean;
  'scope.userLocation': boolean;
  'scope.address': boolean;
  'scope.invoiceTitle': boolean;
  'scope.invoice': boolean;
  'scope.werun': boolean;
  'scope.record': boolean;
  'scope.writePhotosAlbum': boolean;
  'scope.camera': boolean;
  'scope.bluetoothBackground': boolean;
}

interface ItemSettings {
  templateId: string
}

export interface SubscriptionsSetting {
  mainSwitch: string;
  itemSettings: Array<ItemSettings>;
}

export interface OpenSettingRetOptions {
  authSetting: AuthSetting;
  subscriptionsSetting?: SubscriptionsSetting;
  errMsg: string;
}

export interface GetSettingRetOptions {
  authSetting: AuthSetting;
  subscriptionsSetting?: SubscriptionsSetting;
  miniprogramAuthSetting?: AuthSetting;
  errMsg: string;
}

interface OpenSettingOptions {
  withSubscriptions?: boolean;
}

export interface SysBarProps {
  statusBarColor: string;
  statusBarContentColor: string;
}

export interface BundleScopeResult {
  allScope: AuthSetting;
  bundleScope: Map<string, boolean>;
}

export interface NativeObj {
  setNavigationBarColor: (options: NavigationBarOptions) => void;
  showNavigationBarLoading: () => void;
  hideNavigationBarLoading: () => void;
  getMenuButtonBoundingClientRect: () => MenuButtonBoundingClientResult;
  navigateToMiniProgram: (options: NavigateToMiniProgramOptions) => Promise<ErrorMsg>;
  setNavigationStyle: (style: string) => void;
  openSetting: (options: OpenSettingOptions) => Promise<OpenSettingRetOptions>;
  getSetting: (options: OpenSettingOptions) => Promise<GetSettingRetOptions>;
}
