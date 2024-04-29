import { NativeDataChangeListener } from '../interfaces/InjectObject';
import { common } from '@kit.AbilityKit';

class NativeCacheManager {
  private _listener: NativeDataChangeListener | null = null;
  private _registers: NativeRegister[] = []
  private _context: common.UIAbilityContext | null = null;

  public init(context: common.UIAbilityContext) {
    this._context = context
  }

  public registerNativeListener(listener: NativeDataChangeListener | null) {
    this._listener = listener
    // 方法名全部要注册
    this._registers.forEach((re) => this._listener?.register(re.method))
  }

  public register(r: NativeRegister) {
    const index = this._registers.indexOf(r)
    if (index === -1) {
      this._registers.push(r)
      r.updater(this._context, this._listener)
      this._listener?.register(r.method)
    }
  }

  public unregister(r: NativeRegister) {
    const index = this._registers.indexOf(r)
    if (index > -1) {
      this._registers.splice(index, 1)
      this._listener?.unregister(r.method)
    }
  }

  /**
   * 通过执行该方法，调用了listener的change方法->taro层接收到回调->taro重新请求最新数据。
   *
   * @param p
   */
  public update(p: NativeApiPair) {
    this._listener?.change(p.method, p.args)
  }
}

export const nativeCacheManager = new NativeCacheManager()

export interface NativeApiPair {
  /*方法名*/
  method: string;

  /*方法入参*/
  args: any[];
}

export interface NativeRegister {
  /*方法名*/
  method: string;

  /*方法入参*/
  args: any[];

  /*更新的方法*/
  updater: (context: common.UIAbilityContext | null, listener: NativeDataChangeListener | null) => void;
}