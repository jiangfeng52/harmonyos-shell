import { TaroWebController } from '../../components/TaroWeb';
import { TaroHybridManager } from '../../tarohybrid/TaroHybridManager';
import { InnerAudioContext } from './InnerAudioContext';
import { taroLogger } from '../../utils/Logger'
import { NativeRequest } from './NativeRequest'
import { NativeUploadFile } from './NativeUploadFile'
import { CallInstanceParam, listenerOnOff } from '../ListenerWrap';

type classReturnType = object | number | string | boolean | void

export { CallInstanceParam } from '../ListenerWrap';

//
function getInstanceFromMap(instanceMap: Map<number, ESObject>, options: CallInstanceParam): ESObject{
  if (!instanceMap.has(options?.objectId ?? -1)) {
    return;
  }
  return instanceMap.get(options.objectId);
}

function syncAndReleaseInstance(instanceMap: Map<number, ESObject>, options: CallInstanceParam){
  const arr = options.option as Array<number>
  if (!arr || !arr.length){
    instanceMap = new Map()
    return instanceMap;
  }
  for (let key of instanceMap.keys()){
    if (!arr.includes(key)){
      instanceMap.delete(key)
    }
  }
  return instanceMap;
}
// Map中存储的类，类中不能包含promise
export class ClassInstanceApi {
  public innerAudioContextMap: Map<number, ESObject>;
  public uploadFileMap: Map<number, ESObject>;
  public requestMap: Map<number, ESObject>;
  public instanceId: number;
  // 延时获取
  private webUserAgent: string | undefined

  constructor() {
    this.innerAudioContextMap = new Map();
    this.uploadFileMap = new Map();
    this.requestMap = new Map();
    this.instanceId = 0;
  }

  createInstance(taroWebController: TaroWebController, options: ESObject): number{
    taroLogger.debug('ClassInstanceApi', `createInstance ${options.className}`);
    switch (options.className) {
      case 'NativeInnerAudioContext':
        InnerAudioContext.createInnerAudioContext(this.innerAudioContextMap, this.instanceId);
        return this.instanceId++
      case 'NativeRequest':
        if (this.webUserAgent === undefined) {
          this.webUserAgent = taroWebController.webController.getUserAgent();
        }
        NativeRequest.createRequest(this.requestMap, this.instanceId, options, this.webUserAgent);
        return this.instanceId++
      case 'NativeUploadFile':
        NativeUploadFile.createUploadFile(this.uploadFileMap, this.instanceId, options);
        return this.instanceId++
    }
    return -1
  }

  syncAndReleaseInstance(options: CallInstanceParam): ESObject{
    taroLogger.debug('ClassInstanceApi', `syncAndReleaseInstance`);
    switch (options.className) {
      case 'NativeInnerAudioContext':
        this.innerAudioContextMap = syncAndReleaseInstance(this.innerAudioContextMap, options)
        return
      case 'NativeRequest':
        this.requestMap = syncAndReleaseInstance(this.requestMap, options)
        return
      case 'NativeUploadFile':
        this.uploadFileMap = syncAndReleaseInstance(this.uploadFileMap, options)
        return
    }
  }

  getInstanceFromMap(options: CallInstanceParam): ESObject{
    switch (options.className) {
      case 'NativeInnerAudioContext':
        return getInstanceFromMap(this.innerAudioContextMap, options)
      case 'NativeRequest':
        return getInstanceFromMap(this.requestMap, options)
      case 'NativeUploadFile':
        return getInstanceFromMap(this.uploadFileMap, options)
    }
    taroLogger.error('ClassInstanceApi', 'the id is not exist in map');
    return
  }

  callInstance(options: CallInstanceParam): classReturnType {
    taroLogger.debug('ClassInstanceApi', `callInstance`);
    let instance: ESObject = this.getInstanceFromMap(options)
    if (!instance){
      taroLogger.error('ClassInstanceApi', 'the instance has not been create');
      return ;
    }

    if (options.type === 'function') {
      taroLogger.debug('ClassInstanceApi', `function call ${options.property}`);
      if (options.option) {
        if (!listenerOnOff(instance, options)) {
          instance[options.property].call(instance, options.option);
        }
        return ;
      }
      instance[options.property].call(instance);
    } else if (options.type === 'get') {
      taroLogger.debug('ClassInstanceApi', `get call ${options.property}`);
      return instance[options.property];
    } else if (options.type === 'set') {
      taroLogger.debug('ClassInstanceApi', `set call ${options.property}`);
      instance[options.property] = options.option;
    } else {
      taroLogger.error('ClassInstanceApi', 'invalid param', options.type);
      return;
    }
  }

  callInstanceAsync(options: CallInstanceParam): classReturnType {
    taroLogger.debug('ClassInstanceApi', `callInstanceAsync`);
    let instance: ESObject = this.getInstanceFromMap(options)
    if (!instance){
      taroLogger.error('ClassInstanceApi', 'the instance has not been create');
      return ;
    }
    if (options.type !== 'function'){
      taroLogger.error('ClassInstanceApi', 'invalid param', options.type);
      return ;
    }
    if (!listenerOnOff(instance, options)) {
      instance[options.property].call(instance, options.option);
    }
  }
}
