import { wbLogger } from '../../utils/Logger';
import { RouterStorage } from './RouterStorage';
import { router } from '@kit.ArkUI';
import { Constant } from '../common/constant/Constant';

const TAG: string = 'zhou GlobalRouter'

export class GlobalRouter {
  private static instance: GlobalRouter;

  public static getInstance(): GlobalRouter {
    if (!GlobalRouter.instance) {
      GlobalRouter.instance = new GlobalRouter();
    }
    return GlobalRouter.instance;
  }

  public onBackPress(): boolean {
    const routerStorageInstance = RouterStorage.getInstance();
    let controller = routerStorageInstance.getController();
    let curUrl = controller.webController.getUrl();
    wbLogger.info(TAG, `curUrl = ` + curUrl);

    if (curUrl?.endsWith(Constant.FROM_NATIVE) || curUrl?.endsWith(Constant.END_FIRST_URL)) {
      //web回退到原生
      if (controller.accessBackward()) {
        controller.backward();
      }
      wbLogger.info(TAG, `web回退到原生 `);
      router.back();
      return true;
    } else {
      wbLogger.info(TAG, `web回退到web `);
      if (controller?.accessBackward()) {
        let entries = controller.webController.getBackForwardEntries()
        let backUrl = entries.getItemAtIndex(entries.size - 2).historyUrl
        if (backUrl === 'resource://rawfile/index.html#/pages/component/index/index' || backUrl === 'resource://rawfile/index.html#/pages/api/index/index') {
          AppStorage.setOrCreate('tabBarVisible', true)
        }
        controller?.backward();
        return true;
      }
      return false;
    }
  }
}