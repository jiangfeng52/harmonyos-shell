import { wbLogger } from '../utils/Logger'

interface OpenSystemBluetoothSetting {
  success?: (res: object)=>void,
  fail?:(res: object)=>void,
  complete?:(res: object)=>void
}

interface NativeApi {
  /**
   * 打开系统蓝牙设置
   *
   * @param options
   */
  openSystemBluetoothSetting(options: OpenSystemBluetoothSetting)
}

class NativeApiImpl implements NativeApi {
  openSystemBluetoothSetting(options: OpenSystemBluetoothSetting) {
    wbLogger.debug('JsBridgeNative', `openSystemBluetoothSetting， options.success=${options.success}`)
    const res = new Map<Object, Object>()
    res.set('data', '成功了')
    options && options.success && options.success(res)
  }
}

export const NativeApiImplInstance: NativeApiImpl = new NativeApiImpl()