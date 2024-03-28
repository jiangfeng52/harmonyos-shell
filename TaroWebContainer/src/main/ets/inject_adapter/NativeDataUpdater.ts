import { NativeDataChangeListener } from '../interfaces/InjectObject';

export class NativeApiPair {
  /*方法名*/
  public method: string;
  /*方法入参*/
  public args: any[];
  /*返回数据的字段*/
  public field?: string;

  constructor(method: string, args: any[], field?: string) {
    this.method = method;
    this.args = args
    this.field = field;
  }
}

export class NativeDataType {
  /** getSystemSetting - 所有数据更新 */
  public static allSystemSetting: NativeApiPair = new NativeApiPair("getSystemSetting", [])
  /** getSystemSetting - 蓝牙的系统开关 */
  public static bluetoothEnabled: NativeApiPair = new NativeApiPair("getSystemSetting", [], "bluetoothEnabled")
  /** getSystemSetting - 地理位置的系统开关 */
  public static locationEnabled: NativeApiPair = new NativeApiPair("getSystemSetting", [], "locationEnabled")
  /** getSystemSetting - Wi-Fi 的系统开关 */
  public static wifiEnabled: NativeApiPair = new NativeApiPair("getSystemSetting", [], "wifiEnabled")
  /** getSystemSetting - 设备方向 */
  public static deviceOrientation: NativeApiPair = new NativeApiPair("getSystemSetting", [], "deviceOrientation")
}


class NativeDataUpdater {
  private _listener: NativeDataChangeListener | null = null;

  public getListener(): NativeDataChangeListener | null {
    return this._listener;
  }

  public setListener(listener: NativeDataChangeListener | null) {
    this._listener = listener
  }

  /**
   * 通过执行该方法，调用了listener的change方法->taro层接收到回调->taro重新请求最新数据。
   * @param p 更新的数据类型
   * @param v 要更新的值，可选。如不传，则整个方法中的数据执行更新
   */
  public update(p: NativeApiPair, v?: any) {
    if (p.field && v != undefined) {
      // 颗粒度更低的字段级更新。
      this._listener?.change(p.method, p.args, (old) => {
        if (old !== undefined && p.field && p.field in old) {
          old[p.field] = v
        }
        return old
      })
    } else {
      this._listener?.change(p.method, p.args)
    }
  }
}

export const nativeUpdater = new NativeDataUpdater()

