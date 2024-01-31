import { wbLogger } from '../../utils/Logger';
import { WebManager } from '../webmanager/WebManager';
import { RouterStorage } from './RouterStorage';
import { PageManager } from '../pagemanager/PageManager';
import { BusinessError } from '@kit.BasicServicesKit';
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
    PageManager.getInstance().addUrl(routerUrl);
    wbLogger.info(TAG, `拦截，url = ` + routerUrl);
    return true;
  }

  public onBackPress(): boolean {
    const routerStorageInstance = RouterStorage.getInstance();
    let urlLength = routerStorageInstance.getRouteNodesSize();
    let controller = routerStorageInstance.getController();
    let curUrl = PageManager.getInstance().gerCurrentUrl();
    if (urlLength > 0) {
      try{
        if (controller?.accessForward()) {
          wbLogger.info(TAG, `web 回退到 web`);
          PageManager.getInstance().removeUrl(curUrl);
          controller?.backward();
          return true;
        }
      } catch (error) {
        wbLogger.info(TAG, `ErrorCode: ${(error as BusinessError).message}`);
      }
      PageManager.getInstance().removeUrl(curUrl);
      WebManager.getInstance().getWebInstanceIds(curUrl, controller!);
      router.back();
      return true;
    }
    return false;
  }

}