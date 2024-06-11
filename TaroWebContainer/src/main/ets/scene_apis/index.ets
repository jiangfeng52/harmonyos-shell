import { sameLayerManager } from '../utils/SameLayerManager';
import { as } from '../utils/advancedapi.min';
import { openLocation, chooseLocation } from './location/location';
import { MethodChannel } from '../inject_adapter/Channel';
import { NativeLocation, NativeWifi, SameLayerRender } from './interface';

// 同层渲染
const sameLayerRender: SameLayerRender = {
  transferSameLayerArgs: sameLayerManager.transferSameLayerArgs,
}

// 位置模块
const nativeLocation: NativeLocation = {
  openLocation,
  chooseLocation,
  getLocation: as['getLocation'],
  onLocationChange: as['onLocationChange'],
  offLocationChange: as['offLocationChange'],
  onLocationChangeError: as['onLocationChangeError'],
  offLocationChangeError: as['offLocationChangeError'],
  startLocationUpdate: as['startLocationUpdate'],
  startLocationUpdateBackground: as['startLocationUpdateBackground'],
  stopLocationUpdate: as['stopLocationUpdate'],
}

// WiFi模块
const nativeWifi: NativeWifi = {
  startWifi: as['startWifi'],
  stopWifi: as['stopWifi'],
  connectWifi: as['connectWifi'],
  getConnectedWifi: as['getConnectedWifi'],
  getWifiList: as['getWifiList'],
  onGetWifiList: as['onGetWifiList'],
  offGetWifiList: as['offGetWifiList'],
  onWifiConnected: as['onWifiConnected'],
  offWifiConnected: as['offWifiConnected'],
  onWifiConnectedWithPartialInfo: as['onWifiConnectedWithPartialInfo'],
  offWifiConnectedWithPartialInfo: as['offWifiConnectedWithPartialInfo'],
}

export function registerSceneApis(methodChannel: MethodChannel) {
  methodChannel.registerMethods('SameLayerRender', sameLayerRender)
  methodChannel.registerMethods('NativeLocation', nativeLocation)
  methodChannel.registerMethods('NativeWifi', nativeWifi)
}