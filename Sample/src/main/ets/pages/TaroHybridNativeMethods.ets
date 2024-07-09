import common from '@ohos.app.ability.common';
import { RouterToTaroHybrid } from './TaroHybridPage';
import { InjectObject } from '@hybrid/web-container/Index';
import { router } from '@kit.ArkUI';

interface NavigateToTaroHybrid {
  indexHtmlPath?: string,
  taroPath?: string
}

interface NavigateToNative {
  url?: string
}

export class TaroHybridNativeMethods {
  private context: common.UIAbilityContext
  constructor(uiAbilityContext: common.UIAbilityContext) {
    this.context = uiAbilityContext
  }

  nativeObj: InjectObject = {
    navigateToTaroHybrid: (options?: NavigateToTaroHybrid)=>{
      if(options?.indexHtmlPath) {
        RouterToTaroHybrid({
          indexHtmlPath: options?.indexHtmlPath,
          taroPath: options?.taroPath ?? ""
        })
      }
    },
    navigateToNative: (options?: NavigateToNative) => {
      if (options?.url) {
        router.pushUrl({
          url: options?.url//'pages/WebContainerPage',
        }, router.RouterMode.Standard)
      }
    }
  };
}


