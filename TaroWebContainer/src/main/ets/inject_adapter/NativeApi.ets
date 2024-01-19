import { wbLogger } from '../utils/Logger'
import { as } from '@ohos/advanced-api';

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

interface NativeApi {

  /**
   * 类型1：同步调用
   *
   * @returns 返回值对象里无方法
   */
  getWindowInfoBridgeSync(): WindowInfo

  /**
   * 类型2：异步调用，res无方法
   * 打开系统蓝牙设置
   *
   * @param options
   */
  openSystemBluetoothSettingBridgeAsync(options: OpenSystemBluetoothSetting)

  /**
   * 类型3：持续监听，res无方法
   *
   * @param listener
   */
  onWindowResizeBridgeAsync(listener: (res: WindowResizeResult) => void)
}

class NativeApiImpl implements NativeApi {
  getWindowInfoBridgeSync(): WindowInfo {
    return {
      pixelRatio: 1,
      screenWidth: 480,
      screenHeight: 720,
    }
  }

  openSystemBluetoothSettingBridgeAsync(options: OpenSystemBluetoothSetting) {
    wbLogger.debug('JsBridgeNative', `openSystemBluetoothSetting， options.success=${options.success}`)
    options && options.success && options.success('has opened')
  }

  onWindowResizeBridgeAsync(listener: (res: WindowResizeResult) => void) {
    listener({
      size: {
        windowWidth: 340,
        windowHeight: 720
      }
    })

    setTimeout(() => {
      listener({
        size: {
          windowWidth: 720,
          windowHeight: 1280
        }
      })
    }, 1000)
  }
}

export const NativeApiImplInstance: NativeApiImpl = new NativeApiImpl()

export const NativeApiUpdate: ESObject = {
  getWindowInfoBridgeSync: as['getWindowInfo'],
  getSystemSettingBridgeSync: as['getSystemSetting'],
  makePhoneCallBridgeAsync: (options: ESObject) => {
    as.makePhoneCall(options)
  },
  onUserCaptureScreenBridgeAsync: (options: ESObject) => {
    as.onUserCaptureScreen(options)
  }
}

