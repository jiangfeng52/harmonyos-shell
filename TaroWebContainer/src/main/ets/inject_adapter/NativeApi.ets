import { wbLogger } from '../utils/Logger'
import { MethodChannelInstance } from './Channel'

interface WindowInfo {
  pixelRatio?: number,
  screenWidth?: number,
  screenHeight?: number
}



interface OpenSystemBluetoothSetting {
  success?: (res: string)=>void,
  fail?:(res: string)=>void,
  complete?:(res: string)=>void
}

interface NativeApi {

  /**
   * 类型1：同步调用
   *
   * @returns 返回值对象里无方法
   */
  getWindowInfo(): WindowInfo

  /**
   * 类型2：异步调用，res无方法
   * 打开系统蓝牙设置
   *
   * @param options
   */
  openSystemBluetoothSetting(options: OpenSystemBluetoothSetting)
}

class NativeApiImpl implements NativeApi {
  getWindowInfo(): WindowInfo {
    return {
      pixelRatio: 1,
      screenWidth: 480,
      screenHeight: 720,
    }
  }

  openSystemBluetoothSetting(options: OpenSystemBluetoothSetting) {
    wbLogger.debug('JsBridgeNative', `openSystemBluetoothSetting， options.success=${options.success}`)
    options && options.success && options.success('has opened')
  }
}

export const NativeApiImplInstance: NativeApiImpl = new NativeApiImpl()