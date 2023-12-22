import { MediaItemData } from '../../interfaces/Media';
import { getThumbnailPixelMap } from '../../utils/MediaUtil';
import { wbLogger } from '../../utils/Logger';

const DETAIL_MEDIA_TAG = 'DetailMedia';

@Component
export struct DetailMedia {
  @Prop media: MediaItemData
  controller: VideoController = new VideoController()
  @State isVideoPlaying: boolean = false
  @Prop @Watch('onShownUpdate') isShown: boolean
  @State thumbnail: PixelMap | undefined = undefined;

  getThumbnailForVideo() {
    if (this.media.type === 'video') {
      getThumbnailPixelMap(this.media.originPath).then((pixelMap) => {
        this.thumbnail = pixelMap;
      }, () => {
        wbLogger.error(DETAIL_MEDIA_TAG, 'getThumbnailForVideo fail')
      })
    }
  }

  aboutToAppear() {
    this.getThumbnailForVideo();
  }

  onShownUpdate() {
    if (!this.isShown) {
      this.controller.stop();
      this.isVideoPlaying = false;
    }
  }

  build() {
    if (this.media.type === 'image') {
      Image(this.media.originPath)
        .width('100%')
        .objectFit(ImageFit.Cover)
    } else {
      Stack({ alignContent: Alignment.Center }) {
        Video({
          src: this.media.originPath,
          previewUri: this.thumbnail,
          controller: this.controller,
        })
          .controls(false)
          .width('100%')
          .onPause(() => {
            this.isVideoPlaying = false
          })
          .onFinish(() => {
            this.isVideoPlaying = false
          })
        Image($r('app.media.play_circle'))
          .width(80)
          .height(80)
          .fillColor(Color.White)
          .onClick(() => {
            this.controller.start()
            this.isVideoPlaying = true
          })
          .visibility(this.isVideoPlaying ? Visibility.Hidden : Visibility.Visible)
      }
      .width('100%')
    }
  }
}
