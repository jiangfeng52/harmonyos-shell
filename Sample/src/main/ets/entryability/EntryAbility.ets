import UIAbility from '@ohos.app.ability.UIAbility';
import window from '@ohos.window';
import Want from '@ohos.app.ability.Want';
import { wbLogger } from 'web-container';
import { LocalUpdateManagerInstance } from 'web-container/src/main/ets/update/LocalUpdateManager';

const ABILITY_TAG = 'EntryAbility';
const storage = new LocalStorage();

export default class EntryAbility extends UIAbility {
  onCreate(want: Want) {
    wbLogger.info(ABILITY_TAG, '%{public}s', 'Ability onCreate');
    storage.setOrCreate('want', want);
    LocalUpdateManagerInstance.updateMiniOnLaunch(this.context)
  }

  onDestroy() {
    wbLogger.info(ABILITY_TAG, '%{public}s', 'Ability onDestroy');
  }

  onNewWant(want: Want) {
    storage.setOrCreate('want',  want);
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    wbLogger.info(ABILITY_TAG, 'Ability onWindowStageCreate');

    windowStage.getMainWindow((err, data) => {
      if (err.code) {
        wbLogger.error(ABILITY_TAG, `Failed to obtain the main window. Cause: ${JSON.stringify(err)}`);
        return;
      }
      wbLogger.info(ABILITY_TAG, 'Succeeded in obtaining the main window. Data');
    })
    windowStage.loadContent('pages/Index', storage, (err, data) => {
      if (err.code) {
        wbLogger.error(ABILITY_TAG, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      wbLogger.info(ABILITY_TAG, 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    wbLogger.info(ABILITY_TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    wbLogger.info(ABILITY_TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    wbLogger.info(ABILITY_TAG, '%{public}s', 'Ability onBackground');
  }
}
