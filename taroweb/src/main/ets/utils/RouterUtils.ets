import router from '@ohos.router'

export class RouterUtils {
  static pushUrlWithLog(url: string) {
    router.pushUrl(
      {url: url},
      router.RouterMode.Standard,
      (err)=>{
        if (err) {
          console.error(`Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
          return;
        }
        console.info('Invoke pushUrl succeeded.');
      }
    )
  }
}