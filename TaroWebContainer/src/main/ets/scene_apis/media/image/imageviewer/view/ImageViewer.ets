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
  private childRecognizer: GestureRecognizer = new GestureRecognizer();
  private currentRecognizer: GestureRecognizer = new GestureRecognizer();
  private panStart: boolean = true

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

  swiperAnimation(val: boolean): void {
    this.panStart = val
  }

  build() {
    Swiper(this.swiperController) {
      // 多图预览时使用懒加载提升性能
      LazyForEach(this.imageDataSource, (item: string, index: number) => {
        ImageItem({
          imageUrl: item,
          controller: this.swiperController,
          swiperAnimation: (value: boolean) => this.swiperAnimation(value)
        })
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
    .shouldBuiltInRecognizerParallelWith((current: GestureRecognizer, others: Array<GestureRecognizer>) => {
      for (let i = 0; i < others.length; i++) {
        let target = others[i].getEventTargetInfo();
        if (target) {
          if (others[i].getType() === GestureControl.GestureType.PAN_GESTURE) { // 找到将要组成并行手势的识别器
            this.currentRecognizer = current; // 保存当前组件的识别器
            this.childRecognizer = others[i]; // 保存将要组成并行手势的识别器
            return others[i]; // 返回将要组成并行手势的识别器
          }
        }
      }
      return undefined;
    })
    .onGestureRecognizerJudgeBegin((event: BaseGestureEvent, current: GestureRecognizer,
      others: Array<GestureRecognizer>) => { // 在识别器即将要成功时，根据当前组件状态，设置识别器使能状态
      if (current) {
        let target = current.getEventTargetInfo();
        if (target) {
          if (current.isBuiltIn() && current.getType() === GestureControl.GestureType.PAN_GESTURE) {
            if (others) {
              for (let i = 0; i < others.length; i++) {
                let target = others[i].getEventTargetInfo() as ScrollableTargetInfo;
                if (target instanceof ScrollableTargetInfo) { // 找到响应链上对应并行的识别器
                  if (this.panStart) { // isEnd返回当前滚动类容器组件是否在底部 根据当前组件状态以及移动方向动态控制识别器使能状态
                    this.childRecognizer.setEnabled(false)
                    this.currentRecognizer.setEnabled(true)
                  } else {
                    this.childRecognizer.setEnabled(true)
                    this.currentRecognizer.setEnabled(false)
                  }
                }
              }
            }
          }
        }
      }
      return GestureJudgeResult.CONTINUE;
    })
  }
}