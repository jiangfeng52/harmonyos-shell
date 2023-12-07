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
    wbLogger.debug('JsBridgeNative', 'openSystemBluetoothSetting')
    const res = new Map<Object, Object>()
    res.set('data', '成功了')
    options?.success(res)
  }
}

interface MethodStub {
  target: object,
  fun: Function
}

class NativeApiStub {
  private nativeMethods = new Map<string, MethodStub>()

  // TODO-ly 改为装饰器实现
  registerNativeApi(callName: string, methodStub: MethodStub) {
    if(this.nativeMethods.has(callName)){
      return
    }
    this.nativeMethods.set(callName, methodStub)
  }
  onTransact(callName: string, argsJson: string, callbackId: number) {
    const methodStub = this.nativeMethods.get(callName)
    if (!methodStub) {
      return
    }
    // const jsProxy = new Proxy({}, {
    //
    // });
    //
    // const args = JSON.parse(argsJson)
    // methodStub.fun(methodStub.target, args)
  }
}

export const NativeApiStubInstance: NativeApiStub = new NativeApiStub()

const NativeApiImplInstance: NativeApiImpl = new NativeApiImpl()
// TODO-ly 改为装饰器实现
NativeApiStubInstance.registerNativeApi('openSystemBluetoothSetting', {target: NativeApiImplInstance, fun: NativeApiImplInstance.openSystemBluetoothSetting})