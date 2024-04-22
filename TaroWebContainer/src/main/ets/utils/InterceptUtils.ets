import { FileUtils } from './FileUtils';
import { wbLogger } from './Logger';
import { http } from '@kit.NetworkKit';

const HTTP_TIMEOUT = 3000;

export class InterceptUtils{

  /**
   * 本地请求数据，将结果包装成WebResourceResponse返回
   * @param url
   * @param request
   * @returns
   */
  static getWebResourceResponse(url:string,request: WebResourceRequest) : WebResourceResponse{
    let responseWeb = new WebResourceResponse();
    responseWeb.setResponseHeader(request.getRequestHeader())
    responseWeb.setResponseIsReady(false)
    FileUtils.getFileResponseFromUrl(url,HTTP_TIMEOUT,http.HttpDataType.ARRAY_BUFFER).then(ret => {
      wbLogger.debug("CrossOrigin", 'download result : %{public}s ,code:%{public}s', url,`${ret.responseCode}`)
      responseWeb.setResponseCode(ret.responseCode);
      responseWeb.setReasonMessage(ret.result === http.ResponseCode.OK ? 'OK' : 'http.get resource failed');
      if (ret.result instanceof ArrayBuffer) {
        responseWeb.setResponseData(ret.result);
      }
      responseWeb.setResponseEncoding('utf-8')
      responseWeb.setResponseMimeType(FileUtils.getMimetype(url))
      responseWeb.setResponseIsReady(true)
      return responseWeb
    }).catch((err: Error) => {
      wbLogger.debug("CrossOrigin", 'download error: %{public}s , err is %{public}s', url, err.message)
      responseWeb.setResponseCode(0);
      responseWeb.setReasonMessage(err.message);
      responseWeb.setResponseIsReady(true)
      return responseWeb
    });

    return responseWeb
  }

}