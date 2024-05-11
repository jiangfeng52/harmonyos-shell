import { MapComponent, map, mapCommon } from '@kit.MapKit';
import { AsyncCallback, BusinessError, ErrorCallback } from '@kit.BasicServicesKit';
import { sameLayerManager } from '../../../../utils/SameLayerManager';
import { MapParams } from '../../Interfaces/SameLayer';
import { wbLogger } from '../../../../utils/Logger';
import { mapContextMap, mapControllerMap} from '../../../../utils/MapManager';

// 地图的默认中心点为北京天安门
const defaultLatitude = 39.909195;
const defaultLongitude = 116.397446;

// 地图的默认缩放级别和Taro保持一致
const defaultZoom = 16;

// 地图的默认最小和最大缩放级别和Taro保持一致
const defaultMinZoom = 3;
const defaultMaxZoom = 20;

// 地图的默认手势开关和Taro保持一致
const defaultZoomGesturesEnabled = true;
const defaultScrollGesturesEnabled = true;
const defaultRotateGesturesEnabled = false;

// 地图是否显示指南针和Taro保持一致
const defaultCompassControlsEnabled = false;

// 地图是否显示比例尺和Taro保持一致
const defaultScaleControlsEnabled = false;

// 地图默认的倾斜角度和Taro保持一致
const defaultTilt = 0;

// 地图默认的旋转角度和Taro保持一致
const defaultBearing = 0;

// 地图默认是否开启实时路况和Taro保持一致
const defaultTrafficEnabled = false;

// 地图默认是否显示当前位置和Taro保持一致
const defaultMyLocationEnabled = false;

const TAG = "sameLayerRender][NativeMap";

@Component
struct NativeMap {
  @ObjectLink params: MapParams;
  private callback?: AsyncCallback<map.MapComponentController>;
  private mapOption?: mapCommon.MapOptions;
  private eventList: Array<string> = [];

  aboutToAppear(): void {
    wbLogger.info(TAG, 'aboutToApper')
    // 地图初始化参数
    this.mapOption = {
      position: {
        target: {
          latitude: this.params.latitude ?? defaultLatitude,
          longitude: this.params.longitude ?? defaultLongitude
        },
        zoom: this.params.zoom ?? defaultZoom,
        tilt: this.params.tilt ?? defaultTilt,
        bearing: this.params.bearing ?? defaultBearing,
      },
      minZoom: this.params.minZoom ?? defaultMinZoom,
      maxZoom: this.params.maxZoom ?? defaultMaxZoom,
      zoomGesturesEnabled: this.params.zoomGesturesEnabled ?? defaultZoomGesturesEnabled,
      scrollGesturesEnabled: this.params.scrollGesturesEnabled ?? defaultScrollGesturesEnabled,
      rotateGesturesEnabled: this.params.rotateGesturesEnabled ?? defaultRotateGesturesEnabled,
      compassControlsEnabled: this.params.compassControlsEnabled ?? defaultCompassControlsEnabled,
      scaleControlsEnabled: this.params.scaleControlsEnabled ?? defaultScaleControlsEnabled,
    }

    this.callback = async (err, mapController) => {
      if (!err) {
        // 设置地图的控制器类，用来操作地图
        mapController.setTrafficEnabled(this.params.setTrafficEnabled ?? defaultTrafficEnabled);
        mapController.setMyLocationEnabled(this.params.setMyLocationEnabled ?? defaultMyLocationEnabled);
        mapController.setMyLocationControlsEnabled(this.params.setMyLocationEnabled ?? defaultMyLocationEnabled);
        // 获取监听事件函数，并注册监听事件
        const args = sameLayerManager.getSameLayerArgs(this.params.componentId);
        if (args) {
          Object.keys(args).forEach(key => {
            if (typeof args[key] === 'function' && key.startsWith('on')) {
              let eventName: string = key.replace(/^on/, '');
              eventName = eventName.charAt(0).toLowerCase() + eventName.slice(1);
              this.eventList.push(eventName);
              mapController.on(eventName as ESObject, (e) => {
                wbLogger.info(TAG, `${event} event is triggered`);
                args[key](e);
              })
            }
          })
        }
        // 设置mapController实例，用于Map控制
        mapControllerMap.set(this.params.componentId, mapController);
      }
    };
  }

  aboutToDisappear(): void {
    wbLogger.info(TAG, 'aboutToDisappear');
    const mapController = mapControllerMap.get(this.params.componentId);
    // 移除注册了的事件
    this.eventList.forEach((eventName: string) => {
      mapController?.off(eventName as ESObject, () => {});
    })
    // 清理mapController实例
    mapControllerMap.delete(this.params.componentId);
    // 清理MapContext实例
    mapContextMap.delete(this.params.componentId);
  }

  build() {
    Column() {
      MapComponent({ mapOptions: this.mapOption, mapCallback: this.callback })
        .width(this.params.width)
        .height(this.params.height)
    }
  }
}

@Builder
export function NativeMapBuilder(params: MapParams) {
  NativeMap({ params: params })
    .backgroundColor(Color.White)
}