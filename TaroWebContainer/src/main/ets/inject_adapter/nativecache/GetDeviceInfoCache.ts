import { NativeApiPair, NativeRegister } from '../NativeCacheManager';
import { common } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { taroLogger } from '../../utils/Logger';
import { NativeDataChangeListener } from '../../interfaces/InjectObject';

/**
 * 注册NativeApi方法"getDeviceInfo"的监听
 */
export class GetDeviceInfoCache implements NativeRegister {
  private pair: NativeApiPair = {
    method: "getDeviceInfo",
    args: []
  }
  private TAG = this.pair.method

  method: string;
  args: any[];
  updater: (context: common.UIAbilityContext | null, listener: () => NativeDataChangeListener | null) => void;

  constructor() {
    this.method = this.pair.method
    this.args = this.pair.args
    this.updater = (context: common.UIAbilityContext | null, listener: () => NativeDataChangeListener | null) => {
      try {
        window.getLastWindow(context).then((windowClass) => {
          // 屏幕的监听
          try {
            windowClass && windowClass.on('windowSizeChange', (data) => {
              taroLogger.debug(this.TAG, "windowScreenChange:" + JSON.stringify(data))
              listener()?.change(this.pair.method, this.pair.args)
            });
          } catch (exception) {
            taroLogger.debug(this.TAG, "windowScreenChange failed Cause:" + JSON.stringify(exception))
          }
        })
      } catch (e) {
        taroLogger.debug(this.TAG, `registerGetWindowInfo发生错误`)
      }
    }
  }
}
