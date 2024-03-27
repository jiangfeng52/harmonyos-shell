import { LocalNativeChangeListener } from '../interfaces/InjectObject';

class Pair {
  public method: string;
  public field: string;

  constructor(method: string, field: string) {
    this.method = method;
    this.field = field;
  }
}

export class NativeApiChangeType {
  public static bluetoothEnabled: Pair = new Pair("getSystemSetting", "bluetoothEnabled")
  public static locationEnabled: Pair = new Pair("getSystemSetting", "locationEnabled")
  public static wifiEnabled: Pair = new Pair("getSystemSetting", "wifiEnabled")
  public static deviceOrientation: Pair = new Pair("getSystemSetting", "deviceOrientation")
}


class HybridNativeDataChanger {
  private _listener: LocalNativeChangeListener | null = null;

  // public getListener(): LocalNativeChangeListener | null {
  //   return this._listener;
  // }

  public setListener(listener: LocalNativeChangeListener | null) {
    this._listener = listener
  }

  /**
   * 通过执行该方法，调用了listener的change方法->taro层接收到回调->taro重新请求最新数据。
   * @param p
   */
  public change(p: Pair) {
    // TODO  目前更新的颗粒度为方法级别。待开发：精确到方法内的某个数据，比如getSystemSetting中的蓝牙变更、定位变更等更细颗粒度的更新。
    this._listener?.change(p.method)
  }
}

export const NativeChanger = new HybridNativeDataChanger()

