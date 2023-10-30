import { BaseCapsule } from 'TaroWebContainer'

@Entry
@Component
export struct Capsule {
  build() {
    Column() {
      BaseCapsule()
        .width('100%')
        .height('100%')
    }
  }
}