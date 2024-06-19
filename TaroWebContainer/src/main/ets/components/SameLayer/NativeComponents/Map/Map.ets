import { MapComponent, map, mapCommon } from '@kit.MapKit';
import { AsyncCallback, BusinessError } from '@kit.BasicServicesKit';
import { sameLayerManager } from '../../../../utils/SameLayerManager';
import { MapParams } from '../../Interfaces/SameLayer';
import { taroLogger } from '../../../../utils/Logger';
import { mapContextMap, mapControllerMap } from '../../../../utils/MapManager';
import { image } from '@kit.ImageKit';
import { Size } from '@kit.ArkUI';
import { http } from '@kit.NetworkKit';

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
  private mapController?: map.MapComponentController;
  private callback?: AsyncCallback<map.MapComponentController>;
  private mapOption?: mapCommon.MapOptions;
  private eventList: string[] = [];
  private iconHandleCache: Map<string, Promise<string | image.PixelMap | undefined>> = new Map(); // 使用缓存机制避免多个相同marker图标重复处理

  iconHandler(iconPath: string, width?: number, height?: number): Promise<string | image.PixelMap | undefined> {
    return new Promise(async (resolve) => {
      if (iconPath.startsWith('http://') || iconPath.startsWith('https://')) {
        try {
          let httpRequest = http.createHttp();
          httpRequest.request(iconPath, {
            method: http.RequestMethod.GET,
            expectDataType: http.HttpDataType.ARRAY_BUFFER
          }).then(async (data: http.HttpResponse) => {
            const result = data.result;
            httpRequest.destroy();
            if (result && result instanceof ArrayBuffer) {
              const imageSource: image.ImageSource = image.createImageSource(result);
              // 获取原始图片宽高信息
              const originalImgSize: Size = (await imageSource.getImageInfo()).size;
              // 设置解码参数DecodingOptions
              const decodingOptions: image.DecodingOptions = {
                editable: true,
                desiredPixelFormat: 3,
                // 设置图片输出的大小，若有传入宽度则使用传入宽度，否则使用原始图片宽度，高度同理。
                desiredSize: { width: width || originalImgSize.width, height: height || originalImgSize.height }
              }
              // 解码获取pixelMap图片对象
              imageSource.createPixelMap(decodingOptions).then((pixelMap: image.PixelMap) => {
                // API12支持传入pixelMap
                resolve(pixelMap);
              });
            } else {
              taroLogger.error(TAG, 'icon get fail');
              resolve(undefined);
            }
          }).catch((err: BusinessError) => {
            httpRequest.destroy();
            taroLogger.error(TAG, `icon get fail ${JSON.stringify(err)}`);
            resolve(undefined);
          })
        } catch (e) {
          // 图片处理过程异常
          taroLogger.error(TAG, `icon handle fail, error: ${e}`);
          resolve(undefined);
        }
      } else {
        // base64字符串图片（已支持,但无法设置宽高）及其它入参直接返回由Map处理，若支持则会正常显示，若不支持则会默认使用系统marker。
        taroLogger.warn(TAG, 'The current icon path may not be supported.');
        resolve(iconPath);
      }
    })
  }

  aboutToAppear(): void {
    taroLogger.info(TAG, 'aboutToApper')
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
        this.mapController = mapController;
        // 设置地图的控制器类，用来操作地图
        this.mapController.setTrafficEnabled(this.params.setTrafficEnabled ?? defaultTrafficEnabled);
        this.mapController.setMyLocationEnabled(this.params.setMyLocationEnabled ?? defaultMyLocationEnabled);
        this.mapController.setMyLocationControlsEnabled(this.params.setMyLocationEnabled ?? defaultMyLocationEnabled);
        // 获取监听事件函数，并注册监听事件
        const args = sameLayerManager.getSameLayerArgs(this.params.componentId);
        if (args) {
          Object.keys(args).forEach(key => {
            if (typeof args[key] === 'function' && key.startsWith('on')) {
              let eventName: string = key.replace(/^on/, '');
              eventName = eventName.charAt(0).toLowerCase() + eventName.slice(1);
              this.eventList.push(eventName);
              this.mapController?.on(eventName as ESObject, (e) => {
                taroLogger.info(TAG, `${eventName} event is triggered`);
                args[key](e);
              })
            }
          })
        }

        this.params.markers?.forEach(async (marker) => {
          let icon: string | image.PixelMap | undefined;
          // 将web侧传递的marker图标参数转为原生支持的类型
          if (marker.iconPath) {
            // 检查icon是否已经在处理缓存中
            if (this.iconHandleCache.has(marker.iconPath)) {
              // 如果已经在缓存中，则等待之前的Promise完成
              icon = await this.iconHandleCache.get(marker.iconPath);
            } else {
              // 如果不在缓存中，则进行异步处理并添加到缓存中
              const iconHandlePromise = this.iconHandler(marker.iconPath, marker.width, marker.height);
              this.iconHandleCache.set(marker.iconPath, iconHandlePromise);
              icon = await iconHandlePromise;
            }
          }
          // Marker初始化参数
          const markerOptions: mapCommon.MarkerOptions = {
            position: {
              latitude: marker.latitude,
              longitude: marker.longitude
            },
            title: marker.title,
            zIndex: marker.zIndex,
            icon: icon, // iconPath
            rotation: marker.rotate, // rotate
            alpha: marker.alpha,
            anchorU: marker.anchor?.x, // anchor
            anchorV: marker.anchor?.y, // anchor
            clickable: true,
          };
          this.mapController?.addMarker(markerOptions);
        })
        this.mapController?.on('markerClick', (marker: map.Marker) => {
          marker.setInfoWindowVisible(true);
        })
        // 设置mapController实例，用于Map控制
        mapControllerMap.set(this.params.componentId, this.mapController);
      }
    };
  }

  aboutToDisappear(): void {
    taroLogger.info(TAG, 'aboutToDisappear');
    // 移除注册了的事件
    this.eventList.forEach((eventName: string) => {
      taroLogger.info(TAG, `${eventName} event is removed`);
      this.mapController?.off(eventName as ESObject, () => {});
    })
    this.mapController?.off('markerClick', () => {});
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