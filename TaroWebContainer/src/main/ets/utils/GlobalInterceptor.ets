import { as } from '../utils/advancedapi.min';
import { ErrorCode } from '../utils/MediaUtil';
import { apiCustomDialogManager } from './ApiCustomDialogManager'

//AdvancedApi涉及动态权限API返回的moduleName字段
const contactModuleNames: Array<string> = ['addPhoneContact'];
const locationModuleNames: Array<string> = ['getLocation', 'startLocationUpdate', 'startLocationUpdateBackground'];
const documentModuleNames: Array<string> = ['saveImageToPhotosAlbum'];

export function setupGlobalInterceptor() {
  as.addInterceptor({
    fail: (err: ESObject) => {
      const errCode: string = err?.errCode
      const moduleName: string = err?.moduleName
      const grantStatus: number = err?.grantStatus
      const dialogShownResults: boolean = err?.dialogShownResults
      if (errCode && Number(errCode) === ErrorCode.USER_REJECT) {
        if (moduleName === null || moduleName === undefined) {
          return
        }
        if (locationModuleNames.includes(moduleName)) {
          if (grantStatus === -1 && !dialogShownResults) {
              // 后续拒绝
              apiCustomDialogManager.getHandler()?.({ permission: 'ohos.permission.LOCATION', name: '定位' } as ESObject)
          }
        } else if (documentModuleNames.includes(moduleName)) {
            if (grantStatus === -1 && !dialogShownResults) {
              // 后续拒绝
              apiCustomDialogManager.getHandler()?.({ permission: 'ohos.permission.READ_IMAGEVIDEO', name: '文件' } as ESObject)
          } 
        } else if (contactModuleNames.includes(moduleName)) {
            if (grantStatus === -1 && !dialogShownResults) {
              // 后续拒绝
              apiCustomDialogManager.getHandler()?.({ permission: 'ohos.permission.WRITE_CONTACTS', name: '通讯录' } as ESObject)
            } 
        } else {
          // moduleName不在范围则退出
          return
        }
      }
    }
  })
}