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
import { as } from '@ohos/advanced-api';
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

  getRunJavaScript(): string {
    let result: string = `
              function isFunctionOrObjectWithFunction(object) {
                  if (typeof object === 'function') {
                      // 如果是函数，直接返回 true
                      return true;
                  }

                  if (typeof object !== 'object' || object === null) {
                      return false;
                  }

                  // 如果是对象，遍历对象的每个属性，检查属性是否是函数
                  for (const key in object) {
                      if (object.hasOwnProperty(key) && typeof object[key] === 'function') {
                          return true;
                      }
                  }
                  return false
              }

              function isOnMehtod(methodName){
                  if (methodName.startsWith('on')) {
                      return true // 以on开头的方法调用
                  }
                  return false
              }

              function getAllFunName(object) {
                  var funcNames = Object.getOwnPropertyNames(object).filter(name => typeof object[name] === 'function');
                  return funcNames
              }

              // 通信Channel层
              window.Channel = {
                  jsCallListeners: {},
                  // listenerMap: {}, 弱引用自动取消
                  registerJsCall(channelType, fun) {
                      this.jsCallListeners[channelType] = fun
                  },

                  /**
                   * methodCall的对象结构为：{call: string, argsJson: string, stubId: number}
                   */
                  nativeCall: function(channelType, object){
                      // 最终调用原生Channel的通信方法
                      object["callbackArg"] = getAllFunName(object["arg"])
                      var objectJson = JSON.stringify(object)
                      // @ts-ignore
                      var resultJson = window.JSBridge && window.JSBridge.nativeMethod(channelType, objectJson)
                      return resultJson && JSON.parse(resultJson)
                  },

                  /**
                   * 给原生暴露的通信方法，原生调用"window.Channel.jsCall(objectId, 'xxx', 'xxxx')"
                   */
                  jsCall: function(channelType, objectJson){
                      // window.apiStubPool.onTransact(objectId, callName, argsJson)
                      var fun = this.jsCallListeners[channelType]
                      fun && fun(JSON.parse(objectJson))
                  }
              }

              window.MethodChannel = {
                  ChannelType: 'MethodChannel',

                  init: function (){
                      window.Channel.registerJsCall(this.ChannelType, function (object){
                          window.MethodChannel.__ArgsMethodStub(object)
                      })
                  },

                  createNativeApiProxy: function (nativeApi){
                    return new Proxy(nativeApi, {
                        get(target, prop, receiver) {
                            if(typeof target[prop] === 'function') {
                                const isSync = prop.toString().endsWith("BridgeSync")
                                const isAsync = prop.toString().endsWith("BridgeAsync")
                                if(isSync || isAsync) { // 走代理
                                    const className = target.constructor.name;
                                    return function (...args) {
                                        const firstArg = args.length >= 1 ? args[0] : ''
                                        // 约定异步回调的方式，一次性回调，监听回调
                                        let isListener = isOnMehtod(prop.toString())
                                        let hasFun = isFunctionOrObjectWithFunction(firstArg)

                                        // 方法调用转换为数据
                                        var methodCall = {
                                            isSync: isSync,
                                            call: className+'$'+prop.toString(),
                                            isListener: isListener,
                                            arg: firstArg,
                                            stubId: hasFun ? window.MethodChannel.__registerArgStub(firstArg, isListener) : -1
                                        }
                                        return window.Channel.nativeCall(window.MethodChannel.ChannelType, methodCall)
                                    }
                                }
                            }

                            // 直接返回
                            return target[prop];
                        }
                    });
                  },

                  _NextId: 0,// 初始ID值
                  _argsStubMap: {},
                  _listenerMap: {}, // TODO 弱引用自动取消
                  __registerArgStub: function (arg, isListener) {
                      var objectId = this._NextId++
                      if (isListener) {
                          this._listenerMap[objectId] = arg
                      } else {
                          this._argsStubMap[objectId] = arg
                      }
                      return objectId
                  },
                  __ArgsMethodStub: function (object){
                      const {call, args, stubId, isListener} = object

                      if(isListener) {
                          const listener = this._listenerMap[stubId]
                          listener && listener(...args)

                          return
                      }

                      const argsStub = this._argsStubMap[stubId];
                      if(!argsStub) {
                          return ;
                      }
                      // 只回调一次，可能会有问题，需测试
                      delete this._argsStubMap[stubId]

                      argsStub[call].call(argsStub, ...args)
                  }
              }
              window.MethodChannel.init()
        `
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
