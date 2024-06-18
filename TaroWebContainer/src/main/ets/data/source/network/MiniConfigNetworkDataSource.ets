import http from '@ohos.net.http'
import { BusinessError } from '@ohos.base';
import { MiniConfig } from '../bean/MiniConfig'
import { NetworkTask, NetworkTaskStatus } from '../bean/NetworkTask';
import { taroLogger } from '../../../utils/Logger';
import { UpdateConfig } from '../bean/UpdateConfig';
import { LocalVersionInfo } from '../bean/LocalVersionInfo';
import { TaroHybridManager } from '../../../tarohybrid/TaroHybridManager';

interface VersionInfo {
  mini_version?: string;
  mini_download_url?: string;
}

interface ResponseResult {
  data?: VersionInfo;
}

export class MiniConfigNetworkDataSource {
  async fetchMiniConfig(localVersion: string): Promise<NetworkTask<MiniConfig>> {
    const networkTask = new NetworkTask<MiniConfig>(null, NetworkTaskStatus.ACTIVE);

    const url = `${UpdateConfig.getInstance().getUrl(localVersion)}`
    const httpRequest = http.createHttp();
    try {
      taroLogger.debug('network', '%{public}s request', url)
      const response = await httpRequest.request(url, {
        header: {
          'Content-Type': 'application/json',
          'User-Agent': TaroHybridManager.getCustomUserAgent()
        },
      })
      taroLogger.debug('network', '%{public}s request complete, result is %{public}s', url, response.result)

      const result: ResponseResult | undefined = JSON.parse(response.result.toString())
      networkTask.taskStatus = NetworkTaskStatus.READY
      if (result?.data) {
        networkTask.data = new MiniConfig(true, Number.parseInt(result?.data?.mini_version ?? '-1', 10), result?.data?.mini_download_url ?? '');
      }
    } catch (err) {
      taroLogger.debug('network', '%{public}s request is err, err is %{public}s', url, JSON.stringify(err) ?? '')
      networkTask.taskStatus = NetworkTaskStatus.FAILED;
    } finally {
      httpRequest.destroy();
    }

    return networkTask
  }
  async fetchMiniListConfig(localVersion: Array<LocalVersionInfo>): Promise<NetworkTask<MiniConfig>> {
    const networkTask = new NetworkTask<MiniConfig>(null, NetworkTaskStatus.ACTIVE);

    const url = `${UpdateConfig.getInstance().getUrl(localVersion.toString())}`
    const httpRequest = http.createHttp();
    try {
      taroLogger.debug('network', '%{public}s request', url)
      const response = await httpRequest.request(url, {
        header: {
          'Content-Type': 'application/json',
          'User-Agent': TaroHybridManager.getCustomUserAgent()
        },
      })
      taroLogger.debug('network', '%{public}s request complete, result is %{public}s', url, response.result)

      const result: ResponseResult | undefined = JSON.parse(response.result.toString())
      networkTask.taskStatus = NetworkTaskStatus.READY
      if (result?.data) {
        networkTask.data = new MiniConfig(true, Number.parseInt(result?.data?.mini_version ?? '-1', 10), result?.data?.mini_download_url ?? '');
      }
    } catch (err) {
      taroLogger.debug('network', '%{public}s request is err, err is %{public}s', url, JSON.stringify(err) ?? '')
      networkTask.taskStatus = NetworkTaskStatus.FAILED;
    } finally {
      httpRequest.destroy();
    }

    return networkTask
  }

}