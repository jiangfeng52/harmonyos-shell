import { taroLogger } from '../utils/Logger';
import { TaroHybridUtils } from './TaroHybridUtils'

@Component
export struct DebugTaroWebContainer {

  private debugLayoutHeight: number = 300;
  @State debugLayoutVisible: Visibility = Visibility.None;

  @Builder taroWebLayoutBuilder() {}
  @BuilderParam taroWebBuilderParam: () => void = this.taroWebLayoutBuilder;


  @State devDomain: string = ''
  @Prop indexHtmlPath: string = ''
  @Prop taroPath: string = ''
  @Prop useCache: boolean = true
  private scrollerForScroll: Scroller = new Scroller()
  refresh?: (domain: string, indexHtmlPath: string, taroPath: string, useCache: boolean)=>void

  aboutToAppear(): void {
  }

  @Builder
  inputListItem(name: string, value: string, onChange: (value: string)=>void, enabled?: boolean,placeholder?:string){
    Row({ space: 10 }) {
      Text(name)
        .width('80vp')
      TextInput({ placeholder: placeholder == null ?'请输入' : placeholder, text: value })
        .layoutWeight(1)
        .onChange(onChange)
        .enabled(enabled ?? true)
    }
    .width('100%')
    .height('48vp')
  }

  build() {
    Column(){

      Scroll(this.scrollerForScroll){
        Column() {
          this.inputListItem('domain', this.devDomain ?? '' , (value: string)=>{
            this.devDomain = value
          },true,"http://ip:port")

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
                taroLogger.debug("CrossOrigin","重新加载："+this.useCache)
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
      .height(this.debugLayoutHeight)
      .backgroundColor("#44bbccaa")
      .visibility(this.debugLayoutVisible)
      .padding(10)
      .scrollable(ScrollDirection.Vertical) // 滚动方向纵向
      .position({
        x: 0,
        y: this.debugLayoutVisible == Visibility.Visible ? 0 : -this.debugLayoutHeight
      })

      Stack({alignContent: Alignment.TopEnd}){
        this.taroWebBuilderParam()
        Button(`${this.debugLayoutVisible == Visibility.Visible ? '收起' : '调试'}`,  { type: ButtonType.Capsule, stateEffect: false })
          .backgroundColor(0x317aff)
          .height(25)
          .margin({top: 5, right: 5})
          .onClick(()=>{
            this.debugLayoutVisible = this.debugLayoutVisible == Visibility.Visible ? Visibility.None : Visibility.Visible
          })
      }
      .width("100%")
      .layoutWeight(1)
      .position({
        x: 0,
        y:  this.debugLayoutVisible == Visibility.Visible ? this.debugLayoutHeight : 0
      })
    }
    .width("100%")
    .height("100%")
  }

}