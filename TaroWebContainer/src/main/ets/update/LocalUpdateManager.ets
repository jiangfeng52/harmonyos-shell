import { LocalVersionInfo } from '../data/source/bean/LocalVersionInfo';
import { MiniConfigRepository } from '../data/source/MiniConfigRepository';
import { MiniRepository } from '../data/source/MiniRepository';
import { UpdateManager } from './UpdateManager';
import AppContext from '@ohos.app.ability.common'
import { UpdateConfig } from '../data/source/bean/UpdateConfig';
import { wbLogger } from '../utils/Logger';
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
    UpdateConfig.getInstance().getMiniInfo(name);
    return UpdateConfig.getInstance().getMiniInfo(name);
  }

  updateMiniOnLaunch(context: AppContext.UIAbilityContext) {
    this.reset(context)
    wbLogger.debug('LocalUpdateManager',`update start`);
    this.updateAllMini(context).then((result: Array<LocalVersionInfo>) => {
      if (result) {
        wbLogger.debug('LocalUpdateManager',`update success ${result}`);
      }
    }).catch((error: Error) => {
      wbLogger.error('LocalUpdateManager','update Error :', error);
    })
  }
  async updateAllMini(context: AppContext.UIAbilityContext) : Promise<Array<LocalVersionInfo>>{
    return new Promise(async (resolve, reject) => {
      let miniArray = new Array<LocalVersionInfo>()
      try {
        const miniList = await this.miniRepository.getMiniRawList(context)
        if (miniList) {
          for (let index = 0; index < miniList.length; index++) {
            const element = miniList[index];
            let splits = FileUtils.checkMiniFileNameFormat(element)
            let miniInfo: LocalVersionInfo | null = null
            if (splits) {
              miniInfo = new LocalVersionInfo(splits[1], splits[0],'',this.miniRepository.getRawCachePath(element))
              UpdateConfig.getInstance().setOrReplaceMiniInfo(miniInfo.biz, miniInfo)
            }
            if (miniInfo) {
              if (GlobalThis.getInstance().getDiskUpdateEnable()) {
                this.updateDiskSingleMini(context, miniInfo)
              }
              wbLogger.debug('LocalUpdateManager',`VersionInfo miniInfo:${miniInfo.localVersion},biz:${miniInfo.biz},diskCachePath:${miniInfo.diskCachePath},rawCachePath:${miniInfo.rawCachePath}`);
              miniArray.push(miniInfo)
            }
          }
          //TODO-JasonZhang 热更新接口请求
        }
        resolve(miniArray)
      } catch (err) {
        reject(err)
      }
    })
  }
   updateDiskSingleMini(context: AppContext.UIAbilityContext,versionInfo:LocalVersionInfo){
    // 获取本地最新的版本号
    let localVersionInfo = this.miniRepository.readDiskLastMiniBizInfo(context,versionInfo.biz)
    // 本地无内置版本，则迁移RawFile小程序资源到磁盘缓存目录为初始版本
    wbLogger.debug('LocalUpdateManager',`VersionInfo localVersion:${localVersionInfo.localVersion},biz:${localVersionInfo.biz},diskCachePath:${localVersionInfo.diskCachePath},rawCachePath:${localVersionInfo.rawCachePath}`);
    if (localVersionInfo && (localVersionInfo?.diskCachePath==''|| localVersionInfo?.localVersion < versionInfo.localVersion)) {
        let result = this.miniRepository.copyMiniRawUnzipDisk(context,versionInfo)
        if (result) {
          versionInfo.localVersion = result.localVersion
          versionInfo.diskCachePath = result.diskCachePath
        }
        wbLogger.debug('LocalUpdateManager',`copied success ${result}`);
    }else{
      versionInfo.localVersion  = localVersionInfo.localVersion
      versionInfo.diskCachePath  = localVersionInfo.diskCachePath
    }
  }
}

export const LocalUpdateManagerInstance: LocalUpdateManager = new LocalUpdateManager()