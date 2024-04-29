import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { NativeDataChangeListener } from '../interfaces/InjectObject';
import { access, wifiManager } from '@kit.ConnectivityKit';
import { wbLogger } from '../utils/Logger';
import { NativeApiPair, nativeCacheManager } from './NativeCacheManager';
import { geoLocationManager } from '@kit.LocationKit';
import { mediaquery, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 注册NativeApi方法"getSystemSetting"的监听
 */
export function registerGetSystemSetting() {

  let TAG = "getSystemSetting"
  /** 蓝牙的系统开关 */
  let bluetoothEnabled: NativeApiPair = new NativeApiPair("getSystemSetting", [], "bluetoothEnabled")
  /** 地理位置的系统开关 */
  let locationEnabled: NativeApiPair = new NativeApiPair("getSystemSetting", [], "locationEnabled")
  /** Wi-Fi 的系统开关 */
  let wifiEnabled: NativeApiPair = new NativeApiPair("getSystemSetting", [], "wifiEnabled")
  /** 设备方向 */
  let deviceOrientation: NativeApiPair = new NativeApiPair("getSystemSetting", [], "deviceOrientation")

  nativeCacheManager.register({
    method: "getSystemSetting",
    args: [],
    updater: (context: common.UIAbilityContext | null, listener: NativeDataChangeListener | null) => {
      try {
        // wifi状态的监听
        wifiManager.on("wifiStateChange", (result: number) => {
          //0: inactive, 1: active, 2: activating, 3: de-activating
          wbLogger.debug(TAG, "wifiStateChange:" + result)
          if (result === 1) {
            nativeCacheManager.update(wifiEnabled, true)
          } else if (result === 0) {
            nativeCacheManager.update(wifiEnabled, false)
          }
        });

        // 地理位置的系统开关监听
        geoLocationManager.on('locationEnabledChange', (state: boolean): void => {
          wbLogger.debug(TAG, "locationEnabledChange:" + JSON.stringify(state))
          nativeCacheManager.update(locationEnabled, state)
        });

        // 横竖屏的监听
        mediaquery.matchMediaSync('(orientation: landscape)')
          .on("change", (mediaQueryResult: mediaquery.MediaQueryResult) => {
            let matches = mediaQueryResult.matches as boolean
            wbLogger.debug(TAG, "orientation: landscape:" + matches)
            nativeCacheManager.update(deviceOrientation, matches ? "landscape" : "portrait")
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
                wbLogger.debug(TAG, "bluetoothStateChange:" + JSON.stringify(data))
                if (data === access.BluetoothState.STATE_OFF) {
                  nativeCacheManager.update(bluetoothEnabled, false)
                } else if (data === access.BluetoothState.STATE_ON) {
                  nativeCacheManager.update(bluetoothEnabled, true)
                }
              });
            } else {
              // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
              return;
            }
          }
          // 授权成功
        }).catch((err: BusinessError) => {
          wbLogger.debug(TAG, `Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`)
        })
      } catch (e) {
        wbLogger.debug(TAG, `registerGetSystemSetting发生错误`)
      }
    }
  })
}

/**
 * 注册NativeApi方法"getWindowInfo"的监听
 */
export function registerGetWindowInfo() {
  let TAG = "getWindowInfo"
  /**  所有数据更新 */
  const allWindowInfo: NativeApiPair = new NativeApiPair("getWindowInfo", [])
  nativeCacheManager.register({
    method: "getWindowInfo",
    args: [],
    updater: (context: common.UIAbilityContext | null, cListener: NativeDataChangeListener | null) => {
      try {
        window.getLastWindow(context).then((windowClass) => {
          // 屏幕的监听
          try {
            windowClass && windowClass.on('windowSizeChange', (data) => {
              wbLogger.debug(TAG, "windowScreenChange:" + JSON.stringify(data))
              nativeCacheManager.update(allWindowInfo)
            });
          } catch (exception) {
            wbLogger.debug(TAG, "windowScreenChange failed Cause:" + JSON.stringify(exception))
          }
        })
      } catch (e) {
        wbLogger.debug(TAG, `registerGetWindowInfo发生错误`)
      }
    }
  })
}