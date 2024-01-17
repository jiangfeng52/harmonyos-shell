import { BaseCapsule } from '@hybrid/web-container'

@Entry
@Component
struct Capsule {
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