import { Logger, LoggerLevel } from '@hybrid/web-container';
import { RouterToTaroHybrid } from './TaroHybridPage';
import router from '@ohos.router';

let storage = LocalStorage.getShared() // 获取共享的本地存储对象

@Entry(storage)
@Component
struct Index {
  aboutToAppear() {
    Logger.setLogLevel(LoggerLevel.LOG_DEBUG);
  }

  build() {
    Column({space: 30}) {
      Button('HelloWorld', { type: ButtonType.Normal, stateEffect: true })
        .borderRadius(8)
        .backgroundColor(0x317aff)
        .height(40)
        .onClick(()=>{
          RouterToTaroHybrid({
            indexHtmlPath: "index.html",
            taroPath: ""
          })
        })

      Button('多容器与容器共用', { type: ButtonType.Normal, stateEffect: true })
        .borderRadius(8)
        .backgroundColor(0x317aff)
        .height(40)
        .onClick(()=>{
          RouterToTaroHybrid({
            indexHtmlPath: "/spa/main/index.html",
            taroPath: "/pages/index/index"
          })
        })
      Button('TaroWebContainer组件', { type: ButtonType.Normal, stateEffect: true })
        .borderRadius(8)
        .backgroundColor(0x317aff)
        .height(40)
        .onClick(()=>{
          router.pushUrl({
            url: 'pages/WebContainerPage',
          }, router.RouterMode.Standard)
        })
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Center)
  }
}
