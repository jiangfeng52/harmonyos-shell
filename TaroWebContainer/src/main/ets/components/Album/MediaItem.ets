import { MediaItemData } from '../../interfaces/Media';
import { getThumbnailPixelMap } from '../../utils/MediaUtil';
import { taroLogger } from '../../utils/Logger';

const MEDIA_ITEM_TAG = 'MediaItem';

@Component
export struct MediaItem {
  @ObjectLink data: MediaItemData;
  @Link allowAdd: boolean;
  onPhotoClick?: (res: MediaItemData) => void;
  onSwitchSelectClick?: () => void;
  notAllowSelectTip?: () => void;
  @State thumbnail: PixelMap | undefined = undefined;

  onCheckClick() {
    if (this.allowAdd || this.data.isSelected) {
      this.data.isSelected = !this.data.isSelected;
      this.onSwitchSelectClick?.()
    } else {
      this.notAllowSelectTip?.()
    }
  }

  getThumbnailForVideo() {
    if (this.data.type === 'video') {
      getThumbnailPixelMap(this.data.originPath).then((pixelMap) => {
        this.thumbnail = pixelMap;
      }, () => {
        taroLogger.error(MEDIA_ITEM_TAG, 'getThumbnailForVideo fail')
      })
    }
  }

  durationToText(duration: number) {
    const h: number = Math.floor(duration / 1000 / 60 / 60 % 24)
    const m: number = Math.floor(duration / 1000 / 60 % 60)
    const s: number = Math.floor(duration / 1000 % 60)
    const text: string[] = []
    if (h > 0) {
      text.push(`${h < 10 ? '0' : ''}${h}`)
    }
    text.push(`${m < 10 ? '0' : ''}${m}`)
    text.push(`${s < 10 ? '0' : ''}${s}`)
    return text.join(':')
  }

  aboutToAppear() {
    this.getThumbnailForVideo();
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Stack({ alignContent: Alignment.BottomStart }) {
        Image(this.data.type === 'image' ? this.data.originPath : this.thumbnail)
          .height('100%')
          .width('100%')
          .objectFit(ImageFit.Cover)
        if (this.data.type === 'video') {
          Row({ space: 5 }) {
            Image($r('app.media.video'))
              .height(25)
              .margin({ left: 5, bottom: 5 })
              .fillColor(Color.White)
            Text(this.durationToText(this.data.duration))
              .height(18)
              .fontColor(Color.White)
              .margin({ bottom: 5 })
          }.alignItems(VerticalAlign.Center)
        }
      }

      Button({ type: ButtonType.Normal })
        .backgroundColor(Color.Black)
        .width('100%')
        .height('100%')
        .opacity(this.data.isSelected ? 0.5 : 0)
        .onClick(() => {
          this.onPhotoClick && this.onPhotoClick(this.data)
        })
      Button()
        .width(40)
        .height(40)
        .onClick(() => {
          this.onCheckClick()
        })
        .backgroundColor(Color.Transparent)
      Circle()
        .width(20)
        .height(20)
        .fillOpacity(this.data.isSelected ? 1 : 0.4)
        .fill(this.data.isSelected ? Color.Green : Color.Black)
        .strokeWidth(1)
        .stroke(this.data.isSelected ? Color.Green : Color.White)
        .margin({ top: 5, right: 5 })
        .antiAlias(true)
        .onClick(() => {
          this.onCheckClick()
        })
    }
    .height('100%')
    .width('100%')
  }
}
