import http from '@ohos.net.http'
import { wbLogger } from '../../../utils/Logger';
import { MiniRawFileDataSource } from '../local/MiniRawFileDataSource';

export class DebugHttpResult {
  result: ArrayBuffer
  mimeType: string

  constructor(result: ArrayBuffer, mimeType: string ) {
    this.result = result;
    this.mimeType = mimeType
  }
}

export class DebugRequestHostHandlerDataSource {
  async getResource(requestHeader: Array<Header>, url: string): Promise<DebugHttpResult> {

    let httpRequest = http.createHttp();
    return new Promise<DebugHttpResult>((resolve: Function, reject: Function) => {
      httpRequest.request(url, {
        method: http.RequestMethod.GET,
        connectTimeout: 2000,
        readTimeout: 2000,
        maxLimit: 100 * 1024 * 1024,
        header: requestHeader,
        expectDataType: http.HttpDataType.ARRAY_BUFFER
      }).then((data: http.HttpResponse) => {
        wbLogger.debug("CrossOrigin", 'download succeed: %{public}s ', url)
        let ret : DebugHttpResult | null = null
        if (data.result instanceof ArrayBuffer){
          ret = new DebugHttpResult(data.result,MiniRawFileDataSource.getMimetype(url))
        }
        resolve(ret)
      }).catch((err: Error) => {
        wbLogger.debug("CrossOrigin", 'download error: %{public}s , err is %{public}s', url, err.message)
        resolve(null)
      });
    })
  }
}