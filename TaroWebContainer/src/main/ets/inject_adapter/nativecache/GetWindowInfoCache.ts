import { NativeApiPair, NativeRegister } from '../NativeCacheManager';
import { common } from '@kit.AbilityKit';

/**
 * 注册NativeApi方法"getWindowInfo"的监听
 */
export class GetWindowInfoCache implements NativeRegister {

  private pair: NativeApiPair = {
    method: "getWindowInfo",
    args: []
  }

  getApis(): NativeApiPair[] {
    return [this.pair]
  }

  updater(context: common.UIAbilityContext, onChange: (apiPairs: NativeApiPair[]) => void): void {

  }

  dispose(context: common.UIAbilityContext): void {

  }
}
