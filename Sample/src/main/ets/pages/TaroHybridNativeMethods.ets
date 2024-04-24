import common from '@ohos.app.ability.common';
import { RouterToTaroHybrid } from './TaroHybridPage';
import { InjectObject } from '@hybrid/web-container/Index';

interface HarmonyNavigateToOptions {
  indexHtmlPath?: string,
  taroPath?: string
}

export class TaroHybridNativeMethods {
  private context: common.UIAbilityContext
  constructor(uiAbilityContext: common.UIAbilityContext) {
    this.context = uiAbilityContext
  }

  nativeObj: InjectObject = {
    harmonyNavigateTo: (options?: HarmonyNavigateToOptions)=>{
      if(options?.indexHtmlPath) {
        RouterToTaroHybrid({
          indexHtmlPath: options?.indexHtmlPath,
          taroPath: options?.taroPath ?? ""
        })
      }
    }
  };
}


