import { getAuthResults } from '../utils/PermissionMapScopeUtil';
import { as } from '../utils/advancedapi.min';
import { ErrorCode } from '../utils/MediaUtil';
import { wbLogger } from '../utils/Logger';
import { apiCustomDialogManager } from '../samelayer/SameLayerManager'

//权限拒绝后将当前权限的授权结果存储
const locationPermissionArray: number[] = [];
const playerPermissionArray: number[] = [];
const phonePermissionArray: number[] = [];

//AdvancedApi涉及动态权限API返回的moduleName字段
const contactModuleNames: Array<string> = ['addPhoneContact'];
const locationModuleNames: Array<string> = ['getLocation', 'startLocationUpdate', 'startLocationUpdateBackground'];
const documentModuleNames: Array<string> = ['saveImageToPhotosAlbum'];

const GLOBAL_INTERCEPTOR = 'globalInterceptor';

export function setupGlobalInterceptor() {
  as.addInterceptor({
    fail: (err: ESObject) => {
      wbLogger.info(GLOBAL_INTERCEPTOR, '[AdvancedAPI] 全局拦截器 fail ' + JSON.stringify(err));
      const errCode: string = err?.errCode
      const moduleName: string = err?.moduleName
      if (errCode && Number(errCode) === ErrorCode.USER_REJECT) {
        if (moduleName === null || moduleName === undefined) {
          return
        }
        if (locationModuleNames.includes(moduleName)) {
          locationPermissionArray.push(getAuthResults())
          if (getAuthResults() === -1 && locationPermissionArray.length !== 1) {
              // 后续拒绝
              apiCustomDialogManager.getBuild()?.({ permission: 'ohos.permission.LOCATION', name: '定位' } as ESObject)
          }
        } else if (documentModuleNames.includes(moduleName)) {
            playerPermissionArray.push(getAuthResults())
            if (getAuthResults() === -1 && playerPermissionArray.length !== 1) {
              // 后续拒绝
              apiCustomDialogManager.getBuild()?.({ permission: 'ohos.permission.READ_IMAGEVIDEO', name: '文件' } as ESObject)
          } 
        } else if (contactModuleNames.includes(moduleName)) {
            phonePermissionArray.push(getAuthResults())
            if (getAuthResults() === -1 && phonePermissionArray.length !== 1) {
              // 后续拒绝
              apiCustomDialogManager.getBuild()?.({ permission: 'ohos.permission.WRITE_CONTACTS', name: '通讯录' } as ESObject)
            } 
        } else {
          // moduleName不在范围则退出
          return
        }
      }
    }
  })
}