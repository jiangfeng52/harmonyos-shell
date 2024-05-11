import { map, mapCommon } from '@kit.MapKit';
import { wbLogger } from './Logger';

const TAG = "SameLayerRender";

export const mapControllerMap: Map<string, map.MapComponentController> = new Map();
export const mapContextMap: Map<string, MapContext> = new Map();

export function callMapContextFunction(options: ESObject, callParam: CallMapParam): ESObject {
  const instance: object | undefined = mapContextMap.get(callParam.instanceId) as object | undefined
  if (!instance) {
    wbLogger.error(TAG, 'the native MapContext instance has not been create.')
    return
  }
  if (callParam.callType === 'exec') {
    instance[callParam.funcName].call(instance, options)
  } else if (callParam.callType === 'get') {
    return instance[callParam.funcName].call(instance, options)
  } else if (callParam.callType === 'set') {
    instance[callParam.funcName] = options
  } else {
    wbLogger.error(TAG, `Invalid call parameter, callType: ${callParam.callType}.`)
    return
  }
}

export function createMapContext(mapId: string): string {
  if (mapControllerMap.get(mapId)) {
    if (!mapControllerMap.has(mapId)) {
      mapContextMap.set(mapId, new MapContext(mapId));
    }
    return mapId;
  } else {
    return 'undefined';
  }
}

class MapContext {
  private mapController: map.MapComponentController;

  constructor(mapId: string) {
    this.mapController = mapControllerMap.get(mapId)!;
  }

  setDayNightMode(mode: number) {
    try {
      this.mapController.setDayNightMode(mode);
      wbLogger.info(TAG, `setDayNightMode ok: set mode to ${mode}`);
    } catch (e) {
      wbLogger.error(TAG, `setDayNightMode err: ${JSON.stringify(e)}`);
    }
  }

  getCenterLocation() {
    try {
      const cameraPosition: mapCommon.CameraPosition = this.mapController.getCameraPosition();
      wbLogger.info(TAG, `getCenterLocation ok: ${JSON.stringify(cameraPosition.target)}}`);
      return cameraPosition.target;
    } catch (e) {
      const result = JSON.stringify({ errMsg: e })
      wbLogger.error(TAG, `getCenterLocation err: ${result}`);
      return result;
    }
  }

  moveToLocation(options: mapCommon.LatLng) {
    try {
      const latLng: mapCommon.LatLng = {
        latitude: options.latitude,
        longitude: options.longitude
      };
      const cameraUpdate: map.CameraUpdate = map.newLatLng(latLng);
      this.mapController.moveCamera(cameraUpdate);
      wbLogger.info(TAG, `moveToLocation ok: move to ${JSON.stringify(latLng)}`);
      return true;
    } catch (e) {
      const result = JSON.stringify({ errMsg: e })
      wbLogger.error(TAG, `moveToLocation err: ${result}`);
      return result;
    }
  }
}

interface CallMapParam {
  instanceId: string
  callType: string  // set get exec
  funcName: string
}