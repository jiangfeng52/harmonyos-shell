import { NativeApiPair, NativeRegister } from '../NativeCacheManager';
import { common } from '@kit.AbilityKit';
import { Size, window } from '@kit.ArkUI';
import { taroLogger } from '../../utils/Logger';
import { NativeDataChangeListener } from '../../interfaces/InjectObject';
import { Callback } from '@kit.BasicServicesKit';

/**
 * 注册NativeApi方法"getDeviceInfo"的监听
 */
export class GetDeviceInfoCache implements NativeRegister {
  private pair: NativeApiPair = {
    method: "getDeviceInfo",
    args: []
  }
  private TAG = this.pair.method

  private callback: Callback<Size>

  getMethod(): string {
    return this.pair.method
  }

  getArgs(): any[] {
    return this.pair.args
  }

  updater(context: common.UIAbilityContext, listener: () => NativeDataChangeListener | null): void {
    try {

      this.callback = (data) => {
        taroLogger.debug(this.TAG, "windowScreenChange:" + JSON.stringify(data))
        listener()?.change(this.pair.method, this.pair.args)
      }

      window.getLastWindow(context).then((windowClass) => {
        // 屏幕的监听
        try {
          windowClass && windowClass.on('windowSizeChange', this.callback);
        } catch (exception) {
          taroLogger.debug(this.TAG, "windowScreenChange failed Cause:" + JSON.stringify(exception))
        }
      })
    } catch (e) {
      taroLogger.debug(this.TAG, `registerGetWindowInfo发生错误`)
    }
  }

  dispose(context: common.UIAbilityContext): void {
    if (this.callback) {
      window.getLastWindow(context).then((windowClass) => {
        // 屏幕的监听
        try {
          windowClass && windowClass.off('windowSizeChange', this.callback);
        } catch (exception) {
          taroLogger.debug(this.TAG, "windowScreenChange failed Cause:" + JSON.stringify(exception))
        }
      })
    }
  }
}
