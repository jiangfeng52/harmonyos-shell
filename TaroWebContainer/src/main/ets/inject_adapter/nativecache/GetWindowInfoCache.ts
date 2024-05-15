import { NativeApiPair, NativeRegister } from '../NativeCacheManager';
import { common } from '@kit.AbilityKit';
import { NativeDataChangeListener } from '../../interfaces/InjectObject';

/**
 * 注册NativeApi方法"getWindowInfo"的监听
 */
export class GetWindowInfoCache implements NativeRegister {
  private pair: NativeApiPair = {
    method: "getWindowInfo",
    args: []
  }

  updater(context: common.UIAbilityContext, listener: () => NativeDataChangeListener | null): void {

  }

  getMethod(): string {
    return this.pair.method
  }

  getArgs(): any[] {
    return this.pair.args
  }

  dispose(context: common.UIAbilityContext): void {

  }
}
