import { BaseCapsule } from '@ohos/taroweb/src/main/ets/components/BaseCapsule'

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