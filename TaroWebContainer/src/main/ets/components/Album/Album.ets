import promptAction from '@ohos.promptAction';

import { MediaItem } from './MediaItem';
import { CheckOriginal } from './CheckOriginal';
import { DetailMedia } from './DetailMedia';
import { IMediaData, MediaItemData, ChooseAlbumResult, chooseAlbumOptions } from '../../interfaces/Media';
import { getThumbnailPixelMap } from '../../utils/MediaUtil';
import { wbLogger } from '../../utils/Logger';

const ALBUM_TAG = 'Album';

// 懒加载详情列表
class MediaDataSource implements IDataSource {
  private list: MediaItemData[] = [];

  constructor(list: MediaItemData[]) {
    this.list = list;
  }

  totalCount() {
    return this.list.length;
  }

  getData(index: number) {
    return this.list[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
  }

  unregisterDataChangeListener() {
  }

  getList() {
    return this.list;
  }
}


@Component
export struct Album {
  // 顶部避免布局区域，避开状态栏
  @Prop avoidAreaHeight: number = 0;
  // 是否选中原图按钮
  @State checkOriginPhoto: boolean = false;
  // 当前选中的个数
  @State selectedCount: number = 0;
  // 是否处于详情列表状态
  @Link showDetail: boolean;
  // 是否可以继续选择媒体
  @State allowAdd: boolean = true;
  // 全部媒体文件列表
  @Prop mediaItemList: MediaItemData[];
  // 当前选中的媒体文件列表
  @State @Watch('onSelectedItemListUpdate') selectedItemList: MediaItemData[] = [];
  // 懒加载详情页面数据源
  private dataSource: MediaDataSource = new MediaDataSource([]);
  // 底部选中的媒体列表滑动控制
  private listScroller = new Scroller();
  // 初始配置
  options: chooseAlbumOptions = {
    count: 9,
    mediaType: ['image', 'video'],
    sizeType: ['original', 'compressed'],
  };
  // 退出图库时回调处理函数
  onExitAlbumHandler?: (success: boolean, result: ChooseAlbumResult) => void;
  // 当前展示的详情媒体信息在详情列表中的索引
  @State currentDetailIndex: number = 0;
  // 点击缩率图进入详情列表
  onPhotoItemClick = (res: MediaItemData) => {
    this.dataSource = new MediaDataSource(this.mediaItemList);
    const index = this.dataSource.getList().findIndex((item) => item.originPath === res.originPath)
    this.currentDetailIndex = (index >= 0 ? index : 0);
    this.showDetail = true;

  }

  //切换媒体选择状态时，更新选择个数和允许条件状态
  onSelectedItemListUpdate() {
    this.selectedCount = this.selectedItemList.length;
    this.allowAdd = this.selectedCount < this.options.count;
  }

  // 切换媒体文件选中状态时，更新选中列表
  onSwitchSelectClick = () => {
    this.selectedItemList = this.mediaItemList.filter((item) => item.isSelected);
  }
  // 不允许继续添加提示信息
  notAllowSelectTip = () => {
    let typeInfo: string = '个媒体文件';
    if (this.options.mediaType.length === 1) {
      typeInfo = this.options.mediaType?.[0] === 'image' ? '张图片' : '个视频'
    }
    promptAction.showToast({
      message: `你最多只能选择${this.options.count}${typeInfo}`,
      duration: 2000,
    })
  }

  aboutToAppear() {
    if (this.options.sizeType.length === 1 && this.options.sizeType[0] === 'original') {
      this.checkOriginPhoto = true;
    }
    // 进入图库时，获取视频文件的缩率图
    for (const media of this.mediaItemList) {
      if (media.type === 'video') {
        getThumbnailPixelMap(media.originPath).then((pixelMap) => {
          media.thumbnail = pixelMap;
        }, () => {
          wbLogger.error(ALBUM_TAG, 'getThumbnailForVideo fail')
        })
      }
    }
  }

  // 获取选中的媒体文件的信息
  getResultData(): ChooseAlbumResult {
    const tempFiles: IMediaData[] = []
    for (const item of this.selectedItemList) {
      const media: IMediaData = {
        originPath: item.originPath,
        originSize: item.originSize,
        duration: item.duration,
        height: item.height,
        width: item.width,
        type: item.type,
      }
      tempFiles.push(media)
    }
    return {
      tempFiles,
      isOriginal: this.checkOriginPhoto,
    }
  }

  build() {
    Column() {
      Row() {
        if (this.showDetail) {
          Row() {
            Image($r("app.media.back")).fillColor(Color.White)
              .width(28)
              .margin({ left: 10 })
              .onClick(() => {
                this.showDetail = false
              })
            Text(`${this.currentDetailIndex}/${this.dataSource.getList().length}`)
              .fontColor(Color.White)
            Row() {
              Checkbox()
                .selectedColor(Color.Green)
                .select(this.dataSource.getData(this.currentDetailIndex)?.isSelected || false)
                .onClick(() => {
                  const originState = this.dataSource.getData(this.currentDetailIndex).isSelected
                  this.dataSource.getData(this.currentDetailIndex).isSelected = !originState;
                  this.selectedItemList = this.mediaItemList.filter((item) => item.isSelected);
                })
                .enabled(this.allowAdd || this.dataSource.getData(this.currentDetailIndex).isSelected)
              Text('选择')
                .fontColor(Color.White)
            }
            .onClick(() => {
              if (!(this.allowAdd || this.dataSource.getData(this.currentDetailIndex).isSelected)) {
                this.notAllowSelectTip()
              }
            })
            .margin({ right: 10 })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .height(28)
          .width('100%')
          .margin({ bottom: 5 })
        } else {
          Image($r("app.media.close"))
            .fillColor(Color.White)
            .width(28)
            .height(28)
            .margin({ left: 10, bottom: 5 })
            .onClick(() => {
              this.onExitAlbumHandler?.(false, {} as ChooseAlbumResult);
            })
        }
      }
      .height(this.avoidAreaHeight + 35)
      .width('100%')
      .alignItems(VerticalAlign.Bottom)
      .justifyContent(FlexAlign.Start)
      .backgroundColor('#1E1E1E')

      Stack() {
        Grid() {
          ForEach(this.mediaItemList, (item: MediaItemData, index: number) => {
            GridItem() {
              MediaItem({
                data: item,
                allowAdd: this.allowAdd,
                onPhotoClick: this.onPhotoItemClick,
                onSwitchSelectClick: this.onSwitchSelectClick,
                notAllowSelectTip: this.notAllowSelectTip,

              })
                .height('100%')
                .width('100%')
            }
            .width('100%')
            .aspectRatio(1)
          }, (item: MediaItemData) => JSON.stringify(item))
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .rowsGap(2)
        .columnsGap(2)
        .edgeEffect(EdgeEffect.Spring)
        .backgroundColor('#222222')
        .visibility(this.showDetail ? Visibility.Hidden : Visibility.Visible)

        if (this.showDetail) {
          Column() {
            Swiper() {
              LazyForEach(this.dataSource, (item: MediaItemData, index: number) => {
                DetailMedia({ media: item, isShown: index === this.currentDetailIndex })
              }, (item: MediaItemData) => JSON.stringify(item))
            }
            .layoutWeight(1)
            .cachedCount(5)
            .indicator(false)
            .index(this.currentDetailIndex)
            .onChange((index) => {
              this.currentDetailIndex = index
              const selectedIndex = this.selectedItemList.findIndex(
                (item) => item.originPath === this.dataSource.getData(index).originPath)
              if (selectedIndex >= 0) {
                this.listScroller.scrollToIndex(selectedIndex, true, ScrollAlign.CENTER)
              }
            })

            if (this.selectedItemList.length > 0) {
              List({ space: 5, scroller: this.listScroller }) {
                ForEach(this.selectedItemList, (itemData: MediaItemData) => {
                  ListItem() {
                    Stack({ alignContent: Alignment.BottomStart }) {
                      Image(itemData.type === 'image' ? itemData.originPath : itemData.thumbnail)
                        .height('100%')
                        .aspectRatio(1)
                        .onClick(() => {
                          const index = this.dataSource.getList()
                            .findIndex((item) => item.originPath === itemData.originPath)
                          if (index >= 0) {
                            this.currentDetailIndex = index
                          }
                        })
                        .borderWidth(2)
                        .borderColor(this.dataSource.getData(this.currentDetailIndex)
                          .originPath === itemData.originPath ? Color.Green : Color.Transparent)
                      Image($r('app.media.video'))
                        .height(16)
                        .margin({ left: 5, bottom: 2 })
                        .fillColor(Color.White)
                        .visibility(itemData.type === 'video' ? Visibility.Visible : Visibility.Hidden)
                    }

                  }.margin({ top: 8, bottom: 8 })
                }, (item: MediaItemData) => JSON.stringify(item))
              }
              .height(76)
              .width('100%')
              .backgroundColor('#88333333')
              .listDirection(Axis.Horizontal)
              .edgeEffect(EdgeEffect.Spring)
              .scrollBar(BarState.Off)
            }
          }
        }
      }
      .layoutWeight(1)

      Row() {
        Button() {
          Row() {
            Text('预览')
            Text(this.selectedCount > 0 ? `(${this.selectedCount})` : '')
          }.foregroundColor(this.selectedCount > 0 ? Color.White : Color.Gray)
        }
        .backgroundColor(Color.Transparent)
        .visibility(this.showDetail ? Visibility.Hidden : Visibility.Visible)
        .onClick(() => {
          this.selectedItemList = this.mediaItemList.filter((item) => item.isSelected);
          this.dataSource = new MediaDataSource(this.selectedItemList);
          this.currentDetailIndex = 0;
          this.showDetail = true;
        })
        .enabled(this.selectedCount > 0)
        .width(70)

        CheckOriginal({ checked: this.checkOriginPhoto, active: this.options.sizeType.length === 2 })
          .visibility(this.options.sizeType.length === 1 && this.options.sizeType[0] === 'compressed' ? Visibility.Hidden : Visibility.Visible)

        Button({ type: ButtonType.Normal, stateEffect: true }) {
          Row() {
            Text('完成')
            Text(this.selectedCount > 0 ? `(${this.selectedCount})` : '')
          }.foregroundColor(this.selectedCount > 0 ? Color.White : Color.Gray)
        }
        .enabled(this.selectedCount > 0)
        .borderRadius(8)
        .backgroundColor(this.selectedCount > 0 ? Color.Green : '#888888')
        .width(70)
        .height(25)
        .onClick(() => {
          this.onExitAlbumHandler?.(true, this.getResultData());
        })
      }
      .height(60)
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      .backgroundColor('#1E1E1E')
    }
    .backgroundColor('#2b2b2b')
  }
}
