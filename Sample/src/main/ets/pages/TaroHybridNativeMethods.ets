import common from '@ohos.app.ability.common';
import { RouterToTaroHybrid } from './TaroHybridPage';
import { InjectObject, apiCustomDialogManager } from '@hybrid/web-container/Index';
import { promptAction } from '@kit.ArkUI';

interface HarmonyNavigateToOptions {
  indexHtmlPath?: string,
  taroPath?: string
}

const customPermissionPrompt = (permissionName: ESObject) => {
  promptAction.showToast({
    message: `请开启${permissionName.name}权限`
  })
}

export class TaroHybridNativeMethods {
  private context: common.UIAbilityContext
  constructor(uiAbilityContext: common.UIAbilityContext) {
    this.context = uiAbilityContext
  }

  nativeObj: InjectObject = {
    harmonyNavigateTo: (options?: HarmonyNavigateToOptions) => {
      if (options?.indexHtmlPath) {
        RouterToTaroHybrid({
          indexHtmlPath: options?.indexHtmlPath,
          taroPath: options?.taroPath ?? ""
        })
      }
    }
  };
}

apiCustomDialogManager.registerMethodsBuilder(customPermissionPrompt)
