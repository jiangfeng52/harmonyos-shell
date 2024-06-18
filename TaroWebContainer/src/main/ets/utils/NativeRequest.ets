import { as } from './advancedapi.min';
import buffer from '@ohos.buffer';
import { TaroHybridManager } from '../tarohybrid/TaroHybridManager';

export function addCustomUserAgent(option: ESObject, webUserAgent: string, customUserAgent: string){
  const fullUserAgent = webUserAgent + ' ' + customUserAgent
  // 拦截并添加user-agent
  if(!option?.header) {
    // options.header不存在
    option.header = {'user-agent': fullUserAgent}
  }
  else if (!option?.header?.['user-agent']){
    // options.header存在，但是options.header['user-agent']不存在
    option.header['user-agent'] = fullUserAgent
  }
  else {
    // options.header['user-agent'] 存在的情况下，追加自定义值
    option.header['user-agent'] = option.header['user-agent'] + ' ' + customUserAgent
  }
}

export class NativeRequest{
  static async createRequest(requestMap: Map<number, ESObject>, instanceId: number, option: ESObject, webUserAgent: string): Promise<void> {
    if (option?.bufBase64){
      const buf = buffer.from(option.bufBase64, 'base64')
      option.data = buf.buffer.slice(buf.byteOffset, buf.byteOffset + buf.length)
      option.bufBase64 = undefined
    }

    addCustomUserAgent(option, webUserAgent, TaroHybridManager.getCustomUserAgent())

    const request: ESObject = await as.request(option);
    requestMap.set(instanceId, request);
  }
}