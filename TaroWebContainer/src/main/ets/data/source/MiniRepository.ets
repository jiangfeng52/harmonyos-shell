import { NetworkTask, NetworkTaskStaus } from './bean/NetworkTask'
import { MiniLocalFileDataSource } from './local/MiniLocalFileDataSource'
import { MiniRawFileDataSource } from './local/MiniRawFileDataSource'
import { MiniNetworkDataSource } from './network/MiniNetworkDataSource'

export class MiniRepository {
  private miniNetworkDataSource: MiniNetworkDataSource
  private miniLocalFileDataSource: MiniLocalFileDataSource
  private miniRawFileDataSource: MiniRawFileDataSource

  constructor() {
  }

  async downloadMini(miniDownloadUrl: string): Promise<NetworkTask<string>>{

    return new NetworkTask("", NetworkTaskStaus.ACTIVE)
  }


}