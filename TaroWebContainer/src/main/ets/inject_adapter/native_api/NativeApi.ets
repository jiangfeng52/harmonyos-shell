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


import buffer from '@ohos.buffer';
import { taroLogger } from '../../utils/Logger';
import { as } from '../../utils/advancedapi.min';
import { CallInstanceParam, ClassInstanceApi } from '../../utils/ClassInstanceUtil';
import { NativeNavigateListener } from '../../tarohybrid/TaroHybridCoreInstance';
import { TaroHybridManager } from '../../tarohybrid/TaroHybridManager';
import { TaroWebController } from '../../components/TaroWeb';
import { StorageApi } from './StorageApi';
import { SuccessCallbackResult } from './TaroApi';

export interface StorageStatus {
  done: boolean; // 操作是否完成
  data: string | number | boolean | Uint8Array;
  errorMsg: string;
}

class NativeApiConfig {
  public fileManager: ESObject
  private static INSTANCE: NativeApiConfig

  public static getInstance() {
    if (!NativeApiConfig.INSTANCE) {
      NativeApiConfig.INSTANCE = new NativeApiConfig()
    }
    return NativeApiConfig.INSTANCE
  }

  // public storageStatusMap: Map<string, StorageStatus>

  constructor() {
    // this.networkTaskMap = new Map()
    // this.networkTaskID = 0
    // this.innerAudioContextMap = new Map()
    // this.innerAudioContextId = 0
    // this.storageStatusMap = new Map()
    // this.storageStatusMap = new Map()
  }
}

export class NativeApi {
  private indexHtmlPath: string
  private classInstanceApi: ClassInstanceApi
  private taroWebController: TaroWebController
  private storageApi: StorageApi

  constructor(indexHtmlPath: string, taroWebController: TaroWebController) {
    this.indexHtmlPath = indexHtmlPath
    this.classInstanceApi = new ClassInstanceApi()
    this.taroWebController = taroWebController
    this.storageApi = new StorageApi(indexHtmlPath)
  }

  public onWebViewAboutToAppear(){
    this.storageApi?.onWebViewAboutToAppear()
  }

  public onWebViewAboutToDisappear(){
    this.storageApi?.onWebViewAboutToDisappear()
  }

  nativeObj: ESObject = {
    getWindowInfo: as['getWindowInfo'],
    getSystemInfoSync: as['getSystemInfoSync'],
    getDeviceInfo: as['getDeviceInfo'],
    getSystemSetting: as['getSystemSetting'],
    getAppBaseInfo: as['getAppBaseInfo'],
    getAppAuthorizeSetting: as['getAppAuthorizeSetting'],
    compressImage: as['compressImage'],
    saveVideoToPhotosAlbum: as['saveVideoToPhotosAlbum'],
    startSoterAuthentication: as['startSoterAuthentication'],
    checkIsSupportSoterAuthentication: as['checkIsSupportSoterAuthentication'],
    checkIsSoterEnrolledInDevice: as['checkIsSoterEnrolledInDevice'],
    getFileInfo: as['getFileInfo'],

    saveImageToPhotosAlbum: (options: ESObject) => {
      as.saveImageToPhotosAlbum(options)
    },

    downloadFile(options: ESObject): void {
      as.downloadFile(options)
    },

    getVideoInfo(options: ESObject): void {
      return as.getVideoInfo(options)
    },

    openAppAuthorizeSetting(options: ESObject): void {
      as.openAppAuthorizeSetting(options)
    },

    startAccelerometer(options: ESObject): void {
      as.startAccelerometer(options)
    },

    stopAccelerometer(options: ESObject): void {
      as.stopAccelerometer(options)
    },

    onAccelerometerChange(options: ESObject): void {
      as.onAccelerometerChange(options)
    },

    offAccelerometerChange(options: ESObject): void {
      as.offAccelerometerChange(options)
    },

    startCompass(options: ESObject): void {
      as.startCompass(options)
    },

    stopCompass(options: ESObject): void {
      as.stopCompass(options)
    },

    onCompassChange(options: ESObject): void {
      as.onCompassChange(options)
    },

    offCompassChange(options: ESObject): void {
      as.offCompassChange(options)
    },

    startGyroscope(options: ESObject): void {
      as.startGyroscope(options)
    },

    stopGyroscope(options: ESObject): void {
      as.stopGyroscope(options)
    },

    onGyroscopeChange(options: ESObject): void {
      as.onGyroscopeChange(options)
    },

    getImageInfo(options: ESObject): void {
      return as.getImageInfo(options)

    },

    openDocument(options: ESObject): void {
      return as.openDocument(options)
    },

    login(options: ESObject): void {
      return as.login(options)
    },

    getUserInfo(options: ESObject): void {
      return as.getUserInfo(options)
    },

    setKeepScreenOn(options: ESObject): void {
      return as.setKeepScreenOn(options)
    },

    setScreenBrightness(options: ESObject): void {
      return as.setScreenBrightness(options)
    },

    getScreenBrightness(options: ESObject): void {
      return as.getScreenBrightness(options)
    },

    //回调监听
    onUserCaptureScreen(options: ESObject): void {
      return as.onUserCaptureScreen(options)
    },

    offUserCaptureScreen(options: ESObject): void {
      return as.offUserCaptureScreen(options)
    },

    hideKeyboard(options: ESObject): void {
      return as.hideKeyboard(options)
    },

    onKeyboardHeightChange(options: ESObject): void {
      return as.onKeyboardHeightChange(options)
    },

    offKeyboardHeightChange(options: ESObject): void {
      return as.offKeyboardHeightChange(options)
    },

    makePhoneCall(options: ESObject): void {
      return as.makePhoneCall(options)
    },

    getSavedFileInfo(options: ESObject): void {
      return as.getSavedFileInfo(options)
    },

    getSavedFileList(options: ESObject): void {
      return as.getSavedFileList(options)
    },

    removeSavedFile(options: ESObject): void {
      return as.removeSavedFile(options)
    },

    addPhoneContact(options: ESObject): void {
      return as.addPhoneContact(options)
    },

    scanCode(options: ESObject): void {
      return as.scanCode(options)
    },

    vibrateShort(options: ESObject): void {
      return as.vibrateShort(options)
    },

    vibrateLong(options: ESObject): void {
      return as.vibrateLong(options)
    },

    callInstance: (options: CallInstanceParam) => {
      return this.classInstanceApi.callInstance(options)
    },

    callInstanceAsync: (options: CallInstanceParam) => {
      this.classInstanceApi.callInstanceAsync(options)
    },

    createInstance: (options: ESObject) => {
      return this.classInstanceApi.createInstance(this.taroWebController, options)
    },

    syncAndReleaseInstance: (options: CallInstanceParam) => {
      this.classInstanceApi.syncAndReleaseInstance(options)
    },

    // NativeFileSystemManager
    getFileManager(options: ESObject): ESObject {
      NativeApiConfig.getInstance().fileManager = as.getFileSystemManager()
    },
    saveFile(options: ESObject): ESObject {
      return as.saveFile(options)
    },

    access(options: ESObject): ESObject {
      return NativeApiConfig.getInstance().fileManager.access(options)
    },

    getFileInformation(options: ESObject): ESObject {
      return NativeApiConfig.getInstance().fileManager.getFileInfo(options)
    },

    readFile(options: ESObject): ESObject {
      options = options || {}
      return NativeApiConfig.getInstance().fileManager.readFile({
        filePath: options.filePath,
        encoding: options.encoding,
        position: options.position,
        length: options.length,
        success: (res: ESObject) => {
          const result: ESObject = {
            result: res.data,
            bufBase64: (res?.data instanceof ArrayBuffer) ? buffer.from(res.data).toString('base64') : undefined,
          }
          options.success && options.success(result)
        },
        fail: options.fail,
      })
    },

    readFileSync(options: ESObject): ESObject {
      options = options || {}
      try {
        const data: Object = NativeApiConfig.getInstance().fileManager.readFileSync(
          options.filePath,
          options.encoding,
          options.position,
          options.length
        )
        return {
          result: data,
          bufBase64: (data instanceof ArrayBuffer) ? buffer.from(data).toString('base64') : undefined,
        }
      } catch (err) {
        return {
          error: `${err}` || `readFileSync:fail`
        }
      }
    },

    closeBLEConnection(options: ESObject): void {
      return as.closeBLEConnection(options)
    },

    createBLEConnection(options: ESObject): void {
      return as.createBLEConnection(options)
    },

    getBLEDeviceCharacteristics(options: ESObject): void {
      return as.getBLEDeviceCharacteristics(options)
    },

    getBLEDeviceRSSI(options: ESObject): void {
      return as.getBLEDeviceRSSI(options)
    },

    getBLEDeviceServices(options: ESObject): void {
      return as.getBLEDeviceServices(options)
    },

    notifyBLECharacteristicValueChange(options: ESObject): void {
      return as.notifyBLECharacteristicValueChange(options)
    },

    onBLECharacteristicValueChange(options: ESObject): void {
      return as.onBLECharacteristicValueChange(options)
    },

    onBLEConnectionStateChange(options: ESObject): void {
      return as.onBLEConnectionStateChange(options)
    },

    readBLECharacteristicValue(options: ESObject): void {
      return as.readBLECharacteristicValue(options)
    },

    setBLEMTU(options: ESObject): void {
      return as.setBLEMTU(options)
    },

    writeBLECharacteristicValue(options: ESObject): void {
      return as.writeBLECharacteristicValue(options)
    },

    closeBluetoothAdapter(options: ESObject): void {
      return as.closeBluetoothAdapter(options)
    },

    getBluetoothAdapterState(options: ESObject): void {
      return as.getBluetoothAdapterState(options)
    },

    getBluetoothDevices(options: ESObject): void {
      return as.getBluetoothDevices(options)
    },

    getConnectedBluetoothDevices(options: ESObject): void {
      return as.getConnectedBluetoothDevices(options)
    },

    offBluetoothAdapterStateChange(options: ESObject): void {
      return as.offBluetoothAdapterStateChange(options)
    },

    offBluetoothDeviceFound(options: ESObject): void {
      return as.offBluetoothDeviceFound(options)
    },

    onBluetoothAdapterStateChange(options: ESObject): void {
      return as.onBluetoothAdapterStateChange(options)
    },

    onBluetoothDeviceFound(options: ESObject): void {
      return as.onBluetoothDeviceFound(options)
    },

    openBluetoothAdapter(options: ESObject): void {
      return as.openBluetoothAdapter(options)
    },

    startBluetoothDevicesDiscovery(options: ESObject): void {
      return as.startBluetoothDevicesDiscovery(options)
    },

    stopBluetoothDevicesDiscovery(options: ESObject): void {
      return as.stopBluetoothDevicesDiscovery(options)
    },

    // data sharing
    // getExecStatus(options: ESObject): ESObject {
    //   taroLogger.debug('JsBridgeNativeApi', `NativeApi$getExecStatus`)
    //   const map = NativeApiConfig.getInstance().storageStatusMap
    //   const mkey = options.method +'$'+ options.key
    //   if ( !map.has(mkey) ) {
    //     return { done: false, data: '', errorMsg: '' }
    //   } else {
    //     const res = map.get(mkey)
    //     map.delete(mkey)
    //     return res
    //   }
    // },

    setStorage: (options: ESObject) => {
      this.storageApi.setStorage(options)
    },

    removeStorage: (options: ESObject) => {
      this.storageApi.removeStorage(options)
    },

    getStorage: (options: ESObject) => {
      taroLogger.debug('taro_storage', 'getStorage({key: %{public}s}) from jsbridge', options?.key)
      this.storageApi.getStorage(options)
    },

    getStorageSync: (options: ESObject): Promise<SuccessCallbackResult<string>> => {
      taroLogger.debug('taro_storage', 'getStorageSync({key: %{public}s}) from jsbridge', options?.key);
      return this.storageApi.getStorageSync(options);
    },

    getStorageInfo: (options: ESObject) => {
      this.storageApi.getStorageInfo(options)
    },

    clearStorage: (options: ESObject) => {
      this.storageApi.clearStorage(options)
    },

    batchGetPageShowDataStorage: (options: ESObject) => {
      this.storageApi.batchGetPageShowDataStorage(options)
    },

    updatePageShowDataKeys: (options: ESObject) => {
      this.storageApi.updatePageShowDataKeys(options)
    },

    onNativeNavigate: (options: NativeNavigateListener) => {
      const coreInstance = TaroHybridManager.getCoreInstance(this.indexHtmlPath)
      coreInstance?.setNativeNavigateListener(options)
    },
    nativeBack: () => {
      TaroHybridManager.nativeBack()
    },

    onStorageStatusChange: (options: (type: string, key: string) => void) => {
      this.storageApi.onStorageStatusChange(options)
    },

    offStorageStatusChange: (listener: (type: string, key: string) => void) => {
      this.storageApi.offStorageStatusChange(listener)
    }
  }
}


