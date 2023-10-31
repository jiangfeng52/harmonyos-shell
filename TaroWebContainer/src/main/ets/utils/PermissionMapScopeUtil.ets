/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import bundleManager from '@ohos.bundle.bundleManager';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import { GlobalThis } from './GlobalThis';
import { AuthSetting, PermissionInfo } from '../interfaces/InjectObject';

/**
 * 应用权限处理实用函数
 */

export interface BundleScopeResult {
  allScope: AuthSetting;
  bundleScope: Map<string, boolean>;
}

const ohosMappingWxMap: Map<string, string[]> = new Map<string, string[]>([
  ['scope.userLocation', ['ohos.permission.LOCATION', 'ohos.permission.LOCATION_IN_BACKGROUND']],
  ['scope.writePhotosAlbum', ['ohos.permission.WRITE_IMAGEVIDEO', 'ohos.permission.READ_IMAGEVIDEO']],
]);

const allScopeUseMap: AuthSetting = {
  'scope.userInfo': false,
  'scope.userLocation': false,
  'scope.address': false,
  'scope.invoiceTitle': false,
  'scope.invoice': false,
  'scope.werun': false,
  'scope.record': false,
  'scope.writePhotosAlbum': false,
  'scope.camera': false,
  'scope.bluetoothBackground': false,
};

let bundleUsedScopeMap: Map<string, boolean> = new Map<string, boolean>([]);

export async function getBundleWxScopeList(permissions: Array<PermissionInfo>): Promise<BundleScopeResult> {
  if (Array.isArray(permissions) && permissions.length === 0) {
    console.error('permissions 数组为空');
    return { allScope: allScopeUseMap, bundleScope: bundleUsedScopeMap };
  }

  await Promise.all(permissions.map(async (permissionObj) => {
    for (const entry of ohosMappingWxMap.entries()) {
      const key = entry[0];
      const value = entry[1];
      console.log(`Key: ${key}`);
      console.log(`Value: ${value}`);
      // 判断权限组中是否包含子权限
      if (!value.includes(permissionObj.name)) {
        continue;
      }
      allScopeUseMap[key] = true;

      let grantRet = false;
      // 在这里对 value 进行循环处理
      for (const item of value) {
        if (item === permissionObj.name) {
          // 获取当前权限的授权结果，grantStatus为0表示已授权，-1表示未授权
          const permissionItem = item as Permissions;
          let grantStatus: abilityAccessCtrl.GrantStatus = await checkAccessToken(permissionItem);
          if (grantStatus === 0) {
            grantRet = true;
          }
        }
      }
      // 保存当前权限的授权结果，已经授权时，直接存值；未授权时，如果之前授过权限，，就保持不变，如果未曾授权，则不需要处理
      if (grantRet || (!grantRet && bundleUsedScopeMap.get(key))) {
        bundleUsedScopeMap.set(key, grantRet)
      }
    }
  }));
  return { allScope: allScopeUseMap, bundleScope: bundleUsedScopeMap };
}

async function checkAccessToken(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
  let atManager = abilityAccessCtrl.createAtManager();
  let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;

  // 获取应用程序的accessTokenID
  let tokenId: number = 0;
  try {
    let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    tokenId = appInfo.accessTokenId;
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    console.error(`Failed to get bundle info for self. Code is ${err.code}, message is ${err.message}`);
  }

  // 校验应用是否被授予权限
  try {
    grantStatus = await atManager.checkAccessToken(tokenId, permission);
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    console.error(`Failed to check access token. Code is ${err.code}, message is ${err.message}`);
  }
  return grantStatus;
}


export function openPermissionsInSystemSettings(): void {
  let context = GlobalThis.getInstance().getContext('context') as common.UIAbilityContext;
  bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).then((data) => {
    const wantInfo: Want = {
      action: 'action.settings.app.info',
      parameters: {
        settingsParamBundleName: data.name // 打开指定应用的详情页面
      }
    }
    context.startAbility(wantInfo)
  }).catch((err: BusinessError) => {
    console.error(`Failed to get bundleInfo when openPermissionsInSystemSettings. Message is ${err.message}`);
  })

}


export function getBundleUsedPermission(scopeAll: AuthSetting, bundleAll: Map<string, boolean>): BundleScopeResult {
  Object.keys(scopeAll).forEach((key) => {
    const value = scopeAll[key as keyof AuthSetting];
    console.log(key, value);
    // 如果bundleScope存在权限，表示权限有被使用
    if (bundleAll.has(key)) {
      scopeAll[key] = bundleAll.get(key);
    } else {
      scopeAll[key] = false;
    }
  });
  return { allScope: scopeAll, bundleScope: bundleAll }
}

export function getBundleInfoPermissions(): Promise<bundleManager.ReqPermissionDetail[]> {
  return new Promise((resolve, reject) => {
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_REQUESTED_PERMISSION;
    try {
      bundleManager.getBundleInfoForSelf(bundleFlags).then((data) => {
        const permissionInfo = data.reqPermissionDetails;
        console.log(`[TaroWeb] getBundleInfoForSelf successfully. Data: ${JSON.stringify(data)}`);
        resolve(permissionInfo);
      }).catch((err: BusinessError) => {
        console.log(`[TaroWeb] getBundleInfoForSelf failed. Cause: ${err.message}}`);
        resolve([]);
      });
    } catch (err) {
      let message = (err as BusinessError).message;
      console.log(`[TaroWeb] getBundleInfoForSelf failed. Cause: ${message}}`);
      resolve([]);
    }
  });
}
