// 位置模块
import { openLocation, chooseLocation, OpenLocationOptions, ChooseLocationOptions } from './location/location';

interface SceneApis {
  // 位置模块
  openLocation: (options: OpenLocationOptions) => void;
  chooseLocation:  (options: ChooseLocationOptions) => void;
}

export const sceneApis: SceneApis = {
  // 位置模块
  openLocation,
  chooseLocation
}