import common from '@ohos.app.ability.common';
import { RouterToTaroHybrid } from './TaroHybridPage';
import { InjectObject, InjectObjectController } from '@hybrid/web-container/Index';
import { router } from '@kit.ArkUI';

interface NavigateToTaroHybrid {
  indexHtmlPath?: string,
  taroPath?: string
}

interface NavigateToNative {
  url?: string
}

export class TaroHybridNativeMethods implements InjectObjectController {

  onCreate = (indexHtmlPath: string, uiAbilityContext: common.UIAbilityContext) => {
    return {
      navigateToTaroHybrid: (options?: NavigateToTaroHybrid) => {
        if (options?.indexHtmlPath) {
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
    } as InjectObject
  }

  onDestroy = (uiAbilityContext: common.UIAbilityContext) => {
  };
}


