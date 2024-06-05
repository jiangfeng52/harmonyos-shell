import { as } from './advancedapi.min';
import buffer from '@ohos.buffer';

export class NativeRequest{
  static async createRequest(requestMap: Map<number, ESObject>, instanceId: number, option: ESObject): Promise<void> {
    if (option?.bufBase64){
      const buf = buffer.from(option.bufBase64, 'base64')
      option.data = buf.buffer.slice(buf.byteOffset, buf.byteOffset + buf.length)
    }
    const request: ESObject = await as.request(option);
    requestMap.set(instanceId, request);
  }
}