import { ImageViewerConstants } from '../constants/ImageViewerConstants';
import { LazyDataSourceModel } from '../model/LazyDataSourceModel';
import { ImageViewerOptions } from '../utils/ImageViewerManager';
import { ImageItem } from './ImageItem';

@CustomDialog
export struct ImageViewer {
  @Prop options: ImageViewerOptions; // 图片数据源
  imageDataSource: LazyDataSourceModel = new LazyDataSourceModel(); // 使用懒加载提升性能
  swiperController: SwiperController = new SwiperController();
  swiperIndex: number | string = 0;
  dialogController: CustomDialogController;

  /**
   * 初始化数据
   */
  aboutToAppear(): void {
    this.swiperIndex = this.options.current || 0;
    if (this.swiperIndex && typeof this.swiperIndex === 'string') {
      if (this.options.urls.includes(this.swiperIndex)) {
        this.swiperIndex = this.options.urls.indexOf(this.swiperIndex);
      } else {
        this.swiperIndex = 0;
      }
    } else {
      if (this.swiperIndex < 0 || this.swiperIndex > this.options.urls.length - 1) {
        this.swiperIndex = 0;
      }
    }
    this.options.urls.forEach((url: string) => {
      this.imageDataSource.pushData(url);
    })
  }

  build() {
    Swiper(this.swiperController) {
      // 多图预览时使用懒加载提升性能
      LazyForEach(this.imageDataSource, (item: string, index: number) => {
        ImageItem({ imageUrl: item, controller: this.swiperController })
          .width(ImageViewerConstants.IMAGE_ITEM_WIDTH)
          .height(ImageViewerConstants.IMAGE_ITEM_HEIGHT)
      })
    }
    .width(ImageViewerConstants.SWIPER_WIDTH)
    .height(ImageViewerConstants.SWIPER_HEIGHT)
    .autoPlay(false)
    .disableSwipe(false) // 设置是否可以切换图片
    .loop(true)
    .indicator(
      new DigitIndicator()
        .fontColor(Color.White)
        .selectedFontColor(Color.White)
    ) // 设置数字指示标
    .displayArrow({
      // 设置导航点箭头样式
      showBackground: true,
      isSidebarMiddle: true,
      backgroundSize: 30,
      backgroundColor: Color.White,
      arrowSize: 30,
      arrowColor: Color.Blue
    }, false)
    .cachedCount(ImageViewerConstants.SWIPER_CACHE_COUNT) // 设置缓存的图片数量
    .index(this.swiperIndex as number)
  }
}