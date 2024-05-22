import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import Want from '@ohos.app.ability.Want';
import { GlobalThis, LocalUpdateManagerInstance, PreCompileConfig, TaroHybridManager } from '@hybrid/web-container';
import common from '@ohos.app.ability.common';
import { TaroHybridNativeMethods } from '../pages/TaroHybridNativeMethods';
import router from '@ohos.router';
import BuildProfile from 'BuildProfile';
import { logger } from '../utils/Logger';

const ABILITY_TAG = 'EntryAbility';
const storage = new LocalStorage();

export default class EntryAbility extends UIAbility {
  onCreate(want: Want) {
    TaroHybridManager.setDebuggable(BuildProfile.DEBUG)
    logger.info(ABILITY_TAG, '%{public}s', 'Ability onCreate');
    storage.setOrCreate('want', want);
    GlobalThis.getInstance().setRawFile('spa')
    LocalUpdateManagerInstance.updateMiniOnLaunch(this.context)
  }

  onDestroy() {
    logger.info(ABILITY_TAG, '%{public}s', 'Ability onDestroy');
  }

  onNewWant(want: Want) {
    storage.setOrCreate('want',  want);
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    logger.info(ABILITY_TAG, 'Ability onWindowStageCreate');

    windowStage.getMainWindow((err, data) => {
      if (err.code) {
        logger.error(ABILITY_TAG, `Failed to obtain the main window. Cause: ${JSON.stringify(err)}`);
        return;
      }
      logger.info(ABILITY_TAG, 'Succeeded in obtaining the main window. Data');
    })
    windowStage.loadContent('pages/Index', storage, (err, data) => {
      TaroHybridManager.init({
        uiAbilityContex: this.context,
        domain: 'https://harmonymini.58.com',
        injectNativeMethod: (indexHtmlPath: string, uiAbilityContext: common.UIAbilityContext) => {
          return new TaroHybridNativeMethods(uiAbilityContext).nativeObj
        },
        rootIndexHtmlPath: "/spa/main/index.html",
        nativeBack: ()=>{
          router.back()
        },
        forceDarkAccess: true,
        precompileConfigsMethod: (index: string) => {
          return [
            new PreCompileConfig("/spa/main/js/app.js", {
              responseHeaders: [
                { headerKey: "E-Tag", headerValue: "aWO42N9P9dG/5xqYQCxsx+vDOoU=" },
                { headerKey: "Last-Modified", headerValue: "Wed, 29 May 2024 10:38:41 GMT" }
              ]
            }, false)
          ]
        }
      })
      TaroHybridManager.preLoader(
        windowStage.getMainWindowSync().getUIContext(),
        "/spa/main/index.html",
        "/pages/index/index"
      )
      if (err.code) {
        logger.error(ABILITY_TAG, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      logger.info(ABILITY_TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    logger.info(ABILITY_TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    logger.info(ABILITY_TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    logger.info(ABILITY_TAG, '%{public}s', 'Ability onBackground');
  }
}
