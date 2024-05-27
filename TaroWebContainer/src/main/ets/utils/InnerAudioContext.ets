import { as } from './advancedapi.min';

export class InnerAudioContext{
  static createInnerAudioContext(innerAudioContextMap: Map<number, ESObject>, instanceId: number): ESObject {
    const innerAudioContext: ESObject = as.createInnerAudioContext();
    innerAudioContextMap.set(instanceId, innerAudioContext);
  }
}