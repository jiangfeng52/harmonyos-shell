import { LocalVersionInfo } from '../data/source/bean/LocalVersionInfo';
import { MiniConfig } from '../data/source/bean/MiniConfig';
import { UpdateConfig } from '../data/source/bean/UpdateConfig';
import { MiniConfigRepository } from '../data/source/MiniConfigRepository';
import { MiniRepository } from '../data/source/MiniRepository';
import { UpdateManager } from './UpdateManager';

class LocalUpdateManager extends UpdateManager {
  private miniConfigRepository: MiniConfigRepository;
  private miniRepository: MiniRepository;
  private localVersionInfo: LocalVersionInfo

  constructor() {
    super()
    this.miniConfigRepository = new MiniConfigRepository();
    this.miniRepository = new MiniRepository();
    this.localVersionInfo = new LocalVersionInfo()

  }

  getLastVersionPath() {
    return this.localVersionInfo.path
  }

  async updateMiniOnLaunch(context: Context) {
    this.reset()

    // 获取本地最新的版本号
    let lastVersionInfo = this.miniRepository.getLastMiniVersion(context)
    this.localVersionInfo = lastVersionInfo

    const miniConfig = await this.miniConfigRepository.fetchMiniConfig(UpdateConfig.getInstance().getUrl())
    // 通知注册的监听者
    this.notifyCheckForUpdate(miniConfig.hasUpdate)

    if (miniConfig.hasUpdate) {
      // 请求小程序资源
      const unzipPath = await this.miniRepository.downloadMini(context, miniConfig.miniVersion, miniConfig.miniDownloadUrl)
      if (unzipPath == '') {
        this.notifyUpdateFailed()
      } else {
        this.notifyUpdateReady(unzipPath)
      }
    }
  }
}

export const LocalUpdateManagerInstance: LocalUpdateManager = new LocalUpdateManager()