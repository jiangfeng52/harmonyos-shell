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

export interface NativeObj {
  setNavigationBarColor: (options: NavigationBarOptions) => void;
  showNavigationBarLoading: () => void;
  hideNavigationBarLoading: () => void;
  getMenuButtonBoundingClientRect: () => MenuButtonBoundingClientResult;
  navigateToMiniProgram: (options: NavigateToMiniProgramOptions) => Promise<ErrorMsg>;
  setNavigationStyle: (style: string) => void;
}
