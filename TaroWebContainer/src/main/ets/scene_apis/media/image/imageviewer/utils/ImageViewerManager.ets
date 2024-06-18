import { PreviewImageOptions } from '../../Image';

export interface ImageViewerOptions {
  urls: Array<string>;
  current: string;
  showmenu: boolean;
}

class ImageViewerManager {
  private imageViewerTrigger?: (options: ImageViewerOptions) => void;

  setImageViewerTrigger(trigger: (options: ImageViewerOptions) => void) {
    this.imageViewerTrigger = trigger;
  }

  imageView(options: PreviewImageOptions) {
    if (this.imageViewerTrigger) {
      try {
        this.imageViewerTrigger({
          urls: options.urls,
          current: options.current,
          showmenu: options.showmenu
        })
        options.success()
      } catch (e) {
        options.fail({ errMsg: JSON.stringify(e) })
      }
    } else {
      options.fail()
    }
  }
}

export const imageViewerManager = new ImageViewerManager();