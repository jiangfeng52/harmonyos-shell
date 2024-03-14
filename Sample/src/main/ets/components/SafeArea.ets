@Component
export struct SafeArea {
  private topRectHeight: string = AppStorage.get<number>('topRectHeight') + 'px';

  @BuilderParam child: ()=>void

  build() {
    Column() {
       Row()
         .width('100%')
         .height(this.topRectHeight)
         .backgroundColor(0xFFFFFF)
      Column(){
        this.child()
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}