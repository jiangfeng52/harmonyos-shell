import fs from '@ohos.file.fs'
import { wbLogger } from './Logger';

const FILE_UTIL = 'FileUtil';

export class FileUtils {
  static fileExist(dir: string, fileRelatePath: string): boolean {
    let filePath = `${dir}/${fileRelatePath}`
    return fs.accessSync(filePath)
  }

  static getFileOnResponseWeb(dir: string, fileRelatePath: string): WebResourceResponse {
    let filePath = `${dir}/${fileRelatePath}`

    const file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
    const fd: number = file.fd;

    const responseWeb = new WebResourceResponse();
    const headers: Array<Header> = [
      {
        headerKey: "Connection",
        headerValue: "keep-alive"
      },
      {
        headerKey: "Cache-Control",
        headerValue: "no-cache"
      }
    ]
    let mimeType: string;
    if (filePath.endsWith('.js')) {
      mimeType = "application/javascript";
    }
    else if (filePath.endsWith('.css')) {
      mimeType = "text/css";
    }
    else if (filePath.endsWith('.html') || filePath.endsWith(".htm")) {
      mimeType = "text/html";
    }
    else if (filePath.endsWith('.jpg') || filePath.endsWith('.jpeg')) {
      mimeType = "image/jpeg";
    }
    else if (filePath.endsWith('.png')) {
      mimeType = "image/png";
    }
    else if (filePath.endsWith('.txt')) {
      mimeType = "text/plain";
    }
    else {
      mimeType = "application/octet-stream"; // 默认二进制流
    }
    responseWeb.setResponseHeader(headers)
    responseWeb.setResponseData(fd);
    responseWeb.setResponseEncoding('utf-8')
    responseWeb.setResponseMimeType(mimeType)
    responseWeb.setResponseIsReady(true)
    responseWeb.setResponseCode(200);
    responseWeb.setReasonMessage('OK');
    return responseWeb
  }

  static isSandboxPath(path: string) {
    return path && typeof (path) === 'string' && (path.startsWith('/data/storage/') || path.startsWith('internal://'))
  }

  static isFileUri(path: string) {
    return path && typeof (path) === 'string' && (path.startsWith('file://') || path.startsWith('datashare://'))
  }

  static getFdFromUriOrSandBoxPath(uri: string) {
    try {
      const file = fs.openSync(uri, fs.OpenMode.READ_ONLY)
      return file.fd
    } catch (error) {
      wbLogger.error(FILE_UTIL, `getFdFromUriOrSandBoxPath openSync error:`, error)
    }
    throw new Error('file is not exist')
  }

  static getFileStatFromUri(path: string) {
    const tempFile = fs.openSync(path, fs.OpenMode.READ_ONLY);
    return fs.statSync(tempFile.fd);
  }
}