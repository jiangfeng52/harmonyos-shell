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
import { taroLogger } from '../utils/Logger'
import { GlobalThis } from '../utils/GlobalThis'
import { as } from '../utils/advancedapi.min';
import { KEY_PREFIX } from '../utils/Storage'
import { BusinessError } from '@ohos.base';
import { taroStorage } from './TaroStorage';

export interface StorageStatus {
  done: boolean; // 操作是否完成
  data: string|number|boolean|Uint8Array;
  errorMsg: string;
}

class NativeApiConfig {
  public fileManager: ESObject
  public networkTaskMap: Map<number, ESObject>
  public networkTaskID: number
  public innerAudioContextMap: Map<number, ESObject>
  public innerAudioContextId: number
  private static INSTANCE: NativeApiConfig
  public static getInstance(){
    if (!NativeApiConfig.INSTANCE){
      NativeApiConfig.INSTANCE = new NativeApiConfig()
    }
    return NativeApiConfig.INSTANCE
  }
  // public storageStatusMap: Map<string, StorageStatus>

  constructor() {
    this.networkTaskMap = new Map()
    this.networkTaskID = 0
    this.innerAudioContextMap = new Map()
    this.innerAudioContextId = 0
    // this.storageStatusMap = new Map()
  }
}

export class NativeApi {
  private indexHtmlPath: string
  constructor(indexHtmlPath: string) {
    this.indexHtmlPath = indexHtmlPath
  }
  nativeObj: ESObject =  {
    getWindowInfo: as['getWindowInfo'],
    getSystemInfoSync: as['getSystemInfoSync'],
    getDeviceInfo: as['getDeviceInfo'],
    getSystemSetting: as['getSystemSetting'],
    getAppBaseInfo: as['getAppBaseInfo'],
    getAppAuthorizeSetting: as['getAppAuthorizeSetting'],

    saveImageToPhotosAlbum: (options: ESObject) => {
      as.saveImageToPhotosAlbum(options)
    },

    downloadFile(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$downloadFile`)
      as.downloadFile(options)
    },
    
    getVideoInfo(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getVideoInfo`)
      return as.getVideoInfo(options)
    },

    openAppAuthorizeSetting(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$openAppAuthorizeSetting`)
      as.openAppAuthorizeSetting(options)
    },

    startAccelerometer(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$startAccelerometer`)
      as.startAccelerometer(options)
    },

    stopAccelerometer(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$stopAccelerometer`)
      as.stopAccelerometer(options)
    },

    onAccelerometerChange(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$onAccelerometerChange`)
      as.onAccelerometerChange(options)
    },

    offAccelerometerChange(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$offAccelerometerChange`)
      as.offAccelerometerChange(options)
    },

    startCompass(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$startCompass`)
      as.startCompass(options)
    },

    stopCompass(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$stopCompass`)
      as.stopCompass(options)
    },

    onCompassChange(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$onCompassChange`)
      as.onCompassChange(options)
    },

    offCompassChange(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$offCompassChange`)
      as.offCompassChange(options)
    },

    startGyroscope(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$startGyroscope`)
      as.startGyroscope(options)
    },

    stopGyroscope(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$stopGyroscope`)
      as.stopGyroscope(options)
    },

    onGyroscopeChange(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$onGyroscopeChange`)
      as.onGyroscopeChange(options)
    },

    getImageInfo(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getImageInfo`)
      return as.getImageInfo(options)

    },

    getLocation(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getLocation`)
      return as.getLocation(options)
    },

    openDocument(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$openDocument`)
      return as.openDocument(options)
    },

    login(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$login`)
      return as.login(options)
    },

    getUserInfo(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getUserInfo`)
      return as.getUserInfo(options)
    },

    setKeepScreenOn(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$setKeepScreenOn`)
      return as.setKeepScreenOn(options)
    },

    setScreenBrightness(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$setScreenBrightness`)
      return as.setScreenBrightness(options)
    },

    getScreenBrightness(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getScreenBrightness`)
      return as.getScreenBrightness(options)
    },

    //回调监听
    onUserCaptureScreen(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$onUserCaptureScreen`)
      return as.onUserCaptureScreen(options)
    },

    offUserCaptureScreen(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$offUserCaptureScreen`)
      return as.offUserCaptureScreen(options)
    },

    onLocationChange(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$onLocationChange`)
      return as.onLocationChange(options)
    },

    offLocationChange(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$offLocationChange`)
      return as.offLocationChange(options)
    },

    hideKeyboard(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$hideKeyboard`)
      return as.hideKeyboard(options)
    },

    onKeyboardHeightChange(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$onKeyboardHeightChange`)
      return as.onKeyboardHeightChange(options)
    },

    offKeyboardHeightChange(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$offKeyboardHeightChange`)
      return as.offKeyboardHeightChange(options)
    },

    makePhoneCall(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$makePhoneCall`)
      return as.makePhoneCall(options)
    },

    getSavedFileInfo(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getSavedFileInfo`)
      return as.getSavedFileInfo(options)
    },

    getSavedFileList(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getSavedFileList`)
      return as.getSavedFileList(options)
    },

    removeSavedFile(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$removeSavedFile`)
      return as.removeSavedFile(options)
    },

    addPhoneContact(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$addPhoneContact`)
      return as.addPhoneContact(options)
    },

    scanCode(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$scanCode`)
      return as.scanCode(options)
    },

    vibrateShort(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$vibrateShort`)
      return as.vibrateShort(options)
    },

    vibrateLong(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$vibrateLong`)
      return as.vibrateLong(options)
    },

    // NativeRequest
    request(options: ESObject): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$request`)
      const networkTask: ESObject = as.request(options)
      NativeApiConfig.getInstance().networkTaskMap.set(NativeApiConfig.getInstance().networkTaskID, networkTask)
      return NativeApiConfig.getInstance().networkTaskID++
    },

    // NativeFileSystemManager
    getFileManager(options: ESObject): ESObject {
      NativeApiConfig.getInstance().fileManager = as.getFileSystemManager()
    },
    saveFile(options: ESObject): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$access`)
      return as.saveFile(options)
    },

    access(options: ESObject): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$access`)
      return NativeApiConfig.getInstance().fileManager.access(options)
    },

    getFileInfo(options: ESObject): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getFileInfo`)
      return NativeApiConfig.getInstance().fileManager.getFileInfo(options)
    },

    readFile(options: ESObject): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$readFile`)
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
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$readFileSync`)
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

    // NativeUploadFile
    uploadFile(options: ESObject): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$uploadFile`)
      const networkTask: ESObject = as.uploadFile(options)
      NativeApiConfig.getInstance().networkTaskMap.set(NativeApiConfig.getInstance().networkTaskID, networkTask)
      return NativeApiConfig.getInstance().networkTaskID++
    },

    abort(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$abort`)
      if (!NativeApiConfig.getInstance().networkTaskMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the Task has not been init')
        return
      }
      NativeApiConfig.getInstance().networkTaskMap.get(objectId).abort()
    },

    offHeadersReceived(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$offHeadersReceived`)
      if (!NativeApiConfig.getInstance().networkTaskMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the Task has not been init')
        return
      }
      NativeApiConfig.getInstance().networkTaskMap.get(objectId).offHeadersReceived(options)
    },

    offProgressUpdate(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$offProgressUpdate`)
      if (!NativeApiConfig.getInstance().networkTaskMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the Task has not been init')
        return
      }
      NativeApiConfig.getInstance().networkTaskMap.get(objectId).offProgressUpdate(options)
    },

    onHeadersReceived(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$onHeadersReceived`)
      if (!NativeApiConfig.getInstance().networkTaskMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the Task has not been init')
        return
      }
      NativeApiConfig.getInstance().networkTaskMap.get(objectId).onHeadersReceived(options)
    },

    onProgressUpdate(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$onProgressUpdate`)
      if (!NativeApiConfig.getInstance().networkTaskMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the Task has not been init')
        return
      }
      NativeApiConfig.getInstance().networkTaskMap.get(objectId).onProgressUpdate(options)
    },

    //NativeAContextApi
    createInnerAudioContext(options: ESObject): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$createInnerAudioContext`)
      const innerAudioContext: ESObject = as.createInnerAudioContext()
      NativeApiConfig.getInstance().innerAudioContextMap.set(NativeApiConfig.getInstance().innerAudioContextId, innerAudioContext)
      return NativeApiConfig.getInstance().innerAudioContextId++
    },

    innerAudioStop(options: ESObject, objectId: number): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$stop`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the context has not been init')
        return
      }
      NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).stop()
    },

    innerAudioPause(options: ESObject, objectId: number): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$pause`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the context has not been init')
        return
      }
      NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).pause()
    },

    innerAudioPlay(options: ESObject, objectId: number): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$play`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the context has not been init')
        return
      }
      NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).play()
    },

    innerAudioOnPlay(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$onPlay`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the context has not been init')
        return
      }
      NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).onPlay(options)
    },

    innerAudioOnStop(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$onStop`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the context has not been init')
        return
      }
      NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).onStop(options)
    },

    innerAudioOnError(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$onError`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the context has not been init')
        return
      }
      NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).onError(options)
    },

    innerAudioOnEnded(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$onEnded`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the context has not been init')
        return
      }
      NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).onEnded(options)
    },

    getAudioContextVolume(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextVolume`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      return NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).volume
    },

    setAudioContextVolume(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextVolume`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).volume = options
    },

    getAudioContextStartTime(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextStartTime`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      return NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).startTime
    },

    setAudioContextStartTime(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextStartTime`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).startTime = options
    },

    getAudioContextPlaybackRate(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextPlaybackRate`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      return NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).playbackRate
    },

    setAudioContextPlaybackRate(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextPlaybackRate`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).playbackRate = options
    },

    getAudioContextPaused(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextPausede`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      return NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).paused
    },

    setAudioContextPaused(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextPaused`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).paused = options
    },

    getAudioContextObeyMuteSwitch(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextObeyMuteSwitch`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      return NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).obeyMuteSwitch
    },

    setAudioContextObeyMuteSwitch(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextObeyMuteSwitch`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).obeyMuteSwitch = options
    },

    getAudioContextLoop(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextLoop`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      return NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).loop
    },

    setAudioContextLoop(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextLoop`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).loop = options
    },

    getAudioContextDuration(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextDuration`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      return NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).duration
    },

    setAudioContextDuration(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextDuration`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).duration = options
    },

    getAudioContextCurrentTime(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextCurrentTime`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      return NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).currentTime
    },

    setAudioContextCurrentTime(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextCurrentTime`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).currentTime = options
    },

    getAudioContextBuffered(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextBuffered`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      return NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).buffered
    },

    setAudioContextBuffered(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextBuffered`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).buffered = options
    },

    getAudioContextAutoplay(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextAutoplay`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      return NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).autoplay
    },

    setAudioContextAutoplay(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextAutoplay`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).autoplay = options
    },

    getAudioContextSrc(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextSrc`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      return NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).src
    },

    setAudioContextSrc(options: ESObject, objectId: number): ESObject {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextSrc`)
      if (!NativeApiConfig.getInstance().innerAudioContextMap.has(objectId)) {
        taroLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
        return
      }
      NativeApiConfig.getInstance().innerAudioContextMap.get(objectId).src = options
    },

    closeBLEConnection(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$closeBLEConnection`)
      return as.closeBLEConnection(options)
    },

    createBLEConnection(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$createBLEConnection`)
      return as.createBLEConnection(options)
    },

    getBLEDeviceCharacteristics(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getBLEDeviceCharacteristics`)
      return as.getBLEDeviceCharacteristics(options)
    },

    getBLEDeviceRSSI(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getBLEDeviceRSSI`)
      return as.getBLEDeviceRSSI(options)
    },

    getBLEDeviceServices(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getBLEDeviceServices`)
      return as.getBLEDeviceServices(options)
    },

    notifyBLECharacteristicValueChange(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$notifyBLECharacteristicValueChange`)
      return as.notifyBLECharacteristicValueChange(options)
    },

    onBLECharacteristicValueChange(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$onBLECharacteristicValueChange`)
      return as.onBLECharacteristicValueChange(options)
    },

    onBLEConnectionStateChange(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$onBLEConnectionStateChange`)
      return as.onBLEConnectionStateChange(options)
    },

    readBLECharacteristicValue(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$readBLECharacteristicValue`)
      return as.readBLECharacteristicValue(options)
    },

    setBLEMTU(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$setBLEMTU`)
      return as.setBLEMTU(options)
    },

    writeBLECharacteristicValue(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$writeBLECharacteristicValue`)
      return as.writeBLECharacteristicValue(options)
    },

    closeBluetoothAdapter(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$closeBluetoothAdapter`)
      return as.closeBluetoothAdapter(options)
    },

    getBluetoothAdapterState(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getBluetoothAdapterState`)
      return as.getBluetoothAdapterState(options)
    },

    getBluetoothDevices(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getBluetoothDevices`)
      return as.getBluetoothDevices(options)
    },

    getConnectedBluetoothDevices(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$getConnectedBluetoothDevices`)
      return as.getConnectedBluetoothDevices(options)
    },

    offBluetoothAdapterStateChange(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$offBluetoothAdapterStateChange`)
      return as.offBluetoothAdapterStateChange(options)
    },

    offBluetoothDeviceFound(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$offBluetoothDeviceFound`)
      return as.offBluetoothDeviceFound(options)
    },

    onBluetoothAdapterStateChange(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$onBluetoothAdapterStateChange`)
      return as.onBluetoothAdapterStateChange(options)
    },

    onBluetoothDeviceFound(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$onBluetoothDeviceFound`)
      return as.onBluetoothDeviceFound(options)
    },

    openBluetoothAdapter(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$openBluetoothAdapter`)
      return as.openBluetoothAdapter(options)
    },

    startBluetoothDevicesDiscovery(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$startBluetoothDevicesDiscovery`)
      return as.startBluetoothDevicesDiscovery(options)
    },

    stopBluetoothDevicesDiscovery(options: ESObject): void {
      taroLogger.debug('JsBridgeNativeApi', `NativeApi$stopBluetoothDevicesDiscovery`)
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
      taroStorage.set(options)
    },

    removeStorage: (options: ESObject) => {
      taroStorage.remove(options)
    },

    getStorage: (options: ESObject) => {
      taroStorage.get(options)
    },

    getStorageSync: (key: string) => {
      return taroStorage.getByPromise(key)
    },

    getStorageInfo: (options: ESObject) => {
      taroStorage.getInfo(options)
    },

    clearStorage: (options: ESObject) => {
      taroStorage.clear(options)
    },

    batchGetPageShowDataStorage: (options: ESObject) => {
      taroStorage.batchGetPageShowData(this.indexHtmlPath, options)
    },

    updatePageShowDataKeys: (options: ESObject) => {
      taroStorage.updatePageShowDataKeys(this.indexHtmlPath, options)
    }
  }
}


