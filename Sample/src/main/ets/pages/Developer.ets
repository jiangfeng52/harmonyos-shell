import router from '@ohos.router';
import { NavigationBar, NavigationBarData } from 'web-container';
import { NotificationRequest,SendMessageOptions ,NotificationContent,NotificationPictureContent ,NotificationBasicContent,
  NotificationLongTextContent,NotificationMultiLineContent,CancelMessageOptions,sendMessage,cancelMessage
} from '../../../../../TaroWebContainer/src/main/ets/utils/SubscribeMessageUtil';
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
  @State notificationId: number = 1;
  @State cancelId: number = 1;
  @State notificationSlotType: string = 'OTHER_TYPES';
  @State notificationPath: string = '/pages/api/index/index';
  @State notificationContentType: string = 'NOTIFICATION_CONTENT_BASIC_TEXT';
  @State notificationTitle: string = '测试';
  @State notificationText: string = '测试';
  @State notificationAdditionalText: string = '测试';
  @State notificationBriefText: string = '测试';
  @State notificationLinesLongText: string = '测试';
  @State notificationLinesLongTitle: string = '测试';
  @State notificationExpandedTitle: string = '测试';
  @State notificationPicture: string = 'https://img0.baidu.com/it/u=1525457646,3693644&fm=253&fmt=auto&app=138&f=JEPG?w=500&h=375';
  @State notificationLinesItemOne: string = '测试';
  @State notificationLinesItemTwo: string = '测试';
  @State navigationBarData: NavigationBarData = new NavigationBarData();

  aboutToAppear() {
    this.navigationBarData.visible = true;
    this.navigationBarData.title = this.title;
    this.navigationBarData.canBackward = true;
    this.navigationBarData.loading = false;
  }

  publishNotification() {
    let lines :Array<string> = []
    if (this.notificationContentType === 'NOTIFICATION_CONTENT_MULTILINE') {
      lines.push(this.notificationLinesItemOne)
      lines.push(this.notificationLinesItemTwo)
    }
    let NotificationPictureContent:NotificationPictureContent = {
      title:this.notificationTitle,
      text:this.notificationText,
      additionalText:this.notificationAdditionalText,
      briefText:this.notificationBriefText,
      expandedTitle:this.notificationExpandedTitle,
      picture:this.notificationPicture
    }
    let NotificationMultiLineContent:NotificationMultiLineContent = {
      title:this.notificationTitle,
      text:this.notificationText,
      additionalText:this.notificationAdditionalText,
      longTitle:this.notificationLinesLongTitle,
      briefText:this.notificationBriefText,
      lines:lines
    }
    let NotificationLongTextContent:NotificationLongTextContent = {
      title:this.notificationTitle,
      text:this.notificationText,
      additionalText:this.notificationAdditionalText,
      longText:this.notificationLinesLongText,
      briefText:this.notificationBriefText,
      expandedTitle:this.notificationExpandedTitle
    }
    let NotificationBasicContent:NotificationBasicContent = {
      title:this.notificationTitle,
      text:this.notificationText,
      additionalText:this.notificationAdditionalText,
    }
    let NotificationContent:NotificationContent = {
      contentType:this.notificationContentType
    }
    if (this.notificationContentType === 'NOTIFICATION_CONTENT_LONG_TEXT') {
      NotificationContent.longText = NotificationLongTextContent
    } else if (this.notificationContentType === 'NOTIFICATION_CONTENT_MULTILINE') {
      NotificationContent.multiLine = NotificationMultiLineContent
    } else if ( this.notificationContentType === 'NOTIFICATION_CONTENT_PICTURE') {
      NotificationContent.picture = NotificationPictureContent
    } else if ( this.notificationContentType === 'NOTIFICATION_CONTENT_BASIC_TEXT') {
      NotificationContent.normal = NotificationBasicContent
    } else {
      console.log('Incorrect notification type.')
      return;
    }
    let notificationRequests:NotificationRequest = {
      id:this.notificationId,
      slotType:this.notificationSlotType,
      content:NotificationContent,
      path:this.notificationPath
    }
    let SendMessageOption:SendMessageOptions = {
      notificationRequest:notificationRequests
    }
    try {
      sendMessage(SendMessageOption).then((res) => {
        console.log('requestSubscribeMessage',JSON.stringify(res))
      }).catch((err:Error) => {
        console.log('requestSubscribeMessage',JSON.stringify(err))
      })
    } catch (err) {
      console.log("requestSubscribeMessage",JSON.stringify(err))
    }
  }

  cancelPublish () {
    let cancelMessageOptions:CancelMessageOptions = {
      id:this.cancelId
    }
    cancelMessage(cancelMessageOptions).then((res) => {
      console.log('requestSubscribeMessage',JSON.stringify(res))
    }).catch((err:Error) => {
      console.log('requestSubscribeMessage',JSON.stringify(err))
    })
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
      Column({ space: 10 }) {
        Row({ space: 10 }) {
          Text('发送通知')
            .fontSize(18)
        }
        .width('100%')

        Row({ space: 10 }) {
          Text('通知ID')
          TextInput({ placeholder: '请输入通知ID' })
            .type(InputType.Number)
            .onChange((value: string) => {
              this.notificationId = Number(value);
            })
            .layoutWeight(1)
        }
        .width('100%')

        Row({ space: 10 }) {
          Text('通知通道')
          Select([{ value: 'OTHER_TYPES' },
            { value: 'CONTENT_INFORMATION' },
            { value: 'SERVICE_INFORMATION' },
            { value: 'SOCIAL_COMMUNICATION' }])
            .selected(0)
            .value('OTHER_TYPES')
            .font({ size: 16, weight: 500 })
            .fontColor('#182431')
            .selectedOptionFont({ size: 16, weight: 400 })
            .optionFont({ size: 16, weight: 400 })
            .onSelect((index: number, value: string) => {
              this.notificationSlotType = value;
            })
        }.width('100%')

        Row({ space: 10 }) {
          Text('通知类型')
          Select([{ value: 'NOTIFICATION_CONTENT_BASIC_TEXT' },
            { value: 'NOTIFICATION_CONTENT_LONG_TEXT' },
            { value: 'NOTIFICATION_CONTENT_MULTILINE' },
            { value: 'NOTIFICATION_CONTENT_PICTURE' }])
            .selected(0)
            .value('NOTIFICATION_CONTENT_BASIC_TEXT')
            .font({ size: 16, weight: 500 })
            .fontColor('#182431')
            .selectedOptionFont({ size: 16, weight: 400 })
            .optionFont({ size: 16, weight: 400 })
            .onSelect((index: number, value: string) => {
              this.notificationContentType = value;
            })
        }
        .width('100%')

        Row({ space: 10 }) {
          Text('通知点击跳转路径')
          TextInput({ placeholder: '请输入路径', text: this.notificationPath })
            .onChange((value: string) => {
              this.notificationPath = value;
            })
            .layoutWeight(1)
        }
        .width('100%')

        Row({ space: 10 }) {
          Text('通知标题')
          TextInput({ placeholder: '请输入标题', text: this.notificationTitle })
            .onChange((value: string) => {
              this.notificationTitle = value;
            })
            .layoutWeight(1)
        }
        .width('100%')

        Row({ space: 10 }) {
          Text('通知内容')
          TextInput({ placeholder: '请输入通知内容', text: this.notificationText })
            .onChange((value: string) => {
              this.notificationText = value;
            })
            .layoutWeight(1)
        }
        .width('100%')

        Row({ space: 10 }) {
          Text('通知附加内容')
          TextInput({ placeholder: '请输入通知附加内容', text: this.notificationAdditionalText })
            .onChange((value: string) => {
              this.notificationAdditionalText = value;
            })
            .layoutWeight(1)
        }
        .width('100%')

        if (this.notificationContentType === 'NOTIFICATION_CONTENT_LONG_TEXT') {
          Row({ space: 10 }) {
            Text('通知的长文本')
            TextInput({ placeholder: '请输入通知的长文本', text: this.notificationLinesLongText })
              .onChange((value: string) => {
                this.notificationLinesLongText = value;
              })
              .layoutWeight(1)
          }
          .width('100%')
        }
        if (this.notificationContentType === 'NOTIFICATION_CONTENT_LONG_TEXT' || this.notificationContentType === 'NOTIFICATION_CONTENT_PICTURE' || this.notificationContentType === 'NOTIFICATION_CONTENT_MULTILINE') {
          Row({ space: 10 }) {
            Text('通知概要内容')
            TextInput({ placeholder: '请输入通知概要内容', text: this.notificationBriefText })
              .onChange((value: string) => {
                this.notificationBriefText = value;
              })
              .layoutWeight(1)
          }
          .width('100%')
        }

        if (this.notificationContentType === 'NOTIFICATION_CONTENT_LONG_TEXT' || this.notificationContentType === 'NOTIFICATION_CONTENT_PICTURE') {
          Row({ space: 10 }) {
            Text('通知展开时的标题')
            TextInput({ placeholder: '请输入通知展开时的标题', text: this.notificationExpandedTitle })
              .onChange((value: string) => {
                this.notificationExpandedTitle = value;
              })
              .layoutWeight(1)
          }
          .width('100%')
        }
        if (this.notificationContentType === 'NOTIFICATION_CONTENT_MULTILINE') {
          Row({ space: 10 }) {
            Text('通知展开时的标题')
            TextInput({ placeholder: '通知展开时的标题', text: this.notificationLinesLongTitle })
              .onChange((value: string) => {
                this.notificationLinesLongTitle = value;
              })
              .layoutWeight(1)
          }
          .width('100%')

          Row({ space: 10 }) {
            Text('通知多行文本第一行')
            TextInput({ placeholder: '第一行', text: this.notificationLinesItemOne })
              .onChange((value: string) => {
                this.notificationLinesItemOne = value;
              })
              .layoutWeight(1)
          }
          .width('100%')

          Row({ space: 10 }) {
            Text('通知多行文本第二行')
            TextInput({ placeholder: '第二行', text: this.notificationLinesItemTwo })
              .onChange((value: string) => {
                this.notificationLinesItemTwo = value;
              })
              .layoutWeight(1)
          }
          .width('100%')
        }
        if (this.notificationContentType === 'NOTIFICATION_CONTENT_PICTURE') {
          Row({ space: 10 }) {
            Text('图片url')
            TextInput({ placeholder: '图片最大不能超过2M', text: this.notificationPicture })
              .onChange((value: string) => {
                this.notificationPicture = value;
              })
              .layoutWeight(1)
          }
          .width('100%')
        }
        Flex({ justifyContent: FlexAlign.SpaceAround }) {
          Button('发送通知')
            .width(120)
            .backgroundColor(0xF55A42)
            .onClick(() => {
              this.publishNotification()
            })
        }
        Row({ space: 10 }) {
          Text('取消通知的ID')
          TextInput({ placeholder: '取消通知的ID', })
            .onChange((value: string) => {
              this.cancelId = Number(value);
            })
            .type(InputType.Number)
            .layoutWeight(1)
        }
        .width('100%')
        .padding(10)

        Flex({ justifyContent: FlexAlign.SpaceAround }) {
          Button('取消发送')
            .width(120)
            .backgroundColor(0xF55A42)
            .onClick(() => {
              this.cancelPublish()
            })
        }
      }
      .padding(10)
    }
  }
}
