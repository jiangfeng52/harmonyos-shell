import router from '@ohos.router';
import { taroLogger } from '../utils/Logger';

export class RouterUtils {
  static pushUrlWithLog(url: string) {
    router.pushUrl(
      {url: url},
      router.RouterMode.Standard,
      (err)=>{
        if (err) {
          taroLogger.error('RouterUtils',`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
          return;
        }
        taroLogger.info('RouterUtils', 'Invoke pushUrl succeeded.');
      }
    )
  }
}