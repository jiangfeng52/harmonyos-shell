import http from '@ohos.net.http'
import { BusinessError } from '@ohos.base';
import { MiniConfig } from '../bean/MiniConfig'
import { NetworkTask, NetworkTaskStaus } from '../bean/NetworkTask';
import { wbLogger } from '../../../utils/Logger';

export class MiniConfigNetworkDataSource {

  async fetchMiniConfig(localVersion: string): Promise<NetworkTask<MiniConfig>>{
    const networkTask = new NetworkTask<MiniConfig>(null, NetworkTaskStaus.ACTIVE);

    const url = `http://10.253.108.182:9999/api/mini/config?local_version=${localVersion}`
    const httpRequest = http.createHttp();
    try {
      wbLogger.debug('network', '%{public}s request', url)
      const response = await httpRequest.request(url, {
        header: [{'Content-Type': 'application/json'}],
      })
      wbLogger.debug('network', '%{public}s request complete, result is %{public}s', url, response.result)

      const result:ESObject = JSON.parse(response.result.toString())
      networkTask.taskStatus = NetworkTaskStaus.READY
      if (result?.data) {
        networkTask.data = new MiniConfig(true, Number.parseInt(result?.data?.mini_version ?? '-1', 10), result?.data?.mini_download_url ?? '');
      }
    } catch (err) {
      wbLogger.debug('network', '%{public}s request is err, err is %{public}s', url, JSON.stringify(err) ?? '')
      networkTask.taskStatus = NetworkTaskStaus.FAILED;
    }
    httpRequest.destroy();
    return networkTask
  }

}