import { ChooseLocationOptions, OpenLocationOptions } from '../location/location';

// 同层渲染
export interface SameLayerRender {
  transferSameLayerArgs: (options: object) => void,
}

// 位置模块
export interface NativeLocation {
  openLocation: (options: OpenLocationOptions) => void;
  chooseLocation:  (options: ChooseLocationOptions) => void;
  getLocation: Function,
  onLocationChange: Function,
  offLocationChange: Function,
  onLocationChangeError: Function,
  offLocationChangeError: Function,
  startLocationUpdate: Function,
  startLocationUpdateBackground: Function,
  stopLocationUpdate: Function,
}

// wifi模块
export interface NativeWifi {
  startWifi: Function;
  stopWifi: Function;
  connectWifi: Function;
  getConnectedWifi: Function;
  getWifiList: Function;
  onGetWifiList: Function;
  offGetWifiList: Function;
  onWifiConnected: Function;
  offWifiConnected: Function;
  onWifiConnectedWithPartialInfo: Function;
  offWifiConnectedWithPartialInfo: Function;
}

