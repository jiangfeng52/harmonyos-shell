import { RouterUtils } from '../utils/RouterUtils';
import { NavigationBar } from '../components/NavigationBar';
import { NaviController } from '../controllers/NaviController';
import { RouterController } from '../controllers/RouterController';

@Component
export struct BaseCapsule {
  title: string = '账户设置'

  @Provide routerController: RouterController = new RouterController();
  @State naviController: NaviController = new NaviController();
  @Prop targetPage: string = 'pages/Developer';

  aboutToAppear() {
    this.naviController.visible = true;
    this.naviController.title = this.title;
    this.naviController.canBackward = true;
    this.naviController.loading = false;
  }

  build() {
    Column() {
      NavigationBar({
        naviController: this.naviController,
      })
      Column(){
        List(){
          ListItem(){
            Row(){
              Text('开发者选项')
                .fontSize('14fp')
                .fontColor('#182431')
              Blank()
              Text('说明')
                .fontSize('14fp')
                .fontColor('#99182431')
            }
            .width('100%')
            .height('48vp')
          }
          .onClick((event: ClickEvent)=>{
            RouterUtils.pushUrlWithLog(this.targetPage)
          })

        }
        .divider({
          strokeWidth: '0.5vp',
          color: '#0D000000'
        })
      }
      .width('93%')
      .padding({top: '4vp', bottom: '4vp', left: '12vp', right: '12vp'})
      .margin({top: '8vp'})
      .backgroundColor(Color.White)
      .borderRadius('24vp')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.common_background'))
  }
}