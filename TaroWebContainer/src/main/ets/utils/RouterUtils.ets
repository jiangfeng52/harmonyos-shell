import router from '@ohos.router';
import { wbLogger } from '../utils/Logger';

export class RouterUtils {
  static pushUrlWithLog(url: string) {
    router.pushUrl(
      {url: url},
      router.RouterMode.Standard,
      (err)=>{
        if (err) {
          wbLogger.error('RouterUtils',`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
          return;
        }
        wbLogger.info('RouterUtils', 'Invoke pushUrl succeeded.');
      }
    )
  }
}