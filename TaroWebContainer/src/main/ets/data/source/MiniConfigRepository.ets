import { MiniConfig } from './bean/MiniConfig';
import { NetworkTask } from './bean/NetworkTask';
import { MiniConfigNetworkDataSource } from './network/MiniConfigNetworkDataSource';

export class MiniConfigRepository {
  private miniConfigNetworkDataSource: MiniConfigNetworkDataSource;

  constructor() {
    this.miniConfigNetworkDataSource = new MiniConfigNetworkDataSource();
  }

  async fetchMiniConfig(localVersion: string): Promise<MiniConfig>{
    const networkTask:NetworkTask<MiniConfig> = await this.miniConfigNetworkDataSource.fetchMiniConfig(localVersion)
    const miniConfig: MiniConfig = networkTask.data ?? new MiniConfig(false)
    if (!miniConfig.miniDownloadUrl) {
      miniConfig.hasUpdate = false
    }
    return miniConfig
  }
}