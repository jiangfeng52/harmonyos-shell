import { LocalVersionInfo } from './bean/LocalVersionInfo'
import { UpdateConfig } from './bean/UpdateConfig'
import { MiniLocalFileDataSource } from './local/MiniLocalFileDataSource'
import { MiniRawFileDataSource } from './local/MiniRawFileDataSource'
import { MiniNetworkDataSource } from './network/MiniNetworkDataSource'
import common from '@ohos.app.ability.common';

export class MiniRepository {
  private miniNetworkDataSource: MiniNetworkDataSource
  private miniLocalFileDataSource: MiniLocalFileDataSource
  private miniRawFileDataSource: MiniRawFileDataSource

  constructor() {
    this.miniNetworkDataSource = new MiniNetworkDataSource()
    this.miniLocalFileDataSource = new MiniLocalFileDataSource()
    this.miniRawFileDataSource = new MiniRawFileDataSource()
  }

  readDiskLastMiniBizInfo(context: Context, name:string): LocalVersionInfo {
    return this.miniLocalFileDataSource.readDiskLastMiniBizInfo(context,name)
  }

  async downloadMini(context: Context, version: number, miniDownloadUrl: string): Promise<string> {
    let tempPath = await this.miniNetworkDataSource.fetchMini(context, version, miniDownloadUrl)
    if (tempPath == null) {
      return ''
    }
    // 解压并缓存
    let unzipPath = await this.miniLocalFileDataSource.saveAndUnzip(context, version, tempPath)
    return unzipPath
  }

  copyMiniRawUnzipDisk(context: common.Context,versionInfo:LocalVersionInfo): LocalVersionInfo|null {
    return this.miniRawFileDataSource.copyMiniRawUnzipDisk(context,versionInfo)
  }

  getMiniRawList(context: common.Context) : Promise<string[]>{
    return this.miniRawFileDataSource.getRawMiniList(context)
  }

  getRawCachePath(fileMame:string):string{
    return this.miniRawFileDataSource.getRawCachePath(fileMame)
  }
}