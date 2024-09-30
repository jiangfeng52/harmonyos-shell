import { taroLogger } from '../../../utils/Logger'
import fs from '@ohos.file.fs'
import { VersionInfo } from '../bean/LocalMiniInfo'
import { FileUtils } from '../../../utils/FileUtils'
import common from '@ohos.app.ability.common'

const DISK_PATH = 'taro_resources'
export class MiniLocalFileDataSource {
  constructor() {
  }

  readDiskLastMiniBizInfo(context: common.ApplicationContext, biz:string): VersionInfo {
    let miniPath = MiniLocalFileDataSource.getDiskCachePath(context)
    let diskVersionInfo: VersionInfo = {
      version: 0,
      filePath: ''
    }
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
          diskVersionInfo.version = parseInt(splits[1]) || 0
          diskVersionInfo.filePath = `${miniPath}/${filenames[0]}`
        }
        return diskVersionInfo
      }else if (filenames.length > 1) {
        filenames.sort((a, b) => {
          try {
            let version1 = parseInt(a.split('@')[1])
            let version2 = parseInt(b.split('@')[1])
            return version1 < version2 ? -1 : 1
          } catch (e) {
          }
          return -1
        })
        if (filenames.length === 2) {
          //保证在下载前只有一个版本
          FileUtils.removeFileOrDirSync(`${miniPath}/${filenames[0]}`)
        }
        let splits = filenames[filenames.length-1].split('@');
        if (splits&&splits?.length>1) {
          diskVersionInfo.version = parseInt(splits[1]) || 0
        }else{
          diskVersionInfo.version = 0
        }
        diskVersionInfo.filePath = `${miniPath}/${filenames[filenames.length-1]}`
        return diskVersionInfo
      }
    }
    return diskVersionInfo
  }


  /**
   * 获取缓存空间目录
   * @param context
   * @returns
   */
  static getDiskCachePath(context: common.ApplicationContext):string{
    let miniPath = `${context.filesDir}/${DISK_PATH}`
    if (!fs.accessSync(miniPath)) {
      fs.mkdirSync(miniPath)
    }
    return miniPath
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

  static getFileOnResponseWeb(lastVersion: number, dir: string, fileRelatePath: string): WebResourceResponse {
    let filePath = `${dir}/${fileRelatePath}`

    const file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
    const fd: number = file.fd;

    const responseWeb = new WebResourceResponse();
    const headers: Array<Header> = [
      {headerKey: "ResponseDataID", headerValue: lastVersion.toString()}
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