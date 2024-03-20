import { TaroHybridUtils } from './TaroHybridUtils'

@Component
export struct DebugLayout {
  @State devDomain: string = 'http://10.253.110.21:10086'
  @Prop indexHtmlPath: string = ''
  @Prop taroPath: string = ''
  @State useCache: boolean = true
  private scrollerForScroll: Scroller = new Scroller()
  refresh?: (domain: string, indexHtmlPath: string, taroPath: string, useCache: boolean)=>void

  aboutToAppear(): void {
    // const storageDevDomain = TaroHybridUtils.getSP(this.domain)
    // if(storageDevDomain) {
    //   this.devDomain = storageDevDomain
    // }
  }

  @Builder
  inputListItem(name: string, value: string, onChange: (value: string)=>void, enabled?: boolean){
    Row({ space: 10 }) {
      Text(name)
        .width('80vp')
      TextInput({ placeholder: '请输入', text: value })
        .layoutWeight(1)
        .onChange(onChange)
        .enabled(enabled ?? true)
    }
    .width('100%')
    .height('48vp')
  }

  build() {
    Scroll(this.scrollerForScroll){
      Column() {
        this.inputListItem('domain', this.devDomain ?? '', (value: string)=>{
          this.devDomain = value
        })

        Divider().strokeWidth('0.5vp').color('#0D000000').margin({top: '4vp', bottom: '4vp'})

        this.inputListItem('indexHtml', this.indexHtmlPath ?? '', (value: string)=>{
          this.indexHtmlPath = value
        }, false)

        Divider().strokeWidth('0.5vp').color('#0D000000').margin({top: '4vp', bottom: '4vp'})

        this.inputListItem('taroPath', this.taroPath ?? '', (value: string)=>{
          this.taroPath = value
        }, false)

        Divider().strokeWidth('0.5vp').color('#0D000000').margin({top: '4vp', bottom: '4vp'})

        Row({ space: 10 }) {
          Text('走缓存')
            .width('80vp')
          Toggle({ type: ToggleType.Switch, isOn: this.useCache })
            .onChange((isOn: boolean) => {
              this.useCache = isOn;
            })
        }
        .width('100%')
        .height('48vp')

        Divider().strokeWidth('0.5vp').color('#0D000000').margin({top: '4vp', bottom: '4vp'})

        Row() {
          Button('重 新 加 载')
            .height('30vp')
            .width(120)
            .backgroundColor(0xF55A42)
            .onClick(() => {
              TaroHybridUtils.setSP(`${this.indexHtmlPath}_devdomain`, this.devDomain)
              TaroHybridUtils.setSP(`${this.indexHtmlPath}_useCache`, this.useCache)
              if(this.refresh) {
                this.refresh(this.devDomain, this.indexHtmlPath, this.taroPath, this.useCache)
              }
            })
        }
        .width('100%')
        .height('48vp')
        .justifyContent(FlexAlign.Center)
      }.width("100%").height("100%")
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xDCDCDC)
    .padding(10)
    .scrollable(ScrollDirection.Vertical) // 滚动方向纵向
  }
}