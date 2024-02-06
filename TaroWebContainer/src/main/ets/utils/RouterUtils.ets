import router from '@ohos.router';
import { wbLogger } from '../utils/Logger';
import { Constant } from '../webrouterservice/common/constant/Constant';
import { WebManager } from '../webrouterservice/webmanager/webManager';

export class RouterUtils {
  static pushUrlWithLog(url: string) {
    router.pushUrl(
      {url: url},
      router.RouterMode.Standard,
      (err)=>{
        if (err) {
          wbLogger.error('pushUrlWithLog',`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
          return;
        }
        wbLogger.info('pushUrlWithLog', 'Invoke pushUrl succeeded.');
      }
    )
  }

  static LoadPageWithWebUrl(webUrl: string) {
    WebManager.getInstance().loadUrl(webUrl);
    router.pushUrl({
      url: Constant.ROUTER_PAGE_URL,
      params: {url: webUrl} },
      router.RouterMode.Standard,
      (err)=>{
        if (err) {
          wbLogger.error('LoadPageWithWebUrl',`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
          return;
        }
        wbLogger.info('LoadPageWithWebUrl', 'Invoke pushUrl succeeded.');
      }
    )
  }
}