import { ImageViewerConstants } from '../constants/ImageViewerConstants';

@Observed
export class ScaleModel {
  public scaleValue: number; // 本次缩放值
  public lastValue: number; // 上次缩放值
  public maxScaleValue: number; // 默认最大缩放值
  public extraScaleValue: number; // 额外缩放值，提升用户体验
  public readonly defaultScaleValue: number = 1.0; // 默认缩放值

  constructor(scaleValue: number = 1.0, lastValue: number = 1.0,
    maxScaleValue: number = ImageViewerConstants.MAX_SCALE_VALUE,
    extraScaleValue: number = ImageViewerConstants.EXTRA_SCALE_VALUE) {
    this.scaleValue = scaleValue;
    this.lastValue = lastValue;
    this.maxScaleValue = maxScaleValue;
    this.extraScaleValue = extraScaleValue;
  }

  reset(): void {
    this.scaleValue = this.defaultScaleValue;
    this.lastValue = this.scaleValue;
  }

  stash(): void {
    this.lastValue = this.scaleValue;
  }
}