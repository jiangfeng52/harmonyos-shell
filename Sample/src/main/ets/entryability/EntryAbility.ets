import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import Want from '@ohos.app.ability.Want';
import { GlobalThis, LocalUpdateManagerInstance, TaroHybridManager } from '@hybrid/web-container';
import common from '@ohos.app.ability.common';
import { TaroHybridNativeMethods } from '../pages/TaroHybridNativeMethods';
import router from '@ohos.router';
import BuildProfile from 'BuildProfile';
import { logger } from '../utils/Logger';
import { BusinessError } from '@kit.BasicServicesKit';
import { WindowUtil } from '../utils/WindowUtil';
const ABILITY_TAG = 'EntryAbility';
const storage = new LocalStorage();

export default class EntryAbility extends UIAbility {
  onCreate(want: Want) {
    TaroHybridManager.setDebuggable(BuildProfile.DEBUG)
    TaroHybridManager.setCustomUserAgent('WUBA (Phone; OpenHarmony)')
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

    // 设置屏幕方案
    WindowUtil.getInstance()
    ?.setWindowStage(windowStage)
    ?.setMainWindowPortrait();

    windowStage.loadContent('pages/Index', storage, (err, data) => {

      let windowClass: window.Window = windowStage.getMainWindowSync(); // 获取应用主窗口
      // 1. 设置窗口全屏
      windowClass.setWindowLayoutFullScreen(true)
        .then(() => {
          console.info('Succeeded in setting the window layout to full-screen mode.');
        })
        .catch((err: BusinessError) => {
          console.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
        });

      TaroHybridManager.init({
        uiAbilityContext: this.context,
        domain: 'http://domain',
        injectNativeMethod: (indexHtmlPath: string, uiAbilityContext: common.UIAbilityContext) => {
          return new TaroHybridNativeMethods(uiAbilityContext).nativeObj
        },
        rootIndexHtmlPath: "/spa/main/index.html",
        nativeBack: ()=>{
          router.back()
        },
        forceDarkAccess: true,
        windowClass,
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
