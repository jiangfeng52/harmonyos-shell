import http from '@ohos.net.http'
import { request } from '@kit.BasicServicesKit';
import { wbLogger } from '../../../utils/Logger';
import { FileUtils } from '../../../utils/FileUtils';

export class CORSHelperDataSource {
  async downloadResource(context: Context, url: string): Promise<string> {
    if(url.search("https") != -1){
      url = url.replace("https","http")
    }
    wbLogger.debug("CrossOrigin","下载资源地址: "+url);
    return new Promise<string>((resolve: Function, reject: Function) => {
      let tempPath = this.getDownloadTempPath(context, url)

      let downloadConfig: request.DownloadConfig = {
        url: url,
        filePath: tempPath,
        title: 'downloading...',
        background: true
      };
      request.downloadFile(context, downloadConfig)
        .then((downloadTask: request.DownloadTask) => {
          downloadTask.on('complete', () => {
            wbLogger.debug("CrossOrigin", 'download succeed: %{public}s ', url)
            resolve(tempPath)
          })
          downloadTask.on('fail', (err: number) => {
            wbLogger.debug("CrossOrigin", 'download error: %{public}s , errCode is %{public}s', url, err.toString())
            FileUtils.delTempFile(tempPath)
            resolve(null)
          })
        })
        .catch((err: Object) => {
          wbLogger.debug("CrossOrigin", 'download error: %{public}s , err is %{public}s', url, err.toString())
          FileUtils.delTempFile(tempPath)
          resolve(null)
        })
    })
  }

  getDownloadTempPath(context: Context, fileName: string): string {
    const arr = fileName.split("/")
    fileName = new Date().getTime() + "_" + arr[arr.length - 1]
    return `${context.tempDir}/${fileName}`
  }
}