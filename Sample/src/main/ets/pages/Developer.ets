import router from '@ohos.router';
import { NavigationBar, NavigationBarData } from 'web-container';

PersistentStorage.persistProp('enableDevDomain', false);
PersistentStorage.persistProp('devDomain', '');

let storage = LocalStorage.getShared();

@Entry(storage)
@Component
export struct Developer {
  title: string = '开发者选项'
  @StorageLink('enableDevDomain') enableDevDomain: boolean = false;
  @StorageLink('devDomain') devDomain: string = '';
  @LocalStorageLink('refresh') refresh: boolean = false;

  @State enableDevDomainState: boolean = this.enableDevDomain;
  @State devDomainState: string = this.devDomain;

  @State navigationBarData: NavigationBarData = new NavigationBarData();

  aboutToAppear() {
    this.navigationBarData.visible = true;
    this.navigationBarData.title = this.title;
    this.navigationBarData.canBackward = true;
    this.navigationBarData.loading = false;
  }

  build() {
    Column() {
      NavigationBar({
        navigationBarData: this.navigationBarData
      })
      Scroll() {
        Column({ space: 10 }) {
          Row({ space: 10 }) {
            Text('启用远程调试域名')
              .fontSize(18)
            Toggle({ type: ToggleType.Switch, isOn: this.enableDevDomainState })
              .onChange((isOn: boolean) => {
                this.enableDevDomainState = isOn;
              })
          }
          .width('100%')

          if (this.enableDevDomainState) {
            Row({ space: 10 }) {
              Text('小程序域名')
              TextInput({ placeholder: '请输入域名', text: this.devDomainState })
                .onChange((value: string) => {
                  this.devDomainState = value;
                })
                .layoutWeight(1)
            }
            .width('100%')
          }

          Flex({ justifyContent: FlexAlign.SpaceAround }) {
            Button('重 新 加 载')
              .width(120)
              .backgroundColor(0xF55A42)
              .onClick(() => {
                if (this.devDomainState.endsWith("/")) {
                  this.devDomain = this.devDomainState;
                } else {
                  this.devDomain = `${this.devDomainState}/`;
                }
                this.enableDevDomain = this.enableDevDomainState;
                this.refresh = true;
                router.back();
              })
            Button('取 消')
              .onClick(() => {
                router.back();
              })
              .width(120)
          }
        }
        .padding(10)
      }
    }
  }
}
