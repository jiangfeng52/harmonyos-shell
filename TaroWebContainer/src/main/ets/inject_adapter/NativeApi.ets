import buffer from '@ohos.buffer';
import { wbLogger } from '../utils/Logger'
import { as } from '../utils/advancedapi.min';


interface WindowInfo {
  pixelRatio?: number,
  screenWidth?: number,
  screenHeight?: number
}


/**
 * 定义出对象类型：
 * {
 *   size: {
 *     windowWidth: number,
 *     windowHeight: number
 *   }
 * }
 */
interface WindowSize {
  windowWidth?: number,
  windowHeight?: number
}

interface WindowResizeResult {
  size?: WindowSize
}

interface OpenSystemBluetoothSetting {
  success?: (res: string) => void,
  fail?: (res: string) => void,
  complete?: (res: string) => void
}

interface DeviceOrientation {
  portrait
  landscape
}

interface SettingInfo {
  bluetoothEnabled ?: boolean,
  locationEnabled ?: boolean,
  wifiEnabled ?: boolean,
  deviceOrientation ?: keyof DeviceOrientation
}

interface Theme {
  dark
  light
}

interface Host {
  appId: string
}

interface AppBaseInfo {
  SDKVersion?: string
  enableDebug?: boolean
  host?: Host
  language: string
  version?: string
  theme?: keyof Theme
}

interface Authorized {
  authorized
  denied
  'not determined'
}

interface AppAuthorizeSetting {
  albumAuthorized: keyof Authorized
  bluetoothAuthorized: keyof Authorized
  cameraAuthorized: keyof Authorized
  locationAuthorized: keyof Authorized
  locationReducedAccuracy: boolean
  microphoneAuthorized: keyof Authorized
  notificationAuthorized: keyof Authorized
  notificationAlertAuthorized: keyof Authorized
  notificationBadgeAuthorized: keyof Authorized
  notificationSoundAuthorized: keyof Authorized
  phoneCalendarAuthorized: keyof Authorized
}

interface SystemInfoSync {
  brand: string
  model: string
  language: string
  version?: string
  system: string
  platform: string
  fontSizeSetting?: number
  SDKVersion?: string
  benchmarkLevel: number
  deviceOrientation?: keyof DeviceOrientation

}


interface NativeApi {

  /**
   * 类型1：同步调用
   *
   * @returns 返回值对象里无方法
   */
  getWindowInfo(): WindowInfo

  getSystemInfoSync(options: ESObject): SystemInfoSync

  getSystemSetting(options: ESObject): SettingInfo

  getAppBaseInfo(options: ESObject): AppBaseInfo

  getAppAuthorizeSetting(options: ESObject): AppAuthorizeSetting

  request(options: ESObject): ESObject

  downloadFile(options: ESObject): ESObject

  uploadFile(options: ESObject): ESObject

  saveImageToPhotosAlbum(options: ESObject): ESObject

  getVideoInfo(options: ESObject): void

  getImageInfo(options: ESObject): void

  getLocation(options: ESObject): void

  openDocument(options: ESObject): void

  getUserInfo(options: ESObject): void

  onUserCaptureScreen(options: ESObject): void

  hideKeyboard(options: ESObject): void

  access(options: ESObject): ESObject

  saveFile(options: ESObject): ESObject

  getFileInfo(options: ESObject): ESObject

  readFile(options: ESObject): ESObject

  readFileSync(options: ESObject): ESObject

  createInnerAudioContext(options: ESObject): void

  innerAudioStop(options: ESObject, objectId: number): void

  innerAudioPlay(options: ESObject, objectId: number): void

  innerAudioOnPlay(options: ESObject, objectId: number): ESObject

  innerAudioOnStop(options: ESObject, objectId: number): ESObject

  innerAudioOnError(options: ESObject, objectId: number): ESObject

  innerAudioOnEnded(options: ESObject, objectId: number): ESObject

  abort(options: ESObject, objectId: number): ESObject

  offHeadersReceived(options: ESObject, objectId: number): ESObject

  offProgressUpdate(options: ESObject, objectId: number): ESObject

  onHeadersReceived(options: ESObject, objectId: number): ESObject

  onProgressUpdate(options: ESObject, objectId: number): ESObject

  getAudioContextVolume(options: ESObject, objectId: number): ESObject

  setAudioContextVolume(options: ESObject, objectId: number): ESObject

  getAudioContextStartTime(options: ESObject, objectId: number): ESObject

  setAudioContextStartTime(options: ESObject, objectId: number): ESObject

  getAudioContextPlaybackRate(options: ESObject, objectId: number): ESObject

  setAudioContextPlaybackRate(options: ESObject, objectId: number): ESObject

  getAudioContextPaused(options: ESObject, objectId: number): ESObject

  setAudioContextPaused(options: ESObject, objectId: number): ESObject

  getAudioContextObeyMuteSwitch(options: ESObject, objectId: number): ESObject

  setAudioContextObeyMuteSwitch(options: ESObject, objectId: number): ESObject

  getAudioContextLoop(options: ESObject, objectId: number): ESObject

  setAudioContextLoop(options: ESObject, objectId: number): ESObject

  getAudioContextDuration(options: ESObject, objectId: number): ESObject

  setAudioContextDuration(options: ESObject, objectId: number): ESObject

  getAudioContextCurrentTime(options: ESObject, objectId: number): ESObject

  setAudioContextCurrentTime(options: ESObject, objectId: number): ESObject

  getAudioContextBuffered(options: ESObject, objectId: number): ESObject

  setAudioContextBuffered(options: ESObject, objectId: number): ESObject

  getAudioContextAutoplay(options: ESObject, objectId: number): ESObject

  setAudioContextAutoplay(options: ESObject, objectId: number): ESObject

  getAudioContextSrc(options: ESObject, objectId: number): ESObject

  setAudioContextSrc(options: ESObject, objectId: number): ESObject
}

class NativeApiImpl implements NativeApi {
  private static fileManager: ESObject
  private networkTaskMap: Map<number, ESObject>
  private networkTaskID: number
  private innerAudioContextMap: Map<number, ESObject>
  private innerAudioContextId: number

  constructor() {
    this.networkTaskMap = new Map()
    this.networkTaskID = 0
    this.innerAudioContextMap = new Map()
    this.innerAudioContextId = 0
  }

  private static getFileManager(): ESObject {
    if (!NativeApiImpl.fileManager) {
      NativeApiImpl.fileManager = as.getFileSystemManager()
    }
    return NativeApiImpl.fileManager
  }

  getWindowInfo(): WindowInfo {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getWindowInfo`)
    return as.getWindowInfo()
  }

  getSystemInfoSync(options: ESObject): SystemInfoSync {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getSystemInfoSync`)
    return as.getSystemInfoSync()
  }

  getSystemSetting(options: ESObject): SettingInfo {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getSystemSetting`)
    return as.getSystemSetting()
  }

  getAppBaseInfo(options: ESObject): AppBaseInfo {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getAppBaseInfo`)
    return as.getAppBaseInfo()
  }

  getAppAuthorizeSetting(options: ESObject): AppAuthorizeSetting {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getAppAuthorizeSetting`)
    return as.getAppAuthorizeSetting()
  }

  downloadFile(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$downloadFile`)
    return as.downloadFile(options)
  }

  saveImageToPhotosAlbum(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$saveImageToPhotosAlbum`)
    return as.saveImageToPhotosAlbum(options)
  }

  getVideoInfo(options: ESObject): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getVideoInfo`)
    return as.getVideoInfo(options)
  }

  getImageInfo(options: ESObject): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getImageInfo`)
    return as.getImageInfo(options)
  }

  getLocation(options: ESObject): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getLocation`)
    return as.getLocation(options)
  }

  openDocument(options: ESObject): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$openDocument`)
    return as.openDocument(options)
  }

  getUserInfo(options: ESObject): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getUserInfo`)
    return as.getUserInfo(options)
  }

  setKeepScreenOn(options: ESObject): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$setKeepScreenOn`)
    return as.setKeepScreenOn(options)
  }

  //回调监听
  onUserCaptureScreen(options: ESObject): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$onUserCaptureScreen`)
    return as.onUserCaptureScreen(options)
  }

  hideKeyboard(options: ESObject): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$hideKeyboard`)
    return as.hideKeyboard(options)
  }

  makePhoneCall(options: ESObject): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$makePhoneCall`)
    return as.makePhoneCall(options)
  }

  // NativeRequest
  request(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$request`)
    const networkTask: ESObject = as.request(options)
    this.networkTaskMap.set(this.networkTaskID, networkTask)
    return this.networkTaskID ++
  }

  // NativeFileSystemManager
  saveFile(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$access`)
    return as.saveFile(options)
  }

  access(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$access`)
    return NativeApiImpl.getFileManager().access(options)
  }

  getFileInfo(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getFileInfo`)
    return NativeApiImpl.getFileManager().getFileInfo(options)
  }

  readFile(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$readFile`)
    options = options || {}
    return NativeApiImpl.getFileManager().readFile({
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
  }

  readFileSync(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$readFileSync`)
    options = options || {}
    try {
      const data: Object = NativeApiImpl.getFileManager().readFileSync(
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
  }

  // NativeUploadFile
  uploadFile(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$uploadFile`)
    const networkTask: ESObject = as.uploadFile(options)
    this.networkTaskMap.set(this.networkTaskID, networkTask)
    return this.networkTaskID ++
  }

  abort(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$abort`)
    if (!this.networkTaskMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the Task has not been init')
      return
    }
    this.networkTaskMap.get(objectId).abort()
  }

  offHeadersReceived(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$offHeadersReceived`)
    if (!this.networkTaskMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the Task has not been init')
      return
    }
    this.networkTaskMap.get(objectId).offHeadersReceived(options)
  }

  offProgressUpdate(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$offProgressUpdate`)
    if (!this.networkTaskMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the Task has not been init')
      return
    }
    this.networkTaskMap.get(objectId).offProgressUpdate(options)
  }

  onHeadersReceived(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$onHeadersReceived`)
    if (!this.networkTaskMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the Task has not been init')
      return
    }
    this.networkTaskMap.get(objectId).onHeadersReceived(options)
  }

  onProgressUpdate(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$onProgressUpdate`)
    if (!this.networkTaskMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the Task has not been init')
      return
    }
    this.networkTaskMap.get(objectId).onProgressUpdate(options)
  }

  //NativeAContextApi
  createInnerAudioContext(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$createInnerAudioContext`)
    const innerAudioContext: ESObject = as.createInnerAudioContext()
    this.innerAudioContextMap.set(this.innerAudioContextId, innerAudioContext)
    return this.innerAudioContextId++
  }

  innerAudioStop(options: ESObject, objectId: number): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$stop`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the context has not been init')
      return
    }
    this.innerAudioContextMap.get(objectId).stop()
  }

  innerAudioPlay(options: ESObject, objectId: number): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$play`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the context has not been init')
      return
    }
    this.innerAudioContextMap.get(objectId).play()
  }

  innerAudioOnPlay(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$onPlay`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the context has not been init')
      return
    }
    this.innerAudioContextMap.get(objectId).onPlay(options)
  }

  innerAudioOnStop(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$onStop`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the context has not been init')
      return
    }
    this.innerAudioContextMap.get(objectId).onStop(options)
  }

  innerAudioOnError(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$onError`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the context has not been init')
      return
    }
    this.innerAudioContextMap.get(objectId).onError(options)
  }

  innerAudioOnEnded(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$onEnded`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the context has not been init')
      return
    }
    this.innerAudioContextMap.get(objectId).onEnded(options)
  }

  getAudioContextVolume(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextVolume`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    return this.innerAudioContextMap.get(objectId).volume
  }

  setAudioContextVolume(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextVolume`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    this.innerAudioContextMap.get(objectId).volume = options
  }

  getAudioContextStartTime(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextStartTime`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    return this.innerAudioContextMap.get(objectId).startTime
  }

  setAudioContextStartTime(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextStartTime`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    this.innerAudioContextMap.get(objectId).startTime = options
  }

  getAudioContextPlaybackRate(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextPlaybackRate`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    return this.innerAudioContextMap.get(objectId).playbackRate
  }

  setAudioContextPlaybackRate(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextPlaybackRate`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    this.innerAudioContextMap.get(objectId).playbackRate = options
  }

  getAudioContextPaused(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextPausede`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    return this.innerAudioContextMap.get(objectId).paused
  }

  setAudioContextPaused(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextPaused`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    this.innerAudioContextMap.get(objectId).paused = options
  }

  getAudioContextObeyMuteSwitch(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextObeyMuteSwitch`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    return this.innerAudioContextMap.get(objectId).obeyMuteSwitch
  }

  setAudioContextObeyMuteSwitch(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextObeyMuteSwitch`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    this.innerAudioContextMap.get(objectId).obeyMuteSwitch = options
  }

  getAudioContextLoop(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextLoop`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    return this.innerAudioContextMap.get(objectId).loop
  }

  setAudioContextLoop(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextLoop`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    this.innerAudioContextMap.get(objectId).loop = options
  }

  getAudioContextDuration(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextDuration`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    return this.innerAudioContextMap.get(objectId).duration
  }

  setAudioContextDuration(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextDuration`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    this.innerAudioContextMap.get(objectId).duration = options
  }

  getAudioContextCurrentTime(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextCurrentTime`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    return this.innerAudioContextMap.get(objectId).currentTime
  }

  setAudioContextCurrentTime(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextCurrentTime`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    this.innerAudioContextMap.get(objectId).currentTime = options
  }

  getAudioContextBuffered(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextBuffered`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    return this.innerAudioContextMap.get(objectId).buffered
  }

  setAudioContextBuffered(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextBuffered`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    this.innerAudioContextMap.get(objectId).buffered = options
  }

  getAudioContextAutoplay(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextAutoplay`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    return this.innerAudioContextMap.get(objectId).autoplay
  }

  setAudioContextAutoplay(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextAutoplay`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    this.innerAudioContextMap.get(objectId).autoplay = options
  }

  getAudioContextSrc(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getAudioContextSrc`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    return this.innerAudioContextMap.get(objectId).src
  }

  setAudioContextSrc(options: ESObject, objectId: number): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$setAudioContextSrc`)
    if (!this.innerAudioContextMap.has(objectId)) {
      wbLogger.error('JsBridgeNativeApi', 'the AudioContext has not been init')
      return
    }
    this.innerAudioContextMap.get(objectId).src = options
  }
}

export const NativeApiImplInstance: NativeApiImpl = new NativeApiImpl()