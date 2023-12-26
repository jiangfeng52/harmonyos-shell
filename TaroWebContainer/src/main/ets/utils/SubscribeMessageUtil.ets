import notificationManager from '@ohos.notificationManager';
import wantAgent from '@ohos.app.ability.wantAgent';
import http from '@ohos.net.http';
import image from '@ohos.multimedia.image';
import { BusinessError } from '@ohos.base';
import { RequestSubscribeMessageOptions } from '../interfaces/InjectObject';
import Want from '@ohos.app.ability.Want';

interface enableCode {
  errCode: number;
  errMsg: string;
}

interface addSlotCode {
  errCode: number;
  errMsg: string;
}

interface pushCode {
  errMsg: string;
}

interface cancelCode {
  errMsg: string;
}

interface pixelMapCode {
  image: image.PixelMap;
}

interface massageItem {
  tmplid: string;
  enabled: boolean;
}

interface wantAgentInfo {
  wants: Array<Want>;
  operationType: wantAgent.OperationType;
  requestCode: number;
}

interface massageLists {
  massageList: Array<massageItem>;
}

export interface SendMessageOptions {
  notificationRequest: NotificationRequest;
}

export interface NotificationRequest {
  id: number;
  slotType?: string;
  showDeliveryTime?: boolean;
  deliveryTime?: number;
  content: NotificationContent;
  path: string;
}

export interface NotificationContent {
  contentType: string;
  normal?: NotificationBasicContent;
  longText?: NotificationLongTextContent;
  multiLine?: NotificationMultiLineContent;
  picture?: NotificationPictureContent;
}

export interface NotificationBasicContent {
  title: string;
  text: string;
  additionalText: string;
}

export interface NotificationLongTextContent {
  title: string;
  text: string;
  additionalText: string;
  longText: string;
  briefText: string;
  expandedTitle: string;
}

export interface NotificationMultiLineContent {
  title: string;
  text: string;
  additionalText: string;
  longTitle: string;
  briefText: string;
  lines: Array<string>;
}

export interface NotificationPictureContent {
  title: string;
  text: string;
  additionalText: string;
  expandedTitle: string;
  briefText: string;
  picture: string;
}

export interface CancelMessageOptions {
  id: number;
}

export interface GetMessageOptions {
  errMsg: string;
}

export interface CancelOptions {
  errMsg: string;
}

export async function sendMessage(options: SendMessageOptions): Promise<GetMessageOptions> {
  const apiName: string = 'sendMessage';
  return new Promise(async (resolve, reject) => {
    let isHaveCode: boolean = false
    if (options.notificationRequest.slotType) {
      await isHaveNotificationChannel(options.notificationRequest.slotType).then((res) => {
        isHaveCode = res
      }).catch(() => {
        isHaveCode = false
      })
    } else {
      return reject({ errMsg: 'The notification channel is not specified.' });
    }
    if (isHaveCode) {
      try {
        const pushCode = await publishNotification(options)
        if (pushCode.errMsg === 'success') {
          return resolve({ errMsg: `${apiName}:ok` });
        } else {
          return reject(pushCode);
        }
      } catch (err) {
        return reject({ errMsg: `The parameter is incorrect.` });
      }
    } else {
      return reject({ errMsg: 'The corresponding channel is not subscribed to.' });
    }
  })
}

export async function cancelMessage(options: CancelMessageOptions): Promise<CancelOptions> {
  const apiName: string = 'cancelMessage';
  return new Promise(async (resolve) => {
    if (options.id) {
      let cancelCode = await cancelNotification(options)
      if (cancelCode.errMsg === 'success') {
        return resolve({ errMsg: `${apiName}:ok` });
      } else {
        return resolve(cancelCode);
      }
    } else {
      return resolve({ errMsg: 'Failed to obtain the correct id.' });
    }
  })
}

export async function addNotificationManagerSlot(options: RequestSubscribeMessageOptions): Promise<addSlotCode> {
  let addSlotCode: addSlotCode = {
    errCode: 200,
    errMsg: ''
  }
  if (typeof options.tmplIds === 'object') {
    let tmplId: string
    for (tmplId of options.tmplIds) {
      addSlotCode = await addSlot(tmplId)
      if (addSlotCode.errCode !== 200) {
        break;
      }
    }
  } else {
    addSlotCode.errMsg = `The template ID is incorrect.`
    addSlotCode.errCode = 10004
  }
  if (addSlotCode.errMsg !== '') {
    return addSlotCode;
  } else {
    addSlotCode.errMsg = 'fail: Unknown error of the system interface.'
    addSlotCode.errCode = 404
    return addSlotCode;
  }
}

async function addSlot(options: string): Promise<addSlotCode> {
  return new Promise<addSlotCode>((resolve, reject) => {
    const apiName: string = 'requestSubscribeMessage';
    let addSlotCode: addSlotCode = {
      errCode: 200,
      errMsg: ''
    }
    switch (options) {
      case 'OTHER_TYPES':
        notificationManager.addSlot(notificationManager.SlotType.OTHER_TYPES).then(() => {
          addSlotCode.errMsg = 'success'
          resolve(addSlotCode)
        }).catch((err: BusinessError) => {
          addSlotCode.errMsg = `${apiName}:fail  ${err.message}`
          addSlotCode.errCode = err.code
          reject(addSlotCode)
        });
        break;
      case 'CONTENT_INFORMATION':
        notificationManager.addSlot(notificationManager.SlotType.CONTENT_INFORMATION).then(() => {
          addSlotCode.errMsg = 'success'
          resolve(addSlotCode)
        }).catch((err: BusinessError) => {
          addSlotCode.errMsg = `${apiName}:fail  ${err.message}`
          addSlotCode.errCode = err.code
          reject(addSlotCode)
        });
        break;
      case 'SERVICE_INFORMATION':
        notificationManager.addSlot(notificationManager.SlotType.SERVICE_INFORMATION).then(() => {
          addSlotCode.errMsg = 'success'
          resolve(addSlotCode)
        }).catch((err: BusinessError) => {
          addSlotCode.errMsg = `${apiName}:fail  ${err.message}`
          addSlotCode.errCode = err.code
          reject(addSlotCode)
        });
        break;
      case 'SOCIAL_COMMUNICATION':
        notificationManager.addSlot(notificationManager.SlotType.SOCIAL_COMMUNICATION).then(() => {
          addSlotCode.errMsg = 'success'
          resolve(addSlotCode)
        }).catch((err: BusinessError) => {
          addSlotCode.errMsg = `${apiName}:fail  ${err.message}`
          addSlotCode.errCode = err.code
          reject(addSlotCode)
        });
        break;
      default:
        addSlotCode.errMsg = `The template ID is incorrect. `
        addSlotCode.errCode = 10004
        reject(addSlotCode)
    }
  })
}

export async function enableNotification(): Promise<enableCode> {
  let enableCode: enableCode = {
    errCode: 200,
    errMsg: ''
  }
  try {
    await notificationManager.requestEnableNotification().then(() => {
      enableCode.errMsg = 'success'
    }).catch((err: BusinessError) => {
      enableCode.errMsg = `${err.message}`
      enableCode.errCode = err.code
    });
  } catch (paramError) {
    enableCode.errMsg = `requestSubscribeMessage requestEnableNotification fail: ${JSON.stringify(paramError)}`
    enableCode.errCode = 500
  }
  if (enableCode.errMsg !== '') {
    return enableCode;
  } else {
    enableCode.errMsg = 'fail: Unknown error of the system interface.'
    enableCode.errCode = 500
    return enableCode;
  }
}

async function isHaveNotificationChannel(options?: string): Promise<boolean> {
  return new Promise<boolean>((resolve, reject) => {
    let dataCopy: Array<notificationManager.NotificationSlot>;
    notificationManager.getSlots().then((data: Array<notificationManager.NotificationSlot>) => {
      dataCopy = data
      for (const dataItem of dataCopy) {
        switch (dataItem.level) {
          case 1:
            if (options === 'OTHER_TYPES') {
              resolve(true)
            }
            break;
          case 2:
            if (options === 'CONTENT_INFORMATION') {
              resolve(true)
            }
            break;
          case 3:
            if (options === 'SERVICE_INFORMATION') {
              resolve(true)
            }
            break;
          case 4:
            if (options === 'SOCIAL_COMMUNICATION') {
              resolve(true)
            }
            break;
          default:
            resolve(false)
        }
      }
      reject(false)
    }).catch((err: BusinessError) => {
      console.error(`getSlots fail: ${JSON.stringify(err)}`);
    });
  })
}

async function publishNotification(options: SendMessageOptions): Promise<pushCode> {
  let pushCode: pushCode = {
    errMsg: ''
  }
  let notificationRequest: notificationManager.NotificationRequest;
  let slotType: notificationManager.SlotType;
  if (options.notificationRequest.slotType === 'OTHER_TYPES') {
    slotType = notificationManager.SlotType.OTHER_TYPES
  } else if (options.notificationRequest.slotType === 'CONTENT_INFORMATION') {
    slotType = notificationManager.SlotType.CONTENT_INFORMATION
  } else if (options.notificationRequest.slotType === 'SERVICE_INFORMATION') {
    slotType = notificationManager.SlotType.SERVICE_INFORMATION
  } else if (options.notificationRequest.slotType === 'SOCIAL_COMMUNICATION') {
    slotType = notificationManager.SlotType.SOCIAL_COMMUNICATION
  } else {
    pushCode.errMsg = 'The notification channel type is not found.'
    return pushCode;
  }
  switch (options.notificationRequest.content.contentType) {
    case 'NOTIFICATION_CONTENT_BASIC_TEXT':
      if (options.notificationRequest.content.normal) {
        notificationRequest = { // 描述通知的请求
          id: options.notificationRequest.id, // 通知ID
          slotType: slotType,
          content: {
            contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
            normal: {
              title: options.notificationRequest.content.normal.title,
              text: options.notificationRequest.content.normal.text,
              additionalText: options.notificationRequest.content.normal.additionalText,
            }
          },
        }
      }
      break;
    case 'NOTIFICATION_CONTENT_LONG_TEXT':
      if (options.notificationRequest.content.longText) {
        notificationRequest = { // 描述通知的请求
          id: options.notificationRequest.id, // 通知ID
          slotType: slotType,
          content: {
            contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_LONG_TEXT,
            longText: {
              title: options.notificationRequest.content.longText.title,
              text: options.notificationRequest.content.longText.text,
              additionalText: options.notificationRequest.content.longText.additionalText,
              longText: options.notificationRequest.content.longText.longText,
              briefText: options.notificationRequest.content.longText.briefText,
              expandedTitle: options.notificationRequest.content.longText.expandedTitle,
            }
          },
        }
      }
      break;
    case 'NOTIFICATION_CONTENT_PICTURE':
      if (options.notificationRequest.content.picture?.picture) {
        await urlConvertPixelMap(options.notificationRequest.content.picture.picture).then((res) => {
          let picture: image.PixelMap = res.image
          if (options.notificationRequest.content.picture) {
            notificationRequest = { // 描述通知的请求
              id: options.notificationRequest.id, // 通知ID
              slotType: slotType,
              content: {
                contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_PICTURE,
                picture: {
                  title: options.notificationRequest.content.picture.title,
                  text: options.notificationRequest.content.picture.text,
                  additionalText: options.notificationRequest.content.picture.additionalText,
                  briefText: options.notificationRequest.content.picture.briefText,
                  expandedTitle: options.notificationRequest.content.picture.expandedTitle,
                  picture: picture,
                }
              },
            }
          }
        }).catch((err: BusinessError) => {
          pushCode.errMsg = JSON.stringify(err)
          return pushCode;
        })
      }
      break;
    case 'NOTIFICATION_CONTENT_MULTILINE':
      if (options.notificationRequest.content.multiLine) {
        notificationRequest = { // 描述通知的请求
          id: options.notificationRequest.id, // 通知ID
          slotType: slotType,
          content: {
            contentType: notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE,
            multiLine: {
              title: options.notificationRequest.content.multiLine.title,
              text: options.notificationRequest.content.multiLine.text,
              additionalText: options.notificationRequest.content.multiLine.additionalText,
              briefText: options.notificationRequest.content.multiLine.briefText,
              longTitle: options.notificationRequest.content.multiLine.longTitle,
              lines: options.notificationRequest.content.multiLine.lines,
            }
          },
        }
      }
      break;
    default:
      pushCode.errMsg = 'The notification type does not exist.'
      break;
  }
  if (pushCode.errMsg !== '') {
    return pushCode;
  }
  let wantAgentInfo: wantAgentInfo = {
    wants: [
      {
        deviceId: '',
        bundleName: 'com.advanced.temp',
        abilityName: 'EntryAbility',
        parameters: {
          path: options.notificationRequest.path,
        },
      }
    ],
    operationType: wantAgent.OperationType.START_ABILITY,
    requestCode: 200
  }
  await wantAgent.getWantAgent(wantAgentInfo).then(async (data) => {
    let wantAgentObj = data;
    notificationRequest.wantAgent = wantAgentObj
    await notificationManager.publish(notificationRequest).then(() => { // 发布通知
      pushCode.errMsg = 'success'
    }).catch((err: BusinessError) => {
      pushCode.errMsg = `publish failed, dcode:${err.code}, message:${err.message}`
    });
  }).catch((err: BusinessError) => {
    if (err.code === 401) {
      pushCode.errMsg = `The parameter is incorrect`
    } else {
      pushCode.errMsg = `${JSON.stringify(err)}`
    }
  })
  if (pushCode.errMsg !== '') {
    return pushCode;
  } else {
    pushCode.errMsg = 'fail: Unknown error of the system interface.'
    return pushCode;
  }
}

async function cancelNotification(options: CancelMessageOptions): Promise<cancelCode> {
  let cancelCode: cancelCode = {
    errMsg: ''
  }
  await notificationManager.cancel(options.id).then(() => {
    cancelCode.errMsg = 'success'
  }).catch((err: BusinessError) => {
    cancelCode.errMsg = `cancelMessage fail: ${JSON.stringify(err)}`
  })
  if (cancelCode.errMsg !== '') {
    return cancelCode;
  } else {
    cancelCode.errMsg = 'fail: Unknown error of the system interface.'
    return cancelCode;
  }
}

async function urlConvertPixelMap(options: string): Promise<pixelMapCode> {
  // 网络图片请求方法
  return new Promise<pixelMapCode>((resolve, reject) => {
    let OutData: http.HttpResponse
    http.createHttp().request(
      options,
      (error: BusinessError, data: http.HttpResponse) => {
        if (error) {
          reject(error)
        } else {
          OutData = data
          let imageSource: image.ImageSource = image.createImageSource(OutData.result as ArrayBuffer); //通过传入的uri创建图片源实例。
          imageSource.createPixelMap({ desiredSize: { height: 100, width: 100 } }).then((pixelMap) => { //通过属性创建PixelMap
            let pixelMapCode: pixelMapCode = { image: pixelMap }
            resolve(pixelMapCode)
          }).catch((err: BusinessError) => {
            reject(err)
          })
        }
      }
    )
  })
}

export async function getMassageList(): Promise<massageLists> {
  return new Promise<massageLists>((resolve, reject) => {
    let dataCopy: Array<notificationManager.NotificationSlot>;
    notificationManager.getSlots().then((data: Array<notificationManager.NotificationSlot>) => {
      dataCopy = data
      let massageLists: massageLists = {
        massageList: []
      };
      dataCopy.forEach((dataItem) => {
        let massageItems: massageItem = {
          tmplid: '',
          enabled: false,
        };
        if (dataItem.enabled) {
          massageItems.enabled = dataItem.enabled;
        }
        switch (dataItem.level) {
          case 1:
            massageItems.tmplid = 'OTHER_TYPES'
            if (dataItem.enabled) {
              massageItems.enabled = dataItem.enabled;
            }
            massageLists.massageList.push(massageItems)
            break;
          case 2:
            massageItems.tmplid = 'CONTENT_INFORMATION'
            if (dataItem.enabled) {
              massageItems.enabled = dataItem.enabled;
            }
            massageLists.massageList.push(massageItems)
            break;
          case 3:
            massageItems.tmplid = 'SERVICE_INFORMATION'
            if (dataItem.enabled) {
              massageItems.enabled = dataItem.enabled;
            }
            massageLists.massageList.push(massageItems)
            break;
          case 4:
            massageItems.tmplid = 'SOCIAL_COMMUNICATION'
            if (dataItem.enabled) {
              massageItems.enabled = dataItem.enabled;
            }
            massageLists.massageList.push(massageItems)
            break;
        }
      })
      resolve(massageLists)
    }).catch((err: BusinessError) => {
      reject(`getSlots fail: ${JSON.stringify(err)}`)
    });

  })

}