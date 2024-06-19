import { ImageViewerConstants } from '../constants/ImageViewerConstants';

/**
 * 函数执行加动画
 *
 * @param fn：要在动画内执行的回调函数
 * @param duration：动画持续时长
 * @param curve：动画区线
 */
export function runFuncWithAnimation(
  fn: Function,
  duration: number = ImageViewerConstants.ANIMATE_DURATION,
  curve: Curve = Curve.Smooth): void {
  animateTo({ duration: duration, curve: curve }, () => {
    fn();
  })
}

