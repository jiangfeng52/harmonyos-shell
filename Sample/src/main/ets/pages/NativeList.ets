import { router } from '@kit.ArkUI';
import { SafeArea } from '../components/SafeArea';
import { RouterToTaroHybrid } from './TaroHybridPage';

@Entry
@Component
struct NativeList {
  @State message: string = 'Native List页面';

  build() {
    Column(){
      SafeArea(){
        RelativeContainer() {
          Button('返回')
            .backgroundColor(Color.Red)
            .margin({ top: 10, left: 10 })
            .alignRules({
              left: {anchor: '__container__', align: HorizontalAlign.Start},
              top: {anchor: '__container__', align: VerticalAlign.Top}
            })
            .onClick(()=>{
              router.back()
            })

          Text(this.message)
            .id('title')
            .fontSize(28)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .alignRules({
              top: { anchor: '__container__', align: VerticalAlign.Top },
              middle: { anchor: '__container__', align: HorizontalAlign.Center }
            })
            .margin({top: 60})
          Button('小程序详情页')
            .alignRules({
              middle: {anchor: '__container__', align: HorizontalAlign.Center},
              top: {anchor: 'title', align: VerticalAlign.Bottom}
            })
            .margin({top: 10})
            .onClick(()=>{
              RouterToTaroHybrid({
                indexHtmlPath: "/spa/main/index.html",
                taroPath: "/pages/harmony-hybrid/mix-router/detail/index"
              })
            })
        }
        .height('100%')
        .width('100%')
        .backgroundColor(Color.Green)
      }
    }
  }
}