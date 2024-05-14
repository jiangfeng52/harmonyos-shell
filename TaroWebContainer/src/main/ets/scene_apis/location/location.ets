import { sceneMap } from '@kit.MapKit';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { taroLogger } from '../../utils/Logger';

const TAG: string = 'LOCATION'

export interface OpenLocationOptions {
  latitude: number;
  longitude: number;
  address: string | undefined;
  name: string | undefined;
  success: Function;
  fail: Function;
}

export interface ChooseLocationOptions {
  latitude: number | undefined;
  longitude: number | undefined;
  success: Function;
  fail: Function;
}

export function openLocation(options: OpenLocationOptions) {
  const context = getContext() as common.UIAbilityContext;
  const openLocationOptions: sceneMap.LocationQueryOptions = {
    location: {
      latitude: options.latitude,
      longitude: options.longitude
    },
    name: options.name,
    address: options.address
  }
  try {
    sceneMap.queryLocation(context, openLocationOptions).then(() => {
      taroLogger.info(TAG, "Query location success.");
      options.success()
    }).catch((err: BusinessError) => {
      taroLogger.error(TAG, `Failed to query Location, code: ${err.code}, message: ${err.message}`);
      options.fail(err)
    });
  } catch (e) {
    taroLogger.error(TAG, `Failed to query Location, message: ${e.message}`);
    options.fail(e)
  }
}

export function chooseLocation(options: ChooseLocationOptions) {
  const context = getContext() as common.UIAbilityContext;
  let chooseLocationOptions: sceneMap.LocationChoosingOptions;
  if (options.latitude && options.longitude) {
    chooseLocationOptions = {
      location: {
        latitude: options.latitude,
        longitude: options.longitude
      },
      searchEnabled: true,
      showNearbyPoi: true
    }
  } else {
    chooseLocationOptions = {
      searchEnabled: true,
      showNearbyPoi: true
    }
  }
  try {
    sceneMap.chooseLocation(context, chooseLocationOptions).then((data) => {
      taroLogger.info(TAG, "Choose location success:" + JSON.stringify(data));
      options.success(data);
    }).catch((err: BusinessError) => {
      taroLogger.error(TAG, `Failed to choose Location, code: ${err.code}, message: ${err.message}`);
      options.fail(err);
    });
  } catch (e) {
    taroLogger.error(TAG, `Failed to choose Location, message: ${e.message}`);
    options.fail(e);
  }
}