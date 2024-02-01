import { wbLogger } from '../../utils/Logger';
import { WebManager } from '../webmanager/WebManager';
import { RouterStorage } from './RouterStorage';
import { PageManager } from '../pagemanager/PageManager';
import { router } from '@kit.ArkUI';

const TAG: string = 'zhou GlobalRouter'

export class GlobalRouter {
  private static instance: GlobalRouter;

  public static getInstance(): GlobalRouter {
    if (!GlobalRouter.instance) {
      GlobalRouter.instance = new GlobalRouter();
    }
    return GlobalRouter.instance;
  }

  public router(data: WebResourceRequest): boolean {
    let routerUrl: string = data.getRequestUrl();
    let routeStorageInstance: RouterStorage = RouterStorage.getInstance()
    if (routeStorageInstance.getCurrentNodeUrl() === routerUrl) {
      wbLogger.info(TAG, `相同url 不拦截，url = ` + routerUrl);
      return false;
    }
    wbLogger.info(TAG, `拦截，url = ` + routerUrl);
    return true;
  }

  public onBackPress(): boolean {
    const routerStorageInstance = RouterStorage.getInstance();
    let controller = routerStorageInstance.getController();
    let curUrl = PageManager.getInstance().getCurrentUrl();
    let curUrl2 = PageManager.getInstance().getCurrentUrl2();
    wbLogger.info(TAG, `curUrl = ` + curUrl);

    if (curUrl === '') {
      //原生回退到web
      if (curUrl2 !== null) {
        wbLogger.info(TAG, `原生回退到web curUrl2 = ` + curUrl2);
        PageManager.getInstance().removeCurrentUrl();
        let Domin = 'resource://rawfile/index.html#';
        if (curUrl2 == 'resource://rawfile/index.html') {
          controller.loadUrl(curUrl2);
        } else {
          controller.loadUrl(Domin + curUrl2);
        }
        router.back();
        return true;
      }
      wbLogger.info(TAG, `原生回退到原生 `);
      return false;
    } else {
      if (curUrl2 === '') {
        wbLogger.info(TAG, `web回退到原生 `);
        router.back();
      } else {
        wbLogger.info(TAG, `web回退到web `);
        controller?.backward();
      }
      PageManager.getInstance().removeCurrentUrl()
      return true;
    }
  }
}