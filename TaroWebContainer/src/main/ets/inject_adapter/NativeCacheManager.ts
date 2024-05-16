import { NativeDataChangeListener } from '../interfaces/InjectObject';
import { common } from '@kit.AbilityKit';

export class NativeCacheManager {
  private _listeners: NativeDataChangeListener[] = [];
  private _registers: NativeRegister[] = []
  private _context: common.UIAbilityContext | null = null;

  /**
   * 尚未执行updater方法的NativeRegister集合
   */
  private _unUpdaterRegisters: NativeRegister[] = []

  public initCacheData(context: common.UIAbilityContext) {
    this._context = context
    this.updateCacheData()
  }

  public registerNativeListener(listener: NativeDataChangeListener | null) {
    this._listeners.push(listener)
    this.taroRegister(this._registers)
  }

  public register(...rList: NativeRegister[]) {
    this._unUpdaterRegisters.push(...rList)
    this.updateCacheData()
    this.taroRegister(rList)
  }

  public unregister(...rList: NativeRegister[]) {
    let rNameList = new Set<string>()
    rList.forEach(r => {
      const index = this._registers.indexOf(r)
      // 存在
      if (index > -1) {
        this._registers.splice(index, 1)
        r.getApis().forEach((api) => rNameList.add(api.method))
      }
      r.dispose(this._context)
    })
    // taro解注册
    this._listeners.forEach(listener => listener.unregister(Array.from(rNameList)))
  }

  public dispose() {
    this.unregister(...this._registers)
    this._listeners = []
    this._registers = []
    this._context = null
  }

  private taroRegister(rList: NativeRegister[]) {
    // taro注册
    let methodNames: string[] = []
    rList.forEach(r => {
      r.getApis().forEach(api => methodNames.push(api.method))
    })
    // 实际测试多次调用register方法时前端只能收到第一次调用
    this._listeners.forEach(listener => listener.register(methodNames))
  }

  private updateCacheData() {
    if (!this._context) {
      return
    }
    if (this._unUpdaterRegisters.length === 0) {
      return
    }
    this._unUpdaterRegisters.forEach(r => {
      this._registers.indexOf(r) === -1 && this._registers.push(r)
      r.updater(this._context, (apiPairs) => {
        apiPairs.forEach(api => {
          this._listeners.forEach(listener => listener.change(api.method, api.args))
        })
      })
    })
    this._unUpdaterRegisters.splice(0)
  }

}

export interface NativeApiPair {
  /*方法名*/
  method: string;

  /*方法入参*/
  args: object[];
}

export interface NativeRegister {
  /**
   * 支持的api集合
   * @returns
   */
  getApis(): NativeApiPair[];

  /**
   * 更新的方法
   * @param context
   * @param onChange 缓存数据发生变化时调用的方法
   */
  updater(context: common.UIAbilityContext, onChange: (apiPairs: NativeApiPair[]) => void): void;

  /**
   * 释放资源方法
   * @param context
   */
  dispose(context: common.UIAbilityContext): void
}