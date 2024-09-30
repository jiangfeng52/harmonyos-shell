import request from '@ohos.request';
import { taroLogger } from '../../../utils/Logger';
import { FileUtils } from '../../../utils/FileUtils';
import { NetworkMiniInfo } from '../bean/NetworkMiniInfo';
import { MiniLocalFileDataSource } from '../local/MiniLocalFileDataSource';

const TAG = 'MiniNetworkDataSource'

export class MiniNetworkDataSource {
  constructor() {
  }

  getDownloadTempPath(context: Context, biz: string, version: number): string {
    return `${context.tempDir}/mini_${biz}_${version.toString()}.zip`
  }

  fetchMiniAndUnzip(context: Context, networkVersionInfo: NetworkMiniInfo): Promise<string> {
    return new Promise<string>(async (resolve: Function, reject: Function) => {
      let tempPath = this.getDownloadTempPath(context, networkVersionInfo.businessName, networkVersionInfo.version)
      await FileUtils.removeFileOrDir(tempPath)
      let downloadConfig: request.DownloadConfig = {
        url: networkVersionInfo.downloadUrl,
        filePath: tempPath,
        title: networkVersionInfo.businessName,
      };
      try {
        let downloadTask = await request.downloadFile(context, downloadConfig)
        downloadTask.on('complete', async () => {
          taroLogger.debug(TAG, '%{public}s download succeed', networkVersionInfo.downloadUrl)
          let fileName = FileUtils.buildMiniFileFormatName(networkVersionInfo.businessName, networkVersionInfo.version)
          let desFileDirPath = `${MiniLocalFileDataSource.getDiskCachePath(context.getApplicationContext())}/${fileName}/`
          FileUtils.mkFilesDir(desFileDirPath)
          FileUtils.unzip(tempPath, desFileDirPath).then(() => {
            FileUtils.removeFileOrDirSync(tempPath)
            resolve(desFileDirPath)
          }).catch((e: Error) => {
            FileUtils.removeFileOrDirSync(tempPath)
            FileUtils.removeFileOrDirSync(desFileDirPath)
            reject(e)
          })
        })
        downloadTask.on('fail', (err: number) => {
          taroLogger.debug(TAG, '%{public}s download error, errCode is %{public}s',
            networkVersionInfo.downloadUrl, err.toString())
          FileUtils.removeFileOrDirSync(tempPath)
          reject(err)
        })
      } catch (err) {
        taroLogger.debug(TAG, '%{public}s download error, err is %{public}s',
          networkVersionInfo.downloadUrl, err.toString())
        FileUtils.removeFileOrDirSync(tempPath)
        reject(err)
      }
    })
  }
}