import { NativeApiPair, NativeRegister } from '../NativeCacheManager';
import { common } from '@kit.AbilityKit';
import { NativeDataChangeListener } from '../../interfaces/InjectObject';

/**
 * 注册NativeApi方法"getWindowInfo"的监听
 */
class GetWindowInfoCache implements NativeRegister {
  private pair: NativeApiPair = {
    method: "getWindowInfo",
    args: []
  }
  private TAG = this.pair.method

  method: string;
  args: any[];
  updater: (context: common.UIAbilityContext | null, listener: NativeDataChangeListener | null) => void;

  constructor() {
    this.method = this.pair.method
    this.args = this.pair.args
    this.updater = (context: common.UIAbilityContext | null, listener: NativeDataChangeListener | null) => {
      // 无需更新数据
    }
  }
}

export const getWindowInfoCache = new GetWindowInfoCache()