import { as } from './advancedapi.min';

export class NativeRequest{
  static async createRequest(requestMap: Map<number, ESObject>, instanceId: number, option: ESObject): Promise<void> {
    const request: ESObject = await as.request(option);
    requestMap.set(instanceId, request);
  }
}