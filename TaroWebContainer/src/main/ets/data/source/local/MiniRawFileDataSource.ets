import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import { taroLogger } from '../../../utils/Logger';
import { LocalMiniInfo } from '../bean/LocalMiniInfo';
import { FileUtils } from '../../../utils/FileUtils';
import { MiniLocalFileDataSource } from './MiniLocalFileDataSource';
import resourceManager from '@ohos.resourceManager';
import { GlobalThis } from '../../../utils/GlobalThis';

const TAG = 'MiniRawFileDataSource'

export class MiniRawFileDataSource {
  constructor() {
  }

  /**
   * 异步拷贝raw文件到磁盘应用文件目录并解压
   * @param context
   * @returns
   */
  async copyMiniRawUnzipDisk(context: common.ApplicationContext, versionInfo: LocalMiniInfo): Promise<LocalMiniInfo> {
    let fileName = FileUtils.buildMiniFileFormatName(versionInfo.businessName, versionInfo.rawVersionInfo.version)
    let desFileDirPath = `${MiniLocalFileDataSource.getDiskCachePath(context)}/${fileName}`
    let result = await this.copyRawFilesToDisk(context, versionInfo.rawVersionInfo.filePath, desFileDirPath)
    if (result) {
      let path = result ? desFileDirPath : '';
      versionInfo.diskVersionInfo = {
        version: versionInfo.rawVersionInfo.version,
        filePath: path
      }
    }
    return versionInfo
  }

  getRawCachePath(fileName: string) {
    let rawFile = GlobalThis.getInstance().getRawFile();
    return `${rawFile}/${fileName}`
  }

  getRawMiniList(context: common.ApplicationContext): Array<string> {
    let rawFile = GlobalThis.getInstance().getRawFile();
    return context.resourceManager.getRawFileListSync(rawFile);
  }

  async copyRawFilesToDisk(context: common.ApplicationContext, src: string, dest: string): Promise<boolean> {
    taroLogger.debug(TAG, `Directory copy start from %{public}s to %{public}s`, src, dest);
    let entries: Array<string> | null = null
    try {
      // 目前没有直接判断是rawFile文件目录下的文件类型：目录还是文件，暂时依靠try catch
      // 若是目录不崩溃，若是文件则会报异常
      entries = await context.resourceManager.getRawFileList(src);
      // 创建目标目录
      FileUtils.mkFilesDir(dest)
    } catch (error) {
      entries = null
      taroLogger.debug(TAG, `${src} is not dir，It should be a file，Target dest is ${dest}`);
    }
    taroLogger.debug(TAG, `Directory copy start from %{public}s to %{public}s,length = %{public}s`, src, dest,
      `${entries?.length}`);
    if (entries != null && entries?.length >= 1) {
      for (const entry of entries) {
        // 拼接完整的源路径和目标路径
        let srcPath = src + "/" + entry;
        let destPath = dest + "/" + entry;
        // 新文件目录，递归调用函数自身
        await this.copyRawFilesToDisk(context, srcPath, destPath);
      }
    } else {
      // 如果是文件，直接复制到目标路径
      return await this.copyRawFileToDisk(context, src, dest)
    }
    return true
  }


  /**
   * 拷贝文件
   * @param context
   * @param src
   * @param dest
   * @returns
   */
  async copyRawFileToDisk(context: common.ApplicationContext, src: string, dest: string): Promise<boolean> {
    taroLogger.debug(TAG, `Directory copying from %{public}s to %{public}s`, src, dest);
    try {
      let content = await context.resourceManager.getRawFileContent(src);
      let file = await fs.open(dest, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      await fs.write(file.fd, content.buffer)
      taroLogger.debug(TAG, `Directory copied success from %{public}s to %{public}s`, src, dest);
      return true
    } catch (err) {
      taroLogger.error(TAG,
        " Directory copying failed" + src + " to " + dest + " with error message: " + err.message + ", error code: " +
        err.code);
      // } finally {
      //   if (file != undefined) {
      //     fs.closeSync(file);
      //   }
      return true;
    }
  }

  static rawfileExist(rawPath: string, path: string): string {
    let filePath = ''
    if (path.startsWith("/")) {
      filePath = `${rawPath}${path}`
    } else {
      filePath = `${rawPath}/${path}`
    }
    let rawFd: resourceManager.RawFileDescriptor | undefined;
    try {
      rawFd = getContext().resourceManager.getRawFdSync(filePath)
      if (rawFd) {
        return filePath
      }
    } catch (e) {
      taroLogger.warn('RawUtils', `rawfileExist ${filePath} did't internal ${e}`)
    }
    return ''
  }

  static getRawfileOnResponseWeb(lastVersion: number, file: string): WebResourceResponse {
    const responseWeb = new WebResourceResponse();
    const headers: Array<Header> = [
      { headerKey: "ResponseDataID", headerValue: lastVersion.toString() }
    ]
    let mimeType: string = FileUtils.getMimetype(file);
    responseWeb.setResponseHeader(headers)
    responseWeb.setResponseData($rawfile(file));
    responseWeb.setResponseEncoding('utf-8')
    responseWeb.setResponseMimeType(mimeType)
    responseWeb.setResponseIsReady(true)
    responseWeb.setResponseCode(200);
    responseWeb.setReasonMessage('OK');
    return responseWeb
  }

  static getBizByPath(path: string): string {
    let biz = ''
    let rawFile = GlobalThis.getInstance().getRawFile();
    let start = `${rawFile}/`
    let start2 = `/${rawFile}/`
    if (path.startsWith(start) || path.startsWith(start2)) {
      let splits = path.split("/")
      if (splits && splits.length > 1) {
        biz = splits[1]
      }
    }
    return biz
  }
}