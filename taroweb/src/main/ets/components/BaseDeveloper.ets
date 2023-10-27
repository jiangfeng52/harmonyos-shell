import router from '@ohos.router'
import { NavigationBar } from '../components/NavigationBar'



@Component
export struct BaseDeveloper {
  title: string = '开发者选项'
  @Link entryDomain:string;
  @State entryDomainState: string = this.entryDomain
  @Link useBuildIn:boolean;
  @State useBuildInState: boolean = this.useBuildIn
  @Link refresh:boolean;

  build() {
    Column() {
      NavigationBar({
        navVisible: true,
        canBackward: true,
        navLoading: false,
        title: this.title,
        showCapsule: false
      })
      Scroll(){
        Column({space: 10}){
          Row({space: 10}){
            Text('小程序域名')
            TextInput({placeholder: '请输入域名', text: this.entryDomainState})
              .onChange((value:string)=>{
                this.entryDomainState = value
              })
          }
          .width('100%')

          Row({space: 10}){
            Text('是否走内置')
            Toggle({type: ToggleType.Switch, isOn: this.useBuildInState})
              .onChange((isOn: boolean)=>{
                this.useBuildInState = isOn;
              })
          }
          .width('100%')

          Flex({justifyContent: FlexAlign.SpaceAround}) {
            Button('重 新 加 载')
              .width(120)
              .backgroundColor(0xF55A42)
              .onClick(()=>{
                if (this.entryDomainState.endsWith("/")) {
                  this.entryDomain = this.entryDomainState
                } else {
                  this.entryDomain = `${this.entryDomainState}/`
                }
                this.useBuildIn = this.useBuildInState
                this.refresh = true
                router.back()
              })
            Button('取 消')
              .onClick(()=>{
                router.back()
              })
              .width(120)
          }
        }
        .padding(10)
      }
    }
  }
}