import { matrix4, promptAction } from '@kit.ArkUI';
import { ImageViewerConstants } from '../constants/ImageViewerConstants';
import { OffsetModel } from '../model/OffsetModel';
import { ScaleModel } from '../model/ScaleModel';
import { runFuncWithAnimation } from '../utils/AnimationUtil';
import { loadAndSaveImage } from '../utils/loadAndSaveImage';
import { common } from '@kit.AbilityKit';

@Component
export struct ImageItem {
  @State isEnableOffset: boolean = false; // 是否可以偏移
  @State imageScaleInfo: ScaleModel = new ScaleModel(); // 缩放数据
  @State imageOffsetInfo: OffsetModel = new OffsetModel(); // 偏移数据
  @State matrix: matrix4.Matrix4Transit = matrix4.identity().copy();
  @State showLoading: boolean = true;
  imageUrl: string = ""; // 当前图片url
  controller?: SwiperController;

  aboutToAppear(): void {
    this.init();
  }

  /**
   * 原始图片状态
   */
  init(): void {
    this.isEnableOffset = false;
    this.imageScaleInfo.reset();
    this.imageOffsetInfo.reset();
    this.matrix = matrix4.identity().copy();
  }

  build() {
    Stack() {
      Image(this.imageUrl)
        .objectFit(ImageFit.Contain)
        .autoResize(false)
        .transform(this.matrix)
        .defaultFocus(true)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .draggable(false)// 避免长按手势冲突
        .offset({
          x: this.imageOffsetInfo.currentX,
          y: this.imageOffsetInfo.currentY
        })
      if (this.showLoading) {
        Row () {
          LoadingProgress()
            .color(Color.White)
            .width(ImageViewerConstants.IMAGE_ITEM_WIDTH)
            .height(ImageViewerConstants.LOADING_IMAGE_HEIGHT)
        }
        .width(ImageViewerConstants.IMAGE_ITEM_WIDTH)
        .height(ImageViewerConstants.IMAGE_ITEM_WIDTH)
      }
    }
    .onBlur(() => {
      this.init();
    })
    .backgroundColor(ImageViewerConstants.IMAGE_VIEWER_BACKGROUND_COLOR)
    .alignContent(Alignment.BottomEnd)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .gesture(
      GestureGroup(
        GestureMode.Exclusive, // 互斥识别手势
        LongPressGesture()
          .onAction(() => {
            let dialogController: CustomDialogController | null = null;
            dialogController = new CustomDialogController({
              builder: SelectDialog({
                url: this.imageUrl,
                cancel: () => {
                  dialogController = null; // 清理dialogController
                }
              }),
              cancel: () => {
                dialogController = null; // 清理dialogController
              },
              alignment: DialogAlignment.Bottom,
              offset: { dx: 0, dy: -20 },
              autoCancel: true
            })
            if (dialogController !== null) {
              dialogController.open()
            }
          }),
        TapGesture({ count: 2 })
          .onAction(() => {
            let fn: Function;
            // 已经是放大状态下，双击缩小，恢复到原始状态
            if (this.imageScaleInfo.scaleValue > this.imageScaleInfo.defaultScaleValue) {
              fn = () => {
                this.init();
              };
            } else {
              // 已经是缩小状态，双击放大
              fn = () => {
                this.imageScaleInfo.scaleValue = this.imageScaleInfo.maxScaleValue;
                this.imageOffsetInfo.reset();
                this.matrix = matrix4.identity().scale({
                  x: this.imageScaleInfo.scaleValue,
                  y: this.imageScaleInfo.scaleValue,
                }).copy();
                this.imageScaleInfo.stash();
              }
            }
            runFuncWithAnimation(fn);
          }),
        PinchGesture({ fingers: 2, distance: 1 })
          .onActionUpdate((event: GestureEvent) => {
            // 缩放时不允许大于最大缩放因子+额外缩放因子，不允许小于默认大小-额外缩放因子，额外缩放因子用于提升用户体验
            this.imageScaleInfo.scaleValue = this.imageScaleInfo.lastValue * event.scale;
            if (this.imageScaleInfo.scaleValue > this.imageScaleInfo.maxScaleValue *
              (1 + this.imageScaleInfo.extraScaleValue)
            ) {
              this.imageScaleInfo.scaleValue = this.imageScaleInfo.maxScaleValue *
                (1 + this.imageScaleInfo.extraScaleValue);
            }
            if (this.imageScaleInfo.scaleValue < this.imageScaleInfo.defaultScaleValue *
              (1 - this.imageScaleInfo.extraScaleValue)) {
              this.imageScaleInfo.scaleValue = this.imageScaleInfo.defaultScaleValue *
                (1 - this.imageScaleInfo.extraScaleValue);
            }
            this.matrix = matrix4.identity().scale({
              x: this.imageScaleInfo.scaleValue,
              y: this.imageScaleInfo.scaleValue,
            }).copy();
          })
          .onActionEnd((event: GestureEvent) => {
            // 回弹缩放状态
            if (this.imageScaleInfo.scaleValue < this.imageScaleInfo.defaultScaleValue) {
              runFuncWithAnimation(() => {
                this.init();
              })
            }
            if (this.imageScaleInfo.scaleValue > this.imageScaleInfo.maxScaleValue) {
              runFuncWithAnimation(() => {
                this.imageScaleInfo.scaleValue = this.imageScaleInfo.maxScaleValue;
                this.matrix = matrix4.identity()
                  .scale({
                    x: this.imageScaleInfo.maxScaleValue,
                    y: this.imageScaleInfo.maxScaleValue
                  });
              })
            }
            this.imageScaleInfo.stash();
          }),
        PanGesture({ fingers: 1 })
          .onActionUpdate((event: GestureEvent) => {
            if (this.imageScaleInfo.scaleValue === this.imageScaleInfo.defaultScaleValue) {
              // 默认大小下不允许移动
              return;
            }
            this.imageOffsetInfo.currentX = this.imageOffsetInfo.lastX + event.offsetX;
            this.imageOffsetInfo.currentY = this.imageOffsetInfo.lastY + event.offsetY;
          })
          .onActionEnd((event: GestureEvent) => {
            if (this.imageScaleInfo.scaleValue === this.imageScaleInfo.defaultScaleValue) {
              if (event.offsetX < 0) {
                this.controller?.showNext();
              } else {
                this.controller?.showPrevious();
              }
            }
            this.imageOffsetInfo.stash();
          })
      ),
    )
  }
}

@CustomDialog
struct SelectDialog {
  url: string = '';
  cancel: () => void = () => {};
  dialogController: CustomDialogController;

  build() {
    Column() {
      Row() {
        SaveButton({ text:SaveDescription.SAVE_IMAGE, buttonType:ButtonType.Normal })
          .width('100%')
          .fontSize(14)
          .fontColor(Color.Black)
          .backgroundColor(Color.White)
          .onClick(async (event: ClickEvent, result: SaveButtonOnClickResult) => {
            this.dialogController.close();
            if (result == SaveButtonOnClickResult.SUCCESS) {
              const context = getContext(this) as common.UIAbilityContext;
              loadAndSaveImage(this.url, context);
            } else {
              promptAction.showToast({ message: '设置权限失败' })
            }
            this.cancel();
          })
      }
      .width('100%')
      .height(50)
      Divider()
      Text('取消')
        .width('100%')
        .height(20)
        .textAlign(TextAlign.Center)
        .fontSize(14)
        .fontColor(Color.Blue)
        .margin({ top: 15, bottom: 15 })
        .onClick(() => {
          this.dialogController.close();
          this.cancel();
        })
    }
  }
}