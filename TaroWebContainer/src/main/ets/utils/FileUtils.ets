import fs from '@ohos.file.fs';
import { taroLogger } from './Logger';
import { http } from '@kit.NetworkKit';

const FILE_UTIL = 'FileUtil';
const MINI_NAME_SPE = '@'
const HTTP_TIMEOUT = 2000;
export class FileUtils {
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
      taroLogger.error(FILE_UTIL, `getFdFromUriOrSandBoxPath openSync error:`, error)
    }
    throw new Error('file is not exist')
  }

  static getFileResponseFromUrl( url: string,timeout?: number,expectDataType?: http.HttpDataType): Promise<http.HttpResponse>{
    let httpRequest = http.createHttp();
    return httpRequest.request(url,{
      method: http.RequestMethod.GET,
      connectTimeout: timeout?? HTTP_TIMEOUT,
      readTimeout: timeout?? HTTP_TIMEOUT,
      maxLimit: 100 * 1024 * 1024, //最大支持100M
      expectDataType:expectDataType ?? http.HttpDataType.STRING
    })
  }

  static getMimetype(fileName: string) {
    let mimeType: string;
    if (fileName.endsWith('.js')) {
      mimeType = "application/javascript";
    }
    else if (fileName.endsWith('.css')) {
      mimeType = "text/css";
    }
    else if (fileName.endsWith('.html') || fileName.endsWith(".htm")) {
      mimeType = "text/html";
    }
    else if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
      mimeType = "image/jpeg";
    }
    else if (fileName.endsWith('.png')) {
      mimeType = "image/png";
    }
    else if (fileName.endsWith('.txt')) {
      mimeType = "text/plain";
    }
    else {
      mimeType = "application/octet-stream"; // 默认二进制流
    }
    return mimeType;
  }

  static getFileStatFromUri(path: string) {
    const tempFile = fs.openSync(path, fs.OpenMode.READ_ONLY);
    return fs.statSync(tempFile.fd);
  }
  static checkMiniFileNameFormat(fileName:string): string[] |null{
    let splits = fileName.split(MINI_NAME_SPE)
    if (splits && splits.length>1) {
      return splits
    }else{
      taroLogger.error(FILE_UTIL, `Mini rawFile name is not standard : ${fileName}，Please use the format ：业务名称@版本号`);
    }
    return null
  }

  static buildMiniFileFormatName(name:string, version:string) : string{
    return `${name}@${version}`
  }

  static removeFileOrDirSync(path: string) {
    if (!fs.accessSync(path)) {
      return
    }
    if (fs.statSync(path).isDirectory()) {
      fs.rmdirSync(path)
    } else {
      fs.unlinkSync(path)
    }
  }

  static mkFilesDir(filePath:string){
    try {
      if (!fs.accessSync(filePath)) {
        fs.mkdirSync(filePath,true)
      }
    }catch (e){
      taroLogger.error(FILE_UTIL, `mkFilesDir failed:`, e);
    }
  }


}