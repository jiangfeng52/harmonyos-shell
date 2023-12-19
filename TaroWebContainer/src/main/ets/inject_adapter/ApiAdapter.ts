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
import WebView from '@ohos.web.webview'
import common from '@ohos.app.ability.common';
import util from '@ohos.util';
import { GlobalThis } from '../utils/GlobalThis';
import  { as } from '../utils/advancedapi.min';
import { wbLogger } from '../utils/Logger';

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

  getCustomPara(): string {
    let cuntomParaStr =`var navigationHeight = ${this.navigationBarHeight};
                 var systemBarHeight = ${this.systemBarHeight};
                 var customLaunchOptions = '${this.launchOptions}';`
    return cuntomParaStr
  }

  getRunJavaScript(): string {
    let context = GlobalThis.getInstance().getContext('context') as common.UIAbilityContext;
    let fileContent = context.resourceManager.getRawFileContentSync('injectTransform.js')
    let textDecoder = util.TextDecoder.create("utf-8", { ignoreBOM: true });
    let result = textDecoder.decodeWithStream(fileContent, { stream: false });
    result = result.concat(this.getCustomPara())
    this.getMethodList().forEach(method => {
      result = result + this.createJavaScriptString(method)
    })
    return result
  }

  createJavaScriptString(method: string): string {
    return `
        asAPIMap.set('${method}', setAsAPIFunction('${method}'))
        `
  }

  sendTask(callbackId, res) {
    // 高评率触发的限流，单位时间触发过多会导致进程锁死
    const resStrTmp = JSON.stringify(res)
    if (this.blockMap.has(callbackId)) {
      const lastTime = this.blockMap.get(callbackId);
      const currTime = new Date().getTime();
      // 限流条件为同一回调事件，时间间隔100ms，且消息长度超过1000字符
      const interval = 100
      const resLengthLimit = 1000
      if (currTime - lastTime < interval && resStrTmp.length > resLengthLimit) {
        return
      }
    }
    this.blockMap.set(callbackId, new Date().getTime());
    wbLogger.debug(ADAPTER_TAG, `callbackId:${callbackId}`)
    wbLogger.debug(ADAPTER_TAG, `res: ${resStrTmp}`)
    const that = this
    that.sendTaskPromise = that.sendTaskPromise.then(() => {
      return that.controller.runJavaScript(`receiveTask(${callbackId},${resStrTmp})`)
        .then(result => {
          wbLogger.info(ADAPTER_TAG, `The receiveTask() return value is: ${result}`)
          return result
        }).catch(error => {
          wbLogger.error(ADAPTER_TAG, `run JavaScript error: ${JSON.stringify(error)}`)
          return JSON.stringify(error)
        })
    })
    // arkTs 向 WebView的限流，当前可以先放开，等后续有场景需要时再开启
    /*.then(result=>{
    return new Promise((resolve)=>{
        setTimeout(()=>{
            resolve(result)
        },1000)
    })
})*/
  }

  getDefinedPropertyNames(obj) {
    const names = []
    names.push(...Object.getOwnPropertyNames(obj))
    let proto = Object.getPrototypeOf(obj)
    while (proto.constructor !== Object) {
      names.push(...Object.getOwnPropertyNames(proto))
      proto = Object.getPrototypeOf(proto)
    }
    return [...new Set(names)]
  }

  getAdapterProxy() {
    wbLogger.debug(ADAPTER_TAG, 'getAdapterProxy')
    const that = this
    Object.assign(as, that.nativeObj)
    Object.defineProperty(as, 'sendToAs', {
      get: () => {
        return (asObjectId, type, method, ...args) => {
          wbLogger.debug(ADAPTER_TAG, `asObjectId ${asObjectId} ${method}`)
          const asObject = that.asObjectMap.get(asObjectId)
          if (type === 'get_function') {
            if (args) {
              const callbackString = args[0]
              const argsStr = args[1]
              const argsT = JSON.parse(argsStr)
              const callbackObj = JSON.parse(callbackString)
              callbackObj.forEach((obj, index) => {
                if (typeof (obj) === 'object') {
                  for (let name in obj) {
                    argsT[index][name] = (...res) => {
                      that.sendTask(obj[name], res)
                    }
                  }
                } else {
                  let key = obj;
                  let objArray = []
                  if (typeof (obj) === 'string') {
                    objArray = obj.split('_')
                    key = Number.parseInt(objArray[0])
                  }
                  if (objArray.length > 1) {
                    if (that.asCallbackMap.has(key)) {
                      const callback = that.asCallbackMap.get(key);
                      argsT[index] = callback;
                    } else {
                      const callback = (...res) => {
                        that.sendTask(key, res)
                      }
                      argsT[index] = callback;
                      that.asCallbackMap.set(key, callback);
                    }
                  } else {
                    argsT[index] = (...res) => {
                      that.sendTask(key, res)
                    }
                  }
                }
              })
              return asObject[method].apply(asObject, argsT)
            } else {
              return asObject[method]()
            }
          } else if (type === 'get_value') {
            const res = asObject[method]
            wbLogger.debug(ADAPTER_TAG, `${method} : ${res}`)
            return res
          } else if (type === 'set') {
            return asObject[method] = args[0]
          }
        }
      }
    })

    Object.defineProperty(as, 'initCustomUni', {
      get: () => {
        return () => {
          return that.getRunJavaScript()
        }
      }
    })

    const proxy = new Proxy(as, {
      get(target, property) {
        if (property == 'sendToAs' || property == 'initCustomUni') {
          return target[property]
        }
        return (callbackString, argsStr) => {
          const args = JSON.parse(argsStr)
          const callbackObj = JSON.parse(callbackString)
          callbackObj.forEach((obj, index) => {
            if (typeof (obj) === 'object') {
              for (let name in obj) {
                args[index][name] = (...res) => {
                  that.sendTask(obj[name], res)
                }
              }
            } else {
              let key = obj;
              let objArray = []
              if (typeof (obj) === 'string') {
                objArray = obj.split('_')
                key = Number.parseInt(objArray[0])
              }
              // objArray[1]存在的情况下CP代码传递过来的方法为命名函数，此时才需要放在Map当中保证重复调用的时候指向同一个对象
              if (objArray.length > 1) {
                if (that.asCallbackMap.has(key)) {
                  const callback = that.asCallbackMap.get(key);
                  args[index] = callback;
                } else {
                  const callback = (...res) => {
                    that.sendTask(key, res)
                  }
                  args[index] = callback;
                  that.asCallbackMap.set(key, callback);
                }
              } else {
                args[index] = (...res) => {
                  that.sendTask(key, res)
                }
              }
            }
          })
          const asObject = target[property].apply(null, args)
          if (typeof (asObject) === 'object') {
            that.asObjectMap.set(that.asObjectId, asObject)
            const list = that.getDefinedPropertyNames(asObject)
            const resultJson = { asObjectId: that.asObjectId++ }
            list.forEach(value => {
              if (value !== 'constructor') {
                resultJson[value] = typeof (asObject[value])
              }
            })
            const resultStr = JSON.stringify(resultJson)
            return resultStr
          } else {
            return asObject
          }
        }
      }
    })
    return proxy
  }
}
