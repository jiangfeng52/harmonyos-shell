import { BaseCapsule } from '@ohos/web-container'

@Entry
@Component
export struct Capsule {
  build() {
    Column() {
      BaseCapsule({
        targetPage: 'pages/Developer',
      })
        .width('100%')
        .height('100%')
    }
  }
}