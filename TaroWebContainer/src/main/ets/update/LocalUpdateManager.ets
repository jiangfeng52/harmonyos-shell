import { NetworkTaskStaus } from '../data/source/bean/NetworkTask';
import { MiniConfigRepository } from '../data/source/MiniConfigRepository';
import { MiniRepository } from '../data/source/MiniRepository';
import { ResOptions, UpdateManager } from './UpdateManager';

class LocalUpdateManager extends UpdateManager {
  private miniConfigRepository: MiniConfigRepository;
  private miniRepository: MiniRepository;

  constructor() {
    super()
    this.miniConfigRepository = new MiniConfigRepository();
    this.miniRepository = new MiniRepository();
  }

  async updateMiniOnLaunch(){
    this.reset()

    const miniConfig = await this.miniConfigRepository.fetchMinfiConfig()
    // 通知注册的监听者
    this.notifyCheckForUpdate(new ResOptions(miniConfig.hasUpdate))

    if (miniConfig.hasUpdate) {
      // 请求小程序资源
      const networkTask = await this.miniRepository.downloadMini(miniConfig.miniDownloadUrl)
      if (networkTask.taskStatus == NetworkTaskStaus.ACTIVE) {
        this.notifyUpdateReady()
      }
      else if(networkTask.taskStatus == NetworkTaskStaus.FAILED) {
        this.notifyUpdateFailed()
      }
    }
  }
}

export const LocalUpdateManagerInstance: LocalUpdateManager = new LocalUpdateManager()