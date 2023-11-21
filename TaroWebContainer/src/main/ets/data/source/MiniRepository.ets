import { MiniLocalFileDataSource } from './local/MiniLocalFileDataSource'
import { MiniRawFileDataSource } from './local/MiniRawFileDataSource'
import { MiniNetworkDataSource } from './network/MiniNetworkDataSource'

export class MiniRepository {
  private miniNetworkDataSource: MiniNetworkDataSource
  private miniLocalFileDataSource: MiniLocalFileDataSource
  private miniRawFileDataSource: MiniRawFileDataSource

  constructor() {
    this.miniNetworkDataSource = new MiniNetworkDataSource()
    this.miniLocalFileDataSource = new MiniLocalFileDataSource()
    this.miniRawFileDataSource = new MiniRawFileDataSource()
  }

  getLastMiniVersion(context: Context){
    // this.miniLocalFileDataSource.getLastMiniVersion()
  }

  async downloadMini(context: Context, version: number, miniDownloadUrl: string): Promise<string>{
    let tempPath = await this.miniNetworkDataSource.fetchMini(context, version, miniDownloadUrl)
    if(tempPath == null) {
      return ''
    }
    // 解压并缓存
    let unzipPath = await this.miniLocalFileDataSource.saveAndUnzip(context, version, tempPath)
    return unzipPath
  }

}