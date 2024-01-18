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

  compressVideoBridgeAsync(options: ESObject): void

  createInnerAudioContextBridgeAsync(options: ESObject): void

  getLocationBridgeAsync(options: ESObject): void

  openDocumentBridgeAsync(options: ESObject): void

  loginBridgeAsync(options: ESObject): void

  getUserInfoBridgeAsync(options: ESObject): void

  onUserCaptureScreenBridgeSync(options: ESObject): void

  hideKeyboardBridgeAsync(options: ESObject): void

  getFileSystemManagerBridgeSync(options: ESObject): ESObject
}

class NativeApiImpl implements NativeApi {
  getWindowInfoBridgeSync(): WindowInfo {
    wbLogger.debug('JsBridgeNative', `NativeApi$getWindowInfo`)
    return as.getWindowInfo()
  }

  getSystemInfoSyncBridgeSync(options: ESObject): SystemInfoSync {
    wbLogger.debug('JsBridgeNative', `NativeApi$getSystemInfoSync`)
    return as.getSystemInfoSync()
  }

  getSystemSettingBridgeSync(options: ESObject): SettingInfo {
    wbLogger.debug('JsBridgeNative', `NativeApi$getSystemSetting`)
    return as.getSystemSetting()
  }

  getAppBaseInfoBridgeSync(options: ESObject): AppBaseInfo {
    wbLogger.debug('JsBridgeNative', `NativeApi$getAppBaseInfo`)
    return as.getAppBaseInfo()
  }

  getAppAuthorizeSettingBridgeSync(options: ESObject): AppAuthorizeSetting {
    wbLogger.debug('JsBridgeNative', `NativeApi$getAppAuthorizeSetting`)
    return as.getAppAuthorizeSetting()
  }

  requestBridgeAsync(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNative', `NativeApi$request`)
    return as.request({
      ...options,
      success: options.success,
      fail: options.fail,
    })
  }

  downloadFileBridgeAsync(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNative', `NativeApi$downloadFile`)
    return as.downloadFile({
      ...options,
      success: options.success,
      fail: options.fail,
    })
  }

  uploadFileBridgeAsync(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNative', `NativeApi$uploadFile`)
    return as.uploadFile({
      ...options,
      success: options.success,
      fail: options.fail,
      complete: options.complete
    })
  }

  saveImageToPhotosAlbumBridgeAsync(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNative', `NativeApi$saveImageToPhotosAlbum`)
    return as.saveImageToPhotosAlbum({
      ...options,
      success: options.success,
      fail: options.fail
    })
  }

  getVideoInfoBridgeAsync(options: ESObject): void {
    wbLogger.debug('JsBridgeNative', `NativeApi$getVideoInfo`)
    return as.getImageInfo({
      ...options,
      success: options.success,
      fail: options.fail
    })
  }

  getImageInfoBridgeAsync(options: ESObject): void {
    wbLogger.debug('JsBridgeNative', `NativeApi$getImageInfo`)
    return as.getImageInfo({
      ...options,
      success: options.success,
      fail: options.fail
    })
  }

  compressVideoBridgeAsync(options: ESObject): void {
    wbLogger.debug('JsBridgeNative', `NativeApi$compressVideo`)
    return as.compressVideo({
      ...options,
      success: options.success,
      fail: options.fail
    })
  }

  createInnerAudioContextBridgeAsync(options: ESObject): void {
    wbLogger.debug('JsBridgeNative', `NativeApi$createInnerAudioContext`)
    return as.createInnerAudioContext(options)
  }

  getLocationBridgeAsync(options: ESObject): void {
    wbLogger.debug('JsBridgeNative', `NativeApi$getLocation`)
    return as.getLocation({
      ...options,
      success: options.success,
      fail: options.fail
    })
  }

  openDocumentBridgeAsync(options: ESObject): void {
    wbLogger.debug('JsBridgeNative', `NativeApi$openDocument`)
    return as.openDocument({
      ...options,
      success: options.success,
      fail: options.fail
    })
  }

  loginBridgeAsync(options: ESObject): void {
    wbLogger.debug('JsBridgeNative', `NativeApi$login`)
    return as.login(options)
  }

  getUserInfoBridgeAsync(options: ESObject): void {
    wbLogger.debug('JsBridgeNative', `NativeApi$getUserInfo`)
    return as.getUserInfo(options)
  }

  getFileSystemManagerBridgeSync(options: ESObject): ESObject {
    wbLogger.debug('JsBridgeNative', `NativeApi$getFileSystemManager`)
    return as.getFileSystemManager(options)
  }

  setKeepScreenOnBridgeAsync(options: ESObject): void {
    wbLogger.debug('JsBridgeNative', `NativeApi$setKeepScreenOn`)
    return as.setKeepScreenOn({
      ...options,
      success: options.success,
      fail: options.fail
    })
  }

  //回调监听
  onUserCaptureScreenBridgeSync(options: ESObject): void {
    wbLogger.debug('JsBridgeNative', `NativeApi$onUserCaptureScreen`)
    return as.onUserCaptureScreen(options)
  }

  hideKeyboardBridgeAsync(options: ESObject): void {
    wbLogger.debug('JsBridgeNative', `NativeApi$hideKeyboard`)
    return as.hideKeyboard(options)
  }

  makePhoneCallBridgeAsync(options: ESObject): void {
    wbLogger.debug('JsBridgeNative', `NativeApi$makePhoneCall`)
    return as.makePhoneCall({
      ...options,
      success: options.success,
      fail: options.fail
    })
  }
}

export const NativeApiImplInstance: NativeApiImpl = new NativeApiImpl()