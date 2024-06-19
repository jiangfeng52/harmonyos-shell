import { LocalVersionInfo } from '../data/source/bean/LocalVersionInfo';
import { MiniConfigRepository } from '../data/source/MiniConfigRepository';
import { MiniRepository } from '../data/source/MiniRepository';
import { UpdateManager } from './UpdateManager';
import AppContext from '@ohos.app.ability.common';
import { UpdateConfig } from '../data/source/bean/UpdateConfig';
import { taroLogger } from '../utils/Logger';
import { FileUtils } from '../utils/FileUtils';
import { GlobalThis } from '../utils/GlobalThis';


class LocalUpdateManager extends UpdateManager {
  private miniConfigRepository: MiniConfigRepository;
  private miniRepository: MiniRepository;
  constructor() {
    super()
    this.miniConfigRepository = new MiniConfigRepository();
    this.miniRepository = new MiniRepository();

  }

  getLastVersionInfo(name:string) : LocalVersionInfo|null{
    return UpdateConfig.getInstance().getMiniInfo(name);
  }

  updateMiniOnLaunch(context: AppContext.UIAbilityContext) {
    this.reset(context)
    taroLogger.debug('LocalUpdateManager',`update start`);
    try {
      let result = this.updateAllMini(context,this.miniRepository.getMiniRawList(context))
      taroLogger.debug('LocalUpdateManager',`update success ${result}`);
    } catch (e) {
      taroLogger.error('LocalUpdateManager','update Error :', e);
    }
  }

  private updateAllMini(context: AppContext.UIAbilityContext,miniList:Array<string>) : Array<LocalVersionInfo>{
    let miniArray = new Array<LocalVersionInfo>()
    if (miniList) {
      for (let index = 0; index < miniList.length; index++) {
        const element = miniList[index];
        let splits = FileUtils.checkMiniFileNameFormat(element)
        let miniInfo: LocalVersionInfo | null = null
        if (splits) {
          miniInfo = new LocalVersionInfo(splits[1], splits[0], '', this.miniRepository.getRawCachePath(element))
          UpdateConfig.getInstance().setOrReplaceMiniInfo(miniInfo.biz, miniInfo)
        }
        if (miniInfo) {
          if (GlobalThis.getInstance().getDiskUpdateEnable()) {
            this.updateDiskSingleMini(context, miniInfo)
          }
          taroLogger.debug('LocalUpdateManager',
            `VersionInfo miniInfo:${miniInfo.localVersion},biz:${miniInfo.biz},diskCachePath:${miniInfo.diskCachePath},rawCachePath:${miniInfo.rawCachePath}`);
          miniArray.push(miniInfo)
        }
      }
      //TODO-JasonZhang 热更新接口请求

    }
    return miniArray
  }

  updateDiskSingleMini(context: AppContext.UIAbilityContext, versionInfo: LocalVersionInfo): Promise<LocalVersionInfo> {
    return new Promise((resolve, reject) => {
      // 获取本地最新的版本号
      let localVersionInfo = this.miniRepository.readDiskLastMiniBizInfo(context, versionInfo.biz)
      // 本地无内置版本，则迁移RawFile小程序资源到磁盘缓存目录为初始版本
      taroLogger.debug('LocalUpdateManager',
        `VersionInfo localVersion:${localVersionInfo.localVersion},biz:${localVersionInfo.biz},diskCachePath:${localVersionInfo.diskCachePath},rawCachePath:${localVersionInfo.rawCachePath}`);
      if (localVersionInfo &&
        (localVersionInfo?.diskCachePath == '' || localVersionInfo?.localVersion < versionInfo.localVersion)) {
        let result = this.miniRepository.copyMiniRawUnzipDisk(context, versionInfo)
        if (result) {
          versionInfo.localVersion = result.localVersion
          versionInfo.diskCachePath = result.diskCachePath
          // 删除磁盘上的旧版本
          this.miniRepository.removeLocalVersionSync(localVersionInfo)
        }
        taroLogger.debug('LocalUpdateManager', `copied success ${result}`);
      } else {
        versionInfo.localVersion = localVersionInfo.localVersion
        versionInfo.diskCachePath = localVersionInfo.diskCachePath
      }
      resolve(versionInfo)
    })
  }
}

export const LocalUpdateManagerInstance: LocalUpdateManager = new LocalUpdateManager()