import { as } from './advancedapi.min';

export class NativeRequest{
  static createRequest(requestMap: Map<number, ESObject>, instanceId: number): ESObject {
    const request: ESObject = as.request();
    requestMap.set(instanceId, request);
  }
}