import zlib from '@ohos.zlib'
import { BusinessError } from '@ohos.base'
import { taroLogger } from '../../../utils/Logger'
import fs from '@ohos.file.fs'
import { LocalVersionInfo } from '../bean/LocalVersionInfo'
import { UpdateConfig } from '../bean/UpdateConfig'
import { FileUtils } from '../../../utils/FileUtils'
import common from '@ohos.app.ability.common';
import { ArrayList } from '@kit.ArkTS'

const DISK_PATH = 'update'
export class MiniLocalFileDataSource {
  constructor() {
  }

  readDiskLastMiniBizInfo(context: Context, biz:string): LocalVersionInfo {
    let miniPath = this.getLocalPath(context)
    let localVersionInfo = new LocalVersionInfo(UpdateConfig.getInstance().getInitialVersion(),biz)
    let files = fs.listFileSync(miniPath, { recursion: false, listNum: 0 })
    if (files && files?.length != 0) {
      let filenames = new Array<string>()
      for (let index = 0; index < files.length; index++) {
        const element = files[index];
        if (element.startsWith(biz)) {
          filenames.push(element)
        }
      }
      taroLogger.debug("LocalUpdateManager", `filenames length is ${filenames.length}`)
      let filesLength = filenames.length
      if (filesLength==1) {
        let splits = FileUtils.checkMiniFileNameFormat(filenames[0])
        if (splits) {
          localVersionInfo.localVersion = splits[1]
          localVersionInfo.diskCachePath = `${miniPath}/${filenames[0]}`
        }
        return localVersionInfo
      }else if (filenames.length > 1) {
        const versionCompareFunc = UpdateConfig.getInstance().getCompareVersionFunc()
        filenames.sort((a, b) => {
          if (versionCompareFunc(a, b)) {
            //正序排列
            return 1
          }
          return -1
        })
        if (filenames.length === 2) {
          //保证在下载前只有一个版本
          FileUtils.removeFileOrDirSync(`${miniPath}/${filenames[0]}`)
        }
        let splits = filenames[filenames.length-1].split('@');
        if (splits&&splits?.length>1) {
          localVersionInfo.localVersion = splits[1]
        }else{
          localVersionInfo.localVersion = '0'
        }
        localVersionInfo.diskCachePath = `${miniPath}/${filenames[filenames.length-1]}`
        return localVersionInfo
      }
    }
    return localVersionInfo
  }


  getLocalPath(context: Context):string{
    let miniPath = `${context.filesDir}/${DISK_PATH}`
    if (!fs.accessSync(miniPath)) {
      fs.mkdirSync(miniPath)
    }
    return miniPath
  }

  saveAndUnzip(context: Context, version: number, filePath: string): Promise<string> {
    return new Promise<string>((resolve: Function, reject: Function) => {
      try {
        let options: zlib.Options = {
          level: zlib.CompressLevel.COMPRESS_LEVEL_DEFAULT_COMPRESSION,
          memLevel: zlib.MemLevel.MEM_LEVEL_DEFAULT,
          strategy: zlib.CompressStrategy.COMPRESS_STRATEGY_DEFAULT_STRATEGY
        }
        //TODO-JasonZhang 设置解压路径
        let savePath = ""
        // let savePath = this.getLocalPath(context, version)

        zlib.decompressFile(filePath, savePath, options, (errData) => {
          if (errData !== null) {
            taroLogger.debug("UpdateManager", '%{public}s decompressFile failed. code is %{public}d, message is %{public}s', filePath, errData.code, errData.message)
          } else {
            taroLogger.debug("UpdateManager", '%{public}s decompressFile success. decompressPath is %{public}s', filePath, savePath)
          }
          FileUtils.removeFileOrDirSync(filePath)
          resolve(errData == null ? savePath : '')
        })
      } catch (errData) {
        let code = (errData as BusinessError).code;
        let message = (errData as BusinessError).message;
        taroLogger.debug("UpdateManager", '%{public}s decompressFile failed. code is %{public}d, message is %{public}s', filePath, code, message)
        FileUtils.removeFileOrDirSync(filePath)
        resolve('')
      }
    })
  }
  /**
   * 获取缓存空间目录
   * @param context
   * @returns
   */
  static getDiskPath(context: common.Context): string {
    let path = `${context.filesDir}/update`
    return path;
  }

  static fileExist(dir: string, fileRelatePath: string): boolean {
    let filePath = ''
    if (fileRelatePath.startsWith("/")) {
      filePath = `${dir}${fileRelatePath}`
    }else{
      filePath = `${dir}/${fileRelatePath}`
    }
    return fs.accessSync(filePath)
  }

  static getFileOnResponseWeb(lastVersion: string, dir: string, fileRelatePath: string): WebResourceResponse {
    let filePath = `${dir}/${fileRelatePath}`

    const file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
    const fd: number = file.fd;

    const responseWeb = new WebResourceResponse();
    const headers: Array<Header> = [
      {headerKey: "ResponseDataID", headerValue: lastVersion}
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

  static replaceFileContents(diskCachePath: string | undefined, fileRelatePath: string, content: string) {
    if (!diskCachePath) {
      return
    }
    let filePath = `${diskCachePath}/${fileRelatePath}`
    const file = fs.openSync(filePath, fs.OpenMode.READ_WRITE);
    fs.writeSync(file.fd, content)
    fs.closeSync(file);
  }

}