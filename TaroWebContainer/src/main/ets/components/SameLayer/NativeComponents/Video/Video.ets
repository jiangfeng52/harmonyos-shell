import { wbLogger } from '../../../../utils/Logger';
import { sameLayerManager } from '../../../../utils/SameLayerManager';
import { VideoParams } from '../../Interfaces/SameLayer';

const TAG: string = 'SameLayerRender';

@Component
export struct NativeVideo {
  @ObjectLink params: VideoParams
  videoController: VideoController = new VideoController();

  build() {
    Column() {
      Video({
        src: this.params.src,
        controller: this.videoController
      })
        .objectFit(ImageFit.Fill)
        .autoPlay(this.params.autoPlay ?? true)
        .muted(this.params.muted ?? false)
        .loop(this.params.loop ?? false)
        .controls(this.params.controls ?? true)
        .onClick((event) => {
          wbLogger.info(TAG, 'NativeEmbed video onClick.');
        })
        .onStart(() => {
          wbLogger.info(TAG, 'NativeEmbed video onPlay.');
          const callJsOnPlay: Function | undefined = (sameLayerManager.getSameLayerArgs(this.params.componentId) as VideoParams)?.onPlay
          callJsOnPlay && callJsOnPlay('Native Video playing.')
        })
        .onPause(() => {
          wbLogger.info(TAG, 'NativeEmbed video onPause.')
          const callJsOnPause: Function | undefined = (sameLayerManager.getSameLayerArgs(this.params.componentId) as VideoParams)?.onPause
          callJsOnPause && callJsOnPause('Native Video paused.')
        })
        .onUpdate((event) => {
          wbLogger.info(TAG, 'NativeEmbed video onUpdate.')
          const callJsOnUpdate: Function | undefined = (sameLayerManager.getSameLayerArgs(this.params.componentId) as VideoParams)?.onUpdate
          callJsOnUpdate && callJsOnUpdate(event.time)
        })
        .onFinish(() => {
          wbLogger.info(TAG, 'NativeEmbed video onFinish.')
          const callJsOnFinish: Function | undefined = (sameLayerManager.getSameLayerArgs(this.params.componentId) as VideoParams)?.onFinish
          callJsOnFinish && callJsOnFinish('Native Video finished.')
        })
        .onError(() => {
          wbLogger.info(TAG, 'NativeEmbed video onError.')
          const callJsOnError: Function | undefined = (sameLayerManager.getSameLayerArgs(this.params.componentId) as VideoParams)?.onError
          callJsOnError && callJsOnError('Native Video error.')
        })
        .onSeeked((event) => {
          wbLogger.info(TAG, 'NativeEmbed video onSeeked.')
          const callJsOnSeeked: Function | undefined = (sameLayerManager.getSameLayerArgs(this.params.componentId) as VideoParams)?.onSeeked
          callJsOnSeeked && callJsOnSeeked(event.time)
        })
        .onSeeking((event) => {
          wbLogger.info(TAG, 'NativeEmbed video onSeeking.')
          const callJsOnSeeking: Function | undefined = (sameLayerManager.getSameLayerArgs(this.params.componentId) as VideoParams)?.onSeeking
          callJsOnSeeking && callJsOnSeeking(event.time)
        })
    }
    .width(this.params.width)
    .height(this.params.height)
  }
}

@Builder
export function NativeVideoBuilder(params: VideoParams) {
  NativeVideo({ params: params})
    .backgroundColor(Color.White)
}

