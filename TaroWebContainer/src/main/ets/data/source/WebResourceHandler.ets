import { taroLogger } from '../../utils/Logger'
import { LocalMiniInfo } from './bean/LocalMiniInfo'
import { MiniLocalFileDataSource } from './local/MiniLocalFileDataSource'
import { MiniRawFileDataSource } from './local/MiniRawFileDataSource'
import { MiniRepository } from './MiniRepository'

const TAG = "WebResourceHandler"

export class WebResourceHandler {
  private currentVersionInfo?: LocalMiniInfo | undefined = undefined

  getFileOnResponseWeb(path: string): WebResourceResponse | undefined {
    if (!path) {
      return undefined
    }
    let biz = MiniRawFileDataSource.getBizByPath(path) //获取业务标识


    // 上次使用的版本要保持不变，否则会出现异常
    if (this.currentVersionInfo) {
      if (this.currentVersionInfo.diskVersionInfo &&
        this.currentVersionInfo.diskVersionInfo.version >= this.currentVersionInfo.rawVersionInfo.version &&
      this.currentVersionInfo.diskVersionInfo.filePath
        && MiniLocalFileDataSource.fileExist(this.currentVersionInfo.diskVersionInfo.filePath, path)) {
        taroLogger.debug(TAG, 'useCurrentDiskCacheResource version=%{public}d path=%{public}s', this.currentVersionInfo.diskVersionInfo.version, path)
        return MiniLocalFileDataSource.getFileOnResponseWeb(this.currentVersionInfo?.diskVersionInfo.version,
          this.currentVersionInfo?.diskVersionInfo.filePath, path)
      }

      // 兜底走rawfile
      if (this.currentVersionInfo.rawVersionInfo.filePath) { // 走App内置的Raw缓存
        let rawPath = MiniRawFileDataSource.rawfileExist(this.currentVersionInfo.rawVersionInfo.filePath, path)
        if (!path || rawPath.trim() === '') {
          return undefined;
        }
        taroLogger.debug(TAG, 'useCurrentRawCacheResource version=%{public}d path=%{public}s', this.currentVersionInfo.rawVersionInfo.version, path)
        return MiniRawFileDataSource.getRawfileOnResponseWeb(this.currentVersionInfo.rawVersionInfo.version, rawPath)
      }
    }


    const latestVerInfo = MiniRepository.getInstance().getMiniInfo(biz)

    if (!latestVerInfo) {
      return undefined
    }

    this.currentVersionInfo = latestVerInfo

    // 优先走本地缓存，本地缓存不存在，走rawfile
    if (latestVerInfo.diskVersionInfo &&
      latestVerInfo.diskVersionInfo.version >= latestVerInfo.rawVersionInfo.version &&
    latestVerInfo.diskVersionInfo.filePath
      && MiniLocalFileDataSource.fileExist(latestVerInfo.diskVersionInfo.filePath, path)) {
      taroLogger.debug(TAG, 'useLatestDiskCacheResource version=%{public}d path=%{public}s', latestVerInfo.diskVersionInfo.version, path)
      return MiniLocalFileDataSource.getFileOnResponseWeb(latestVerInfo.diskVersionInfo.version,
        latestVerInfo.diskVersionInfo.filePath, path)
    }

    // 兜底走rawfile
    if (latestVerInfo.rawVersionInfo.filePath) { // 走App内置的Raw缓存
      let rawPath = MiniRawFileDataSource.rawfileExist(latestVerInfo.rawVersionInfo.filePath, path)
      if (!path || rawPath.trim() === '') {
        return undefined;
      }
      taroLogger.debug(TAG, 'useLatestRawCacheResource version=%{public}d path=%{public}s', latestVerInfo.rawVersionInfo.version, path)
      return MiniRawFileDataSource.getRawfileOnResponseWeb(latestVerInfo.rawVersionInfo.version, rawPath)
    }
    return undefined
  }
}