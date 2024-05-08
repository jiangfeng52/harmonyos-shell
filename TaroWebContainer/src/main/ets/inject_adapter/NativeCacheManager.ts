import { NativeDataChangeListener } from '../interfaces/InjectObject';
import { common } from '@kit.AbilityKit';

export class NativeCacheManager {
  private _listener: NativeDataChangeListener | null = null;
  private _registers: NativeRegister[] = []
  private _context: common.UIAbilityContext | null = null;

  public init(context: common.UIAbilityContext) {
    this._context = context
  }

  public registerNativeListener(listener: NativeDataChangeListener | null) {
    this._listener = listener
    // 方法名全部要注册
    this._listener?.register(this._registers.map(r => r.method))
  }

  public register(rList: NativeRegister[]) {
    let rNameList = new Set<string>()
    rList.forEach(r => {
      const index = this._registers.indexOf(r)
      // 不存在
      if (index === -1) {
        this._registers.push(r)
        r.updater(this._context, () => this._listener)
        rNameList.add(r.method)
      }
    })
    // taro注册
    this._listener?.register(Array.from(rNameList))
  }

  public unregister(rList: NativeRegister[]) {
    let rNameList = new Set<string>()
    rList.forEach(r => {
      const index = this._registers.indexOf(r)
      // 存在
      if (index > -1) {
        this._registers.splice(index, 1)
        rNameList.add(r.method)
      }
    })
    // taro解注册
    this._listener?.unregister(Array.from(rNameList))

  }

  public unregisterAll() {
    this.unregister(this._registers)
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
  updater: (context: common.UIAbilityContext | null, listener: () => NativeDataChangeListener | null) => void;
}