@Entry
@Component
struct WidgetCard {
  /*
   * The mini title.
   */
  readonly MINI_TITLE: string = 'Title';

  /*
   * The item content.
   */
  readonly ITEM_CONTENT: string = 'Taro应用迁移模板';

  /*
   * The action type.
   */
  readonly ACTION_TYPE: string = 'router';

  /*
   * The ability name.
  */
  readonly ABILITY_NAME: string = 'EntryAbility';

  /*
   * 卡片点击跳转链接.
   */
  readonly url: string = 'resource://rawfile/index.html#/';

  /*
   * The mini display priority.
   */
  readonly MINI_DISPLAY_PRIORITY: number = 2;

  /*
   * The max line.
   */
  readonly MAX_LINES: number = 1;

  /*
   * The with percentage setting.
   */
  readonly FULL_WIDTH_PERCENT: string = '100%';

  /*
   * The height percentage setting.
   */
  readonly FULL_HEIGHT_PERCENT: string = '100%';

  /*
   * Image height percentage setting.
   */
  readonly IMAGE_HEIGHT_PERCENT: string = '64%';
  @State mini: boolean = false;

  build() {
    Row() {
      Column() {
        if (this.mini) {
          Column() {
            Text(this.MINI_TITLE)
              .fontSize($r('app.float.mini_title_font_size'))
              .fontColor($r('app.color.mini_text_font_color'))
              .margin({
                left: $r('app.float.mini_title_margin'),
                bottom: $r('app.float.mini_title_margin')
              })
          }
          .width(this.FULL_WIDTH_PERCENT)
          .alignItems(HorizontalAlign.End)
          .backgroundImageSize(ImageSize.Cover)
          .backgroundImage($r("app.media.ic_widget"), ImageRepeat.NoRepeat)
          .displayPriority(this.MINI_DISPLAY_PRIORITY)
        }
        Stack() {
          // 卡片展示图片路径，只支持本地图片
          Image($rawfile('desktop_card.png'))
            .width(this.FULL_WIDTH_PERCENT)
            .height(this.FULL_HEIGHT_PERCENT)
            .objectFit(ImageFit.Fill)
          Column() {
            Text(this.ITEM_CONTENT)
              .maxLines(this.MAX_LINES)
              .margin({top: $r('app.float.subTitle_marginTop')})
              .fontSize($r('app.float.normal_content_font_size'))
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontColor(Color.White)
              .position({ x: 8, y: 105 })
          }
        }
      }
      .width(this.FULL_WIDTH_PERCENT)
      .height(this.FULL_HEIGHT_PERCENT)
      .alignItems(HorizontalAlign.Start)
    }
    .height(this.FULL_HEIGHT_PERCENT)
    .alignItems(VerticalAlign.Top)
    .onClick(() => {
      postCardAction(this, {
        "action": this.ACTION_TYPE,
        "abilityName": this.ABILITY_NAME,
        "params": {
          "url": this.url
        }
      });
    })
  }
}