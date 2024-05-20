import { NativeApiPair, NativeRegister } from '../NativeCacheManager';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { geoLocationManager } from '@kit.LocationKit';
import { BusinessError, Callback } from '@kit.BasicServicesKit';
import { access, wifiManager } from '@kit.ConnectivityKit';
import { taroLogger } from '../../utils/Logger';
import { mediaquery } from '@kit.ArkUI';

/**
 * 注册NativeApi方法"getSystemSetting"的监听
 */
export class GetSystemSettingCache implements NativeRegister {

  private pair: NativeApiPair = {
    method: "getSystemSetting",
    args: []
  }
  private TAG = this.pair.method

  private locationEnabledChangeCallback: Callback<boolean>

  getApis(): NativeApiPair[] {
    return [this.pair]
  }

  updater(context: common.UIAbilityContext, onChange: (apiPairs: NativeApiPair[]) => void): void {
      try {
        // wifi状态的监听
        wifiManager.on("wifiStateChange", (result: number) => {
          //0: inactive, 1: active, 2: activating, 3: de-activating
          taroLogger.debug(this.TAG, "wifiStateChange:" + result)
          if (result === 1) {
            onChange([this.pair])
          } else if (result === 0) {
            onChange([this.pair])
          }
        });

        this.locationEnabledChangeCallback = (state: boolean): void => {
          taroLogger.debug(this.TAG, "locationEnabledChange:" + JSON.stringify(state))
          onChange([this.pair])
        }

        // 地理位置的系统开关监听
        geoLocationManager.on('locationEnabledChange', this.locationEnabledChangeCallback);

        // 横竖屏的监听
        mediaquery.matchMediaSync('(orientation: landscape)')
          .on("change", (mediaQueryResult: mediaquery.MediaQueryResult) => {
            let matches = mediaQueryResult.matches as boolean
            taroLogger.debug(this.TAG, "orientation: landscape:" + matches)
            onChange([this.pair])
          })

        // 蓝牙的监听
        let permissions: Array<Permissions> = ['ohos.permission.ACCESS_BLUETOOTH'];
        let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
        // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
        atManager.requestPermissionsFromUser(context, permissions).then((data) => {
          let grantStatus: Array<number> = data.authResults;
          let length: number = grantStatus.length;
          for (let i = 0; i < length; i++) {
            if (grantStatus[i] === 0) {
              // 用户授权，可以继续访问目标操作
              access.on('stateChange', (data: access.BluetoothState) => {
                taroLogger.debug(this.TAG, "bluetoothStateChange:" + JSON.stringify(data))
                if (data === access.BluetoothState.STATE_OFF) {
                  onChange([this.pair])
                } else if (data === access.BluetoothState.STATE_ON) {
                  onChange([this.pair])
                }
              });
            } else {
              // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
              return;
            }
          }
          // 授权成功
        }).catch((err: BusinessError) => {
          taroLogger.debug(this.TAG, `Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`)
        })
      } catch (e) {
        taroLogger.debug(this.TAG, `registerGetSystemSetting发生错误`)
      }
  }

  dispose(context: common.UIAbilityContext): void {
    // 地理位置的系统开关监听
    this.locationEnabledChangeCallback && geoLocationManager.off('locationEnabledChange', this.locationEnabledChangeCallback);
  }

}
