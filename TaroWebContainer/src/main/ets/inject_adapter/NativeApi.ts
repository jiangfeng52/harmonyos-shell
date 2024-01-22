import { wbLogger } from '../utils/Logger'
import { MethodChannelInstance } from './Channel'
import { as } from '../utils/advancedapi.min';
import { Key } from '@ohos.multimodalInput.keyEvent';

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

interface Result {
  method: string
  arguments: Array<string>
  ignoreComplete: boolean
  ifKeepAlive: boolean
}

const createCallback = (options: ESObject) => {
  return (result: Result) => {
    if (result.method === 'success') {
      options.success(result.arguments)
    } else if (result.method === 'fail') {
      options.fail(result.arguments)
    }
  }
}

interface NativeApi {

  /**
   * 类型1：同步调用
   *
   * @returns 返回值对象里无方法
   */
  getWindowInfoBridgeSync(): WindowInfo

  getSystemInfoSyncBridgeSync(options: ESObject): SystemInfoSync

  getSystemSettingBridgeSync(options: ESObject): SettingInfo

  getAppBaseInfoBridgeSync(options: ESObject): AppBaseInfo

  getAppAuthorizeSettingBridgeSync(options: ESObject): AppAuthorizeSetting

  requestBridgeAsync(options: ESObject): ESObject

  downloadFileBridgeAsync(options: ESObject): ESObject

  uploadFileBridgeAsync(options: ESObject): ESObject

  saveImageToPhotosAlbumBridgeAsync(options: ESObject): ESObject

  getVideoInfoBridgeAsync(options: ESObject): void

  getImageInfoBridgeAsync(options: ESObject): void

  getLocationBridgeAsync(options: ESObject): void

  openDocumentBridgeAsync(options: ESObject): void

  getUserInfoBridgeSync(options: ESObject): void

  onUserCaptureScreenBridgeSync(options: ESObject): void

  hideKeyboardBridgeAsync(options: ESObject): void

  accessBridgeAsync(options: ESObject): ESObject

  saveFileBridgeAsync(options: ESObject): ESObject

  getFileInfoBridgeAsync(options: ESObject): ESObject

  readFileBridgeAsync(options: ESObject): ESObject

  readFileSyncBridgeSync(options: ESObject): ESObject

  createInnerAudioContextBridgeSync(options: ESObject): void

  stopBridgeSync(): void

  playBridgeSync(): void

  onPlayBridgeSync(options: ESObject): ESObject

  onStopBridgeSync(options: ESObject): ESObject

  onErrorBridgeSync(options: ESObject): ESObject

  onEndedBridgeSync(options: ESObject): ESObject

  abortBridgeSync(options: ESObject): ESObject

  offHeadersReceivedBridgeSync(options: ESObject): ESObject

  offProgressUpdateBridgeSync(options: ESObject): ESObject

  onHeadersReceivedBridgeSync(options: ESObject): ESObject

  onProgressUpdateBridgeSync(options: ESObject): ESObject
}

class NativeApiImpl implements NativeApi {
  private static fileManager: any
  private innerAudioContext: any
  private uploadTaskMap: Map<number, any>
  private uploadTaskID: number

  constructor() {
    this.uploadTaskMap = new Map()
    this.uploadTaskID = 0

  }
  private static getFileManager() {
    if (!NativeApiImpl.fileManager) {
      NativeApiImpl.fileManager = as.getFileSystemManager()
    }
    return NativeApiImpl.fileManager
  }

  getWindowInfoBridgeSync(): WindowInfo {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getWindowInfo`)
    return as.getWindowInfo()
  }

  getSystemInfoSyncBridgeSync(options: ESObject): SystemInfoSync {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getSystemInfoSync`)
    return as.getSystemInfoSync()
  }

  getSystemSettingBridgeSync(options: ESObject): SettingInfo {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getSystemSetting`)
    return as.getSystemSetting()
  }

  getAppBaseInfoBridgeSync(options: ESObject): AppBaseInfo {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getAppBaseInfo`)
    return as.getAppBaseInfo()
  }

  getAppAuthorizeSettingBridgeSync(options: ESObject): AppAuthorizeSetting {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getAppAuthorizeSetting`)
    return as.getAppAuthorizeSetting()
  }

  requestBridgeAsync(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$request`)
    return as.request({
      ...options,
      success: options.success,
      fail: options.fail,
    })
  }

  downloadFileBridgeAsync(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$downloadFile`)
    return as.downloadFile({
      ...options,
      success: options.success,
      fail: options.fail,
    })
  }

  saveImageToPhotosAlbumBridgeAsync(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$saveImageToPhotosAlbum`)
    return as.saveImageToPhotosAlbum({
      ...options,
      success: options.success,
      fail: options.fail
    })
  }

  getVideoInfoBridgeAsync(options: ESObject): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getVideoInfo`)
    return as.getVideoInfo({
      ...options,
      success: options.success,
      fail: options.fail
    })
  }

  getImageInfoBridgeAsync(options: ESObject): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getImageInfo`)
    return as.getImageInfo({
      ...options,
      success: options.success,
      fail: options.fail
    })
  }

  getLocationBridgeAsync(options: ESObject): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getLocation`)
    return as.getLocation({
      ...options,
      success: options.success,
      fail: options.fail
    })
  }

  openDocumentBridgeAsync(options: ESObject): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$openDocument`)
    return as.openDocument({
      ...options,
      success: options.success,
      fail: options.fail
    })
  }

  getUserInfoBridgeSync(options: ESObject): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getUserInfo`)
    return as.getUserInfo(options)
  }

  setKeepScreenOnBridgeAsync(options: ESObject): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$setKeepScreenOn`)
    return as.setKeepScreenOn({
      ...options,
      success: options.success,
      fail: options.fail
    })
  }

  //回调监听
  onUserCaptureScreenBridgeSync(options: ESObject): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$onUserCaptureScreen`)
    return as.onUserCaptureScreen(options)
  }

  hideKeyboardBridgeAsync(options: ESObject): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$hideKeyboard`)
    return as.hideKeyboard(options)
  }

  makePhoneCallBridgeAsync(options: ESObject): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$makePhoneCall`)
    return as.makePhoneCall({
      ...options,
      success: options.success,
      fail: options.fail
    })
  }

  saveFileBridgeAsync(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$access`)
    return as.saveFile({
      ...options,
      success: options.success,
      fail: options.fail
    })
  }

  accessBridgeAsync(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$access`)
    return NativeApiImpl.getFileManager().access({
      ...options,
      success: options.success,
      fail: options.fail,
      complete: options.complete
    })
  }

  getFileInfoBridgeAsync(options: any): any {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$getFileInfo`)
    return NativeApiImpl.getFileManager().getFileInfo({
      ...options,
      success: options.success,
      fail: options.fail,
      complete: options.complete
    })
  }

  readFileBridgeAsync(options: any): any {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$readFile`)
    return NativeApiImpl.getFileManager().readFile({
      ...options,
      success: options.success,
      fail: options.fail,
      complete: options.complete
    })
  }

  readFileSyncBridgeSync(options: any): any {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$readFileSync`)
    return NativeApiImpl.getFileManager().readFileSync(options)
  }

  createInnerAudioContextBridgeSync(options: any): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$createInnerAudioContext`)
    this.innerAudioContext = as.createInnerAudioContext()
  }

  stopBridgeSync(): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$stop`)
    this.innerAudioContext.stop()
  }

  playBridgeSync(): void {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$play`)
    this.innerAudioContext.play()
  }

  onPlayBridgeSync(options: any): any {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$onPlay`)
    this.innerAudioContext.onPlay(options)
  }

  onStopBridgeSync(options: any): any {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$onStop`)
    this.innerAudioContext.onStop(options)
  }

  onErrorBridgeSync(options: any): any {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$onError`)
    this.innerAudioContext.onError(options)
  }

  onEndedBridgeSync(options: any): any {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$onEnded`)
    this.innerAudioContext.onEnded(options)
  }

  uploadFileBridgeAsync(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$uploadFile`)
    const uploadTask = as.uploadFile({
      ...options,
      success: options.success,
      fail: options.fail,
      complete: options.complete
    })
    this.uploadTaskMap.set(this.uploadTaskID, uploadTask)
    return this.uploadTaskID ++
  }

  abortBridgeSync(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$abort`)
    if (!this.uploadTaskMap.has(options.taskID)){
      wbLogger.error('JsBridgeNativeApi', 'the uploadTask has not been init')
      return
    }
    this.uploadTaskMap.get(options.taskID).abort()
  }

  offHeadersReceivedBridgeSync(options: ESObject): ESObject{
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$offHeadersReceived`)
    if (!this.uploadTaskMap.has(options.taskID)){
      wbLogger.error('JsBridgeNativeApi', 'the uploadTask has not been init')
      return
    }
    this.uploadTaskMap.get(options.taskID).offHeadersReceived(options)
  }

  offProgressUpdateBridgeSync(options: ESObject): ESObject{
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$offProgressUpdate`)
    if (!this.uploadTaskMap.has(options.taskID)){
      wbLogger.error('JsBridgeNativeApi', 'the uploadTask has not been init')
      return
    }
    this.uploadTaskMap.get(options.taskID).offProgressUpdate(options)
  }

  onHeadersReceivedBridgeSync(options: ESObject): ESObject{
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$onHeadersReceived`)
    if (!this.uploadTaskMap.has(options.taskID)){
      wbLogger.error('JsBridgeNativeApi', 'the uploadTask has not been init')
      return
    }
    this.uploadTaskMap.get(options.taskID).onHeadersReceived(options)
  }

  onProgressUpdateBridgeSync(options: ESObject): ESObject{
    wbLogger.debug('JsBridgeNativeApi', `NativeApi$onProgressUpdate`)
    if (!this.uploadTaskMap.has(options.taskID)){
      wbLogger.error('JsBridgeNativeApi', 'the uploadTask has not been init')
      return
    }
    this.uploadTaskMap.get(options.taskID).onProgressUpdate(options)
  }
}

export const NativeApiImplInstance: NativeApiImpl = new NativeApiImpl()