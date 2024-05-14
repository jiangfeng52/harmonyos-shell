@Observed
export class MapParams {
  width: number
  height: number
  componentId: string
  latitude: number
  longitude: number
  bearing?: number // 旋转角度
  tilt?: number // 倾斜角度
  zoom?: number // 缩放级别，取值范围为 3-20, 默认为16，鸿蒙取值范围是2-20
  minZoom?: number // 最小缩放级别 3-20，鸿蒙取值范围是2-20
  maxZoom?: number // 最大缩放级别 3-20，鸿蒙取值范围是2-20
  zoomGesturesEnabled?: boolean // 是否支持缩放手势
  scrollGesturesEnabled?: boolean // 是否支持拖动手势
  rotateGesturesEnabled?: boolean // 是否支持旋转手势
  setTrafficEnabled?: boolean // 设置是否显示路况图层
  compassControlsEnabled?: boolean // 显示指南针
  scaleControlsEnabled?: boolean // 显示比例尺
  setMyLocationEnabled?: boolean // 设置是否显示当前定位点

  constructor() {
    this.width = 0;
    this.height = 0;
    this.componentId = '';
    this.latitude = 0;
    this.longitude = 0;
  }
}

@Observed
export class VideoParams {
  width: number
  height: number
  componentId: string
  src: string
  controls?: boolean
  muted?: boolean
  loop?: boolean
  autoPlay?: boolean
  objectFit?: ImageFit
  onPlay?: (res?: string) => void
  onPause?: (res?: string) => void
  onFinish?: (res?: string) => void
  onUpdate?: (res?: number) => void
  onError?: (res?: string) => void
  onSeeked?: (res?: number) => void
  onSeeking?: (res?: number) => void

  constructor() {
    this.width = 0;
    this.height = 0;
    this.componentId = '';
    this.src = '';
  }
}