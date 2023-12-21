import http from '@ohos.net.http'
import { BusinessError } from '@ohos.base';
import { MiniConfig } from '../bean/MiniConfig'
import { NetworkTask, NetworkTaskStatus } from '../bean/NetworkTask';
import { wbLogger } from '../../../utils/Logger';

export class MiniConfigNetworkDataSource {

  async fetchMiniConfig(localVersion: string, urlInfo: string): Promise<NetworkTask<MiniConfig>>{
    const networkTask = new NetworkTask<MiniConfig>(null, NetworkTaskStatus.ACTIVE);

    const url = `${urlInfo}${localVersion}`
    const httpRequest = http.createHttp();
    try {
      wbLogger.debug('network', '%{public}s request', url)
      const response = await httpRequest.request(url, {
        header: [{'Content-Type': 'application/json'}],
      })
      wbLogger.debug('network', '%{public}s request complete, result is %{public}s', url, response.result)

      const result:ESObject = JSON.parse(response.result.toString())
      networkTask.taskStatus = NetworkTaskStatus.READY
      if (result?.data) {
        networkTask.data = new MiniConfig(true, Number.parseInt(result?.data?.mini_version ?? '-1', 10), result?.data?.mini_download_url ?? '');
      }
    } catch (err) {
      wbLogger.debug('network', '%{public}s request is err, err is %{public}s', url, JSON.stringify(err) ?? '')
      networkTask.taskStatus = NetworkTaskStatus.FAILED;
    } finally {
      httpRequest.destroy();
    }

    return networkTask
  }

}