import request from '@ohos.request'
import { taroLogger } from '../../../utils/Logger';
import { NetworkTask, NetworkTaskStatus } from '../bean/NetworkTask';
import { FileUtils } from '../../../utils/FileUtils';

export class MiniNetworkDataSource {
  constructor() {
  }

  getDownloadTempPath(context: Context, version: number): string {
    return `${context.tempDir}/mini_${version.toString()}.zip`
  }

  async fetchMini(context: Context, version: number, url: string): Promise<string> {
    return new Promise<string>((resolve: Function, reject: Function) => {
      let tempPath = this.getDownloadTempPath(context, version)

      let downloadConfig: request.DownloadConfig = {
        url: url,
        filePath: tempPath,
        title: '小程序更新中...',
        background: true
      };
      request.downloadFile(context, downloadConfig)
        .then((downloadTask: request.DownloadTask) => {
          downloadTask.on('complete', () => {
            taroLogger.debug("UpdateManager", '%{public}s download succeed', url)
            resolve(tempPath)
          })
          downloadTask.on('fail', (err: number) => {
            taroLogger.debug("UpdateManager", '%{public}s download error, errCode is %{public}s', url, err.toString())
            FileUtils.delTempFile(tempPath)
            resolve(null)
          })
        })
        .catch((err: Object) => {
          taroLogger.debug("UpdateManager", '%{public}s download error, err is %{public}s', url, err.toString())
          FileUtils.delTempFile(tempPath)
          resolve(null)
        })
    })
  }
}