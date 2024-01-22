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
import WebView from '@ohos.web.webview';
import buffer from '@ohos.buffer';
import { wbLogger } from '../utils/Logger';
import util from '@ohos.util';
import { GlobalThis } from '../utils/GlobalThis';
import common from '@ohos.app.ability.common';

/**
 * 注入（API）对象适配器
 */
const ADAPTER_TAG = 'ApiAdapter'
const METHOD_LIST: Array<string> = [
  'base64ToArrayBuffer',
  'arrayBufferToBase64',
  'addInterceptor',
  'removeInterceptor',
  'canIUse',
  'request',
  'configMTLS',
  'uploadFile',
  'downloadFile',
  'connectSocket',
  'onSocketOpen',
  'onSocketError',
  'sendSocketMessage',
  'onSocketMessage',
  'closeSocket',
  'onSocketClose',
  'chooseImage',
  'previewImage',
  'closePreviewImage',
  'getImageInfo',
  'saveImageToPhotosAlbum',
  'compressImage',
  'chooseFile',
  'getRecorderManager',
  'getBackgroundAudioManager',
  'createInnerAudioContext',
  'chooseVideo',
  'chooseMedia',
  'saveVideoToPhotosAlbum',
  'getVideoInfo',
  'compressVideo',
  'openVideoEditor',
  'createCameraContext',
  'saveFile',
  'getSavedFileList',
  'getSavedFileInfo',
  'removeSavedFile',
  'getFileInfo',
  'openDocument',
  'getFileSystemManager',
  'getStorage',
  'getStorageSync',
  'setStorage',
  'setStorageSync',
  'getStorageInfo',
  'getStorageInfoSync',
  'removeStorage',
  'removeStorageSync',
  'clearStorage',
  'clearStorageSync',
  'getLocation',
  'chooseLocation',
  'openLocation',
  'onLocationChange',
  'offLocationChange',
  'onLocationChangeError',
  'offLocationChangeError',
  'startLocationUpdate',
  'stopLocationUpdate',
  'startLocationUpdateBackground',
  'createMapContext',
  'getSystemInfo',
  'getSystemInfoSync',
  'getDeviceInfo',
  'getWindowInfo',
  'getAppBaseInfo',
  'getAppAuthorizeSetting',
  'getSystemSetting',
  'openAppAuthorizeSetting',
  'onMemoryWarning',
  'offMemoryWarning',
  'onThemeChange',
  'getNetworkType',
  'onNetworkStatusChange',
  'offNetworkStatusChange',
  'onAccelerometerChange',
  'offAccelerometerChange',
  'startAccelerometer',
  'stopAccelerometer',
  'onCompassChange',
  'offCompassChange',
  'startCompass',
  'stopCompass',
  'onGyroscopeChange',
  'startGyroscope',
  'stopGyroscope',
  'makePhoneCall',
  'scanCode',
  'setClipboardData',
  'getClipboardData',
  'setScreenBrightness',
  'getScreenBrightness',
  'setKeepScreenOn',
  'onUserCaptureScreen',
  'offUserCaptureScreen',
  'vibrate',
  'vibrateLong',
  'vibrateShort',
  'addPhoneContact',
  'openBluetoothAdapter',
  'startBluetoothDevicesDiscovery',
  'onBluetoothDeviceFound',
  'stopBluetoothDevicesDiscovery',
  'onBluetoothAdapterStateChange',
  'getConnectedBluetoothDevices',
  'getBluetoothDevices',
  'getBluetoothAdapterState',
  'closeBluetoothAdapter',
  'setBLEMTU',
  'writeBLECharacteristicValue',
  'readBLECharacteristicValue',
  'onBLEConnectionStateChange',
  'onBLECharacteristicValueChange',
  'notifyBLECharacteristicValueChange',
  'getBLEDeviceRSSI',
  'getBLEDeviceServices',
  'getBLEDeviceCharacteristics',
  'createBLEConnection',
  'closeBLEConnection',
  'onBeaconServiceChange',
  'onBeaconUpdate',
  'getBeacons',
  'startBeaconDiscovery',
  'stopBeaconDiscovery',
  'startSoterAuthentication',
  'checkIsSupportSoterAuthentication',
  'checkIsSoterEnrolledInDevice',
  'startWifi',
  'stopWifi',
  'getConnectedWifi',
  'getWifiList',
  'onGetWifiList',
  'offGetWifiList',
  'connectWifi',
  'onWifiConnected',
  'offWifiConnected',
  'onWifiConnectedWithPartialInfo',
  'offWifiConnectedWithPartialInfo',
  'getBatteryInfo',
  'onWindowResize',
  'offWindowResize',
  'hideKeyboard',
  'onKeyboardHeightChange',
  'offKeyboardHeightChange',
  'getSelectedTextRange',
  'getProvider',
  'login',
  'getUserInfo',
  'getUserProfile',
  'checkSession',
  'sendToAs',
  'getProfile',
  'initCustomUni',
]

export class ApiAdapter {
  constructor() {
    this.controller = new WebView.WebviewController();
    this.nativeObj = {};
    this.asObjectId = 0;
    this.asObjectMap = new Map();
    this.asCallbackMap = new Map();
    this.navigationBarHeight = 0;
    this.systemBarHeight = 0;
    this.sendTaskPromise = new Promise((resolve, reject) => {
      resolve('')
    })
  }

  controller: WebView.WebviewController
  nativeObj: Object
  asObjectId: number
  asObjectMap: Map<number, Object>
  asCallbackMap: Map<number, Object>
  sendTaskPromise: Promise<string>
  blockMap: Map<number, number> = new Map()
  launchOptions: string
  navigationBarHeight: number
  systemBarHeight: number

  setWebController(webController: WebView.WebviewController) {
    this.controller = webController;
  }

  mergeInjectObj(obj): void {
    Object.assign(this.nativeObj, obj);
  }

  getMethodList(): Array<string> {
    return [...METHOD_LIST, ...Object.keys(this.nativeObj)]
  }

  setLaunchOptions(launchOptions: string) {
    this.launchOptions = launchOptions
  }

  setNavigationBarHeight(height: number) {
    this.navigationBarHeight = height
  }

  setSystemBarHeight(height: number) {
    this.systemBarHeight = height
  }

  getRunJavaScript(): string {
    let context = GlobalThis.getInstance().getContext('context') as common.UIAbilityContext;
    let fileContent = context.resourceManager.getRawFileContentSync('app.js')
    let textDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: true });
    let result = textDecoder.decodeWithStream(fileContent, { stream: false });
    return result
  }
}
