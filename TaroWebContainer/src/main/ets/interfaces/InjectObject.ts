/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Native注入类成员方法关联的数据接口
 */

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

// ------------------- NavigationBar -------------------

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

// ------------------- NavigateToMiniProgram -------------------
interface NavigateToMiniProgramOptionsExtraData {
  [key: string]: any;
}

interface NavigateToMiniProgramOptions {
  appId: string;
  path: string;
  extraData: NavigateToMiniProgramOptionsExtraData;
}

// ------------------- Settings -------------------
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

export interface InnerInjectObj {
  setNavigationBarColor: (options: NavigationBarOptions) => void;
  showNavigationBarLoading: () => void;
  hideNavigationBarLoading: () => void;
  getMenuButtonBoundingClientRect: () => MenuButtonBoundingClientResult;
  navigateToMiniProgram: (options: NavigateToMiniProgramOptions) => Promise<ErrorMsg>;
  setNavigationStyle: (style: string, textStyle: string, backgroundColor: string) => void;
  openSetting: (options: OpenSettingOptions) => Promise<OpenSettingRetOptions>;
  getSetting: (options: OpenSettingOptions) => Promise<GetSettingRetOptions>;
}

export interface InjectObject {
  [propName: string]: <T extends Object>(options?: any) => void | Promise<T> | Object;
}
