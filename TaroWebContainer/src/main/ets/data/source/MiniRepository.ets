import { LocalMiniInfo, VersionInfo } from './bean/LocalMiniInfo'
import { MiniLocalFileDataSource } from './local/MiniLocalFileDataSource'
import { MiniRawFileDataSource } from './local/MiniRawFileDataSource'
import common from '@ohos.app.ability.common'
import { FileUtils } from '../../utils/FileUtils'
import { HashMap } from '@kit.ArkTS'

export class MiniRepository {
  private static instance: MiniRepository
  private miniLocalFileDataSource: MiniLocalFileDataSource
  private miniRawFileDataSource: MiniRawFileDataSource
  private minisInfo: HashMap<string, LocalMiniInfo> = new HashMap<string, LocalMiniInfo>()

  private constructor() {
    this.miniLocalFileDataSource = new MiniLocalFileDataSource()
    this.miniRawFileDataSource = new MiniRawFileDataSource()
  }

  public static getInstance(): MiniRepository {
    if (!MiniRepository.instance) {
      MiniRepository.instance = new MiniRepository();
    }
    return MiniRepository.instance;
  }

  initMiniInfo(context: common.UIAbilityContext) {
    let rawFileList = MiniRepository.getInstance().getMiniRawList(context.getApplicationContext())
    let miniArray = new Array<LocalMiniInfo>()
    if (rawFileList) {
      for (let index = 0; index < rawFileList.length; index++) {
        const element = rawFileList[index];
        let splits = FileUtils.checkMiniFileNameFormat(element)
        if (splits) {
          let miniInfo: LocalMiniInfo = {
            businessName: splits[0],
            rawVersionInfo: {
              version: parseInt(splits[1]),
              filePath: this.getRawCachePath(element)
            }
          }
          this.setOrReplaceMiniInfo(miniInfo.businessName, miniInfo)
        }
      }
    }
    return miniArray
  }

  setOrReplaceMiniInfo(name: string, versionInfo: LocalMiniInfo) {
    if (name && versionInfo) {
      if (this.minisInfo.hasKey(name)) {
        this.minisInfo.replace(name, versionInfo);
      } else {
        this.minisInfo.set(name, versionInfo)
      }
    }
  }

  getMiniInfoMap() {
    return this.minisInfo
  }

  getMiniInfo(name: string): LocalMiniInfo | null {
    return this.minisInfo.get(name)
  }

  readDiskLastMiniBizInfo(context: common.ApplicationContext, name: string): VersionInfo {
    return this.miniLocalFileDataSource.readDiskLastMiniBizInfo(context, name)
  }

  async copyMiniRawUnzipDisk(context: common.ApplicationContext, versionInfo: LocalMiniInfo): Promise<LocalMiniInfo | null> {
    return await this.miniRawFileDataSource.copyMiniRawUnzipDisk(context, versionInfo)
  }

  getMiniRawList(context: common.ApplicationContext): Array<string> {
    return this.miniRawFileDataSource.getRawMiniList(context)
  }

  getRawCachePath(fileMame: string): string {
    return this.miniRawFileDataSource.getRawCachePath(fileMame)
  }

  removeDiskVersionSync(versionInfo: VersionInfo) {
    FileUtils.removeFileOrDirSync(versionInfo.filePath)
  }

  removeDiskVersion(versionInfo: VersionInfo): Promise<void> {
    return FileUtils.removeFileOrDir(versionInfo.filePath)
  }
}