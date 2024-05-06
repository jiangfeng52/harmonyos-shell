import { NativeApiPair, nativeCacheManager, NativeRegister } from '../NativeCacheManager';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { access, wifiManager } from '@kit.ConnectivityKit';
import { wbLogger } from '../../utils/Logger';
import { geoLocationManager } from '@kit.LocationKit';
import { mediaquery } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { NativeDataChangeListener } from '../../interfaces/InjectObject';

/**
 * 注册NativeApi方法"getSystemSetting"的监听
 */
class GetSystemSettingCache implements NativeRegister {
  private pair: NativeApiPair = {
    method: "getSystemSetting",
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
      try {
        // wifi状态的监听
        wifiManager.on("wifiStateChange", (result: number) => {
          //0: inactive, 1: active, 2: activating, 3: de-activating
          wbLogger.debug(this.TAG, "wifiStateChange:" + result)
          if (result === 1) {
            nativeCacheManager.update(this.pair)
          } else if (result === 0) {
            nativeCacheManager.update(this.pair)
          }
        });

        // 地理位置的系统开关监听
        geoLocationManager.on('locationEnabledChange', (state: boolean): void => {
          wbLogger.debug(this.TAG, "locationEnabledChange:" + JSON.stringify(state))
          nativeCacheManager.update(this.pair)
        });

        // 横竖屏的监听
        mediaquery.matchMediaSync('(orientation: landscape)')
          .on("change", (mediaQueryResult: mediaquery.MediaQueryResult) => {
            let matches = mediaQueryResult.matches as boolean
            wbLogger.debug(this.TAG, "orientation: landscape:" + matches)
            nativeCacheManager.update(this.pair)
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
                wbLogger.debug(this.TAG, "bluetoothStateChange:" + JSON.stringify(data))
                if (data === access.BluetoothState.STATE_OFF) {
                  nativeCacheManager.update(this.pair)
                } else if (data === access.BluetoothState.STATE_ON) {
                  nativeCacheManager.update(this.pair)
                }
              });
            } else {
              // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
              return;
            }
          }
          // 授权成功
        }).catch((err: BusinessError) => {
          wbLogger.debug(this.TAG, `Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`)
        })
      } catch (e) {
        wbLogger.debug(this.TAG, `registerGetSystemSetting发生错误`)
      }
    }
  }
}

export const getSystemSettingCache = new GetSystemSettingCache()