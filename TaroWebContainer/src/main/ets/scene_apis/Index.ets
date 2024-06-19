import { sameLayerManager } from '../utils/SameLayerManager';
import { as } from '../utils/advancedapi.min';
import { openLocation, chooseLocation } from './location/Location';
import { MethodChannel } from '../inject_adapter/Channel';
import { previewImage } from './media/image/Image';
import { NativeImage, NativeLocation, NativeMemory, NativeWifi, SameLayerRender } from './interface/Index';
import { offMemoryWarning, onMemoryWarning } from './device/memory/Memory';

// 设备-内存模块
const nativeMemory: NativeMemory = {
  onMemoryWarning,
  offMemoryWarning
}

// 媒体-图片模块
const nativeImage: NativeImage = {
  previewImage,
}

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
  methodChannel.registerMethods('NativeImage', nativeImage)
  methodChannel.registerMethods('SameLayerRender', sameLayerRender)
  methodChannel.registerMethods('NativeLocation', nativeLocation)
  methodChannel.registerMethods('NativeWifi', nativeWifi)
  methodChannel.registerMethods('NativeMemory', nativeMemory)
}