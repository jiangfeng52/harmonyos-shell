import { NativeDataChangeListener } from '../interfaces/InjectObject';
import { common } from '@kit.AbilityKit';
import { wifiManager } from '@kit.ConnectivityKit';
import { wbLogger } from '../utils/Logger';

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
  /** getWindowInfo - 所有数据更新 */
  public static allWindowInfo: NativeApiPair = new NativeApiPair("getWindowInfo", [])
}

export interface NativeRegister {
  /*方法名*/
  method: string;
  /*方法入参*/
  args: any[];
  /*更新的方法*/
  updater: (context: common.UIAbilityContext | null, listener: NativeDataChangeListener | null) => void;
}

class NativeDataUpdater {
  private _listener: NativeDataChangeListener | null = null;
  private _registers: NativeRegister[] = []
  private _context: common.UIAbilityContext | null = null;

  public init(context:common.UIAbilityContext){
    this._context = context
  }

  public registerListener(listener: NativeDataChangeListener | null) {
    this._listener = listener
    this.registerTaro()
  }

  private registerTaro(){
    // 方法名全部要注册
    this._registers.forEach((re)=>{
      this._listener?.register(re.method)
    })
  }

  public register(r: NativeRegister) {
    this._registers.push(r)
    r.updater(this._context,this._listener)
    this._listener?.register(r.method)
  }

  public unregister(r:NativeRegister){
    const index = this._registers.indexOf(r)
    if (index > -1) {
      this._registers.splice(index, 1)
      this._listener?.unregister(r.method)
    }
  }

  public registerSystemInfo(){
    this.register({
      method:"getSystemSetting",
      args:[],
      updater:(context:common.UIAbilityContext|null,cListener: NativeDataChangeListener | null)=>{
        // wifi状态的监听
        wifiManager.on("wifiStateChange", (result: number) => {
          //0: inactive, 1: active, 2: activating, 3: de-activating
          wbLogger.debug("WIFI改变", "wifiStateChange:" + result)
          if (result === 1) {
            this.update(NativeDataType.wifiEnabled, true)
          } else if (result === 0) {
            this.update(NativeDataType.wifiEnabled, false)
          }
        });
      }
    })
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

