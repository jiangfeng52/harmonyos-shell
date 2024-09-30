import { LocalMiniInfo } from '../data/source/bean/LocalMiniInfo';
import { MiniRepository } from '../data/source/MiniRepository';
import { UpdateManager } from './UpdateManager';
import { taroLogger } from '../utils/Logger';
import { GlobalThis } from '../utils/GlobalThis';
import { NetworkMiniInfo } from '../data/source/bean/NetworkMiniInfo';
import { MiniNetworkDataSource } from '../data/source/network/MiniNetworkDataSource';
import { JSON } from '@kit.ArkTS';
import { common } from '@kit.AbilityKit';

const TAG = "DiskCacheUpdateManager"

class DiskCacheUpdateManager extends UpdateManager {
  private miniNetworkDataSource: MiniNetworkDataSource;
  private diskCacheUpdated = false
  private getNeedUpdateNetworkInfos?: (localVersions: Array<LocalMiniInfo>) => Promise<Array<NetworkMiniInfo> | undefined> =
    undefined

  constructor() {
    super()
    this.miniNetworkDataSource = new MiniNetworkDataSource()
  }

  updateDiskCache(context: common.UIAbilityContext) {
    if (GlobalThis.getInstance().getDiskUpdateEnable()) {
      this.updateDiskCacheFromRaw(context)
      this.getNeedUpdateNetworkInfos && this.updateDiskCacheFromNetwork(context.getApplicationContext(), this.getNeedUpdateNetworkInfos)
    }
  }

  updateDiskCacheFromRaw(context: common.UIAbilityContext) {
    if (GlobalThis.getInstance().getDiskUpdateEnable()) {
      taroLogger.debug('DiskCacheUpdateManager', `updateDiskCacheFromRaw start`);
      try {
        let miniInfos = MiniRepository.getInstance().getMiniInfoMap()
        miniInfos.forEach((miniInfo, key) => {
          if (miniInfo) {
            this.updateDiskSingleMini(context, miniInfo)
            taroLogger.debug(TAG,
              `VersionInfo miniInfo ${JSON.stringify(miniInfo)}`);
            taroLogger.debug(TAG, `updateDiskCacheFromRaw success`);
          }
        })
        this.diskCacheUpdated = true
      } catch (e) {
        taroLogger.error(TAG, 'updateDiskCacheFromRaw Error :', e);
      }
    }
  }

  updateDiskCacheFromNetwork(context: common.ApplicationContext,
    getNeedUpdateNetworkInfos: (localVersions: Array<LocalMiniInfo>) => Promise<Array<NetworkMiniInfo> | undefined>) {

    if (!this.diskCacheUpdated || !GlobalThis.getInstance().getDiskUpdateEnable()) {
      this.getNeedUpdateNetworkInfos = getNeedUpdateNetworkInfos
      return
    }

    let miniInfos = MiniRepository.getInstance().getMiniInfoMap()
    let miniArray: Array<LocalMiniInfo> = []
    miniInfos.forEach((miniInfo, key) => {
      if (miniInfo) {
        miniArray.push(miniInfo)
      }
    })
    if (miniArray.length === 0) {
      return
    }
    getNeedUpdateNetworkInfos(miniArray).then((value?: Array<NetworkMiniInfo>) => {
      value?.forEach(async (networkVersionInfo) => {
        try {
          // 下载并解压
          let diskPath = await this.miniNetworkDataSource.fetchMiniAndUnzip(context, networkVersionInfo)
          let miniInfo = MiniRepository.getInstance().getMiniInfo(networkVersionInfo.businessName)
          if (miniInfo) {
            let localVersion = Math.max(miniInfo?.diskVersionInfo?.version || 0, miniInfo.rawVersionInfo.version)
            if (localVersion < networkVersionInfo.version) {
              // 注意，这里必须重新创建一个LocalVersionInfo，防止版本变化导致的TaroWeb正在使用时资源读取错误
              let newInfo: LocalMiniInfo = {
                businessName: networkVersionInfo.businessName,
                rawVersionInfo: miniInfo.rawVersionInfo,
                diskVersionInfo: {
                  version: networkVersionInfo.version,
                  filePath: diskPath
                }
              }
              MiniRepository.getInstance().setOrReplaceMiniInfo(networkVersionInfo.businessName, newInfo)
            }
          }
        } catch (e) {
          taroLogger.error(TAG, `fetchMiniAndUnzip error : ${e.toString()}`, )
        }
      })
    })
  }

  private updateDiskSingleMini(context: common.UIAbilityContext, versionInfo: LocalMiniInfo) {
    // 获取本地最新的版本号
    let localDiskVersionInfo =
      MiniRepository.getInstance().readDiskLastMiniBizInfo(context.getApplicationContext(), versionInfo.businessName)
    // 本地无内置版本，则迁移RawFile小程序资源到磁盘缓存目录为初始版本
    taroLogger.debug(TAG,
      `VersionInfo ${JSON.stringify(localDiskVersionInfo)}`);
    if (localDiskVersionInfo &&
      (localDiskVersionInfo?.filePath == '' || localDiskVersionInfo?.version < versionInfo.rawVersionInfo.version)) {
      MiniRepository.getInstance().copyMiniRawUnzipDisk(context.getApplicationContext(), versionInfo).then(result => {
        if (result) {
          // 这里不需要重新创建LocalVersionInfo，直接更新即可，因为此时versionInfo里的diskVersion是不存在的，TaroWeb使用的是rawFileVersion
          versionInfo.diskVersionInfo = result.diskVersionInfo
          // 删除磁盘上的旧版本
          MiniRepository.getInstance().removeDiskVersion(localDiskVersionInfo).then(() => {
          })
        }
        taroLogger.debug(TAG, `copied success ${result}`);
      })
    } else {
      versionInfo.diskVersionInfo = localDiskVersionInfo
    }
  }
}

export const DiskCacheUpdateManagerInstance: DiskCacheUpdateManager = new DiskCacheUpdateManager()