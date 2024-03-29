import fs from '@ohos.file.fs'
import { wbLogger } from './Logger';

const FILE_UTIL = 'FileUtil';
const MINI_NAME_SPE = '@'
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
      wbLogger.error(FILE_UTIL, `getFdFromUriOrSandBoxPath openSync error:`, error)
    }
    throw new Error('file is not exist')
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
      wbLogger.error(FILE_UTIL, `Mini rawFile name is not standard : ${fileName}，Please use the format ：业务名称@版本号`);
    }
    return null
  }

  static buildMiniFileFormatName(name:string, version:string) : string{
    return `${name}@${version}`
  }

  static delTempFile(tempPath: string) {
    if (!fs.accessSync(tempPath)) {
      return
    }
    fs.unlinkSync(tempPath)
  }

  static mkFilesDir(filePath:string){
    try {
      if (!fs.accessSync(filePath)) {
        fs.mkdirSync(filePath,true)
      }
    }catch (e){
      wbLogger.error(FILE_UTIL, `mkFilesDir failed:`, e);
    }
  }


}