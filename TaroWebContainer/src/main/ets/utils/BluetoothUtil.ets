import { requestPermission } from './PermissionMapScopeUtil';
import { Permissions } from '@kit.AbilityKit';
import { SettingOptions } from '../interfaces/InjectObject';

export async function requestAccessBluetoothPermission(options: SettingOptions) {
  // 申请访问蓝牙的权限
  const permissionsParams: Permissions[] = ['ohos.permission.ACCESS_BLUETOOTH']
  const permissionsResults = await requestPermission(permissionsParams);
  for (let i = 0; i < permissionsResults.length; i++) {
    if (permissionsResults[i] !== 0) {
      options.fail({ errMsg: `permission fail` })
      return
    }
  }
  options.success()
}