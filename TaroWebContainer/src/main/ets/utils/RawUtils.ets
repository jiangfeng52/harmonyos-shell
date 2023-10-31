import resourceManager from '@ohos.resourceManager';
import { Logger } from './Logger';

export class RawUtils {
  static rawfileExist(file: string): boolean{
    let rawFd: resourceManager.RawFileDescriptor | undefined;
    try {
      rawFd = getContext().resourceManager.getRawFdSync(file)
      if (rawFd) {
        return true
      }
    } catch (e) {
      Logger.log(`rawfileExist ${file} did't internal ${e}`)
    }
    return false
  }

  static getRawfileOnResponseWeb(file: string): WebResourceResponse{
    const responseWeb = new WebResourceResponse();
    const headers: Array<Header> = [
      {
        headerKey:"Connection",
        headerValue:"keep-alive"
      },
      {
        headerKey:"Cache-Control",
        headerValue:"no-cache"
      }
    ]
    let mimeType: string;
    if (file.endsWith('.js')) {
      mimeType = "application/javascript";
    }
    else if(file.endsWith('.css')){
      mimeType = "text/css";
    }
    else if(file.endsWith('.html') || file.endsWith(".htm")) {
      mimeType = "text/html";
    }
    else if(file.endsWith('.jpg') || file.endsWith('.jpeg')){
      mimeType = "image/jpeg";
    }
    else if(file.endsWith('.png')){
      mimeType = "image/png";
    }
    else if(file.endsWith('.txt')){
      mimeType = "text/plain";
    }
    else {
      mimeType = "application/octet-stream"; // 默认二进制流
    }
    responseWeb.setResponseHeader(headers)
    responseWeb.setResponseData($rawfile(file));
    responseWeb.setResponseEncoding('utf-8')
    responseWeb.setResponseMimeType(mimeType)
    responseWeb.setResponseIsReady(true)
    responseWeb.setResponseCode(200);
    responseWeb.setReasonMessage('OK');
    return responseWeb
  }
}