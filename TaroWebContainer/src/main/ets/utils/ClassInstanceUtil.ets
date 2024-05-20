import { InnerAudioContext } from './InnerAudioContext';
import { wbLogger } from './Logger'
import { NativeRequest } from './NativeRequest'
import { NativeUploadFile } from './NativeUploadFile'

type classReturnType = object | number | string | boolean | void

export interface CallInstanceParam {
  option: ESObject;
  className: string;
  type: string;
  property: string;
  objectId: number;
}

function getInstanceFromMap(instanceMap: Map<number, ESObject>, options: CallInstanceParam): ESObject{
  switch (options.className) {
    case 'NativeInnerAudioContext':
      if (!instanceMap.has(options?.objectId ?? -1)) {
        return;
      }
      return instanceMap.get(options.objectId)
  }
}

function syncAndReleaseInstance(instanceMap: Map<number, ESObject>, options: CallInstanceParam){
  const arr = options.option as Array<number>
  if (!arr || !arr.length){
    instanceMap = new Map()
    return;
  }
  for (let key of instanceMap.keys()){
    if (!arr.includes(key)){
      instanceMap.delete(key)
    }
  }
}

export class ClassInstanceApi {
  public innerAudioContextMap: Map<number, ESObject>;
  public uploadFileMap: Map<number, ESObject>;
  public requestMap: Map<number, ESObject>;
  public instanceId: number;

  constructor() {
    this.innerAudioContextMap = new Map();
    this.uploadFileMap = new Map();
    this.requestMap = new Map();
    this.instanceId = 0;
  }

  createInstance(options: CallInstanceParam): number{
    wbLogger.debug('ClassInstanceApi', `createInstance ${options.className}`);
    switch (options.className) {
      case 'NativeInnerAudioContext':
        InnerAudioContext.createInnerAudioContext(this.innerAudioContextMap, this.instanceId);
        return this.instanceId++
      case 'NativeRequest':
        NativeRequest.createRequest(this.requestMap, this.instanceId);
        return this.instanceId++
      case 'NativeUploadFile':
        NativeUploadFile.createUploadFile(this.uploadFileMap, this.instanceId);
        return this.instanceId++
    }
    return -1
  }

  syncAndReleaseInstance(options: CallInstanceParam): ESObject{
    wbLogger.debug('ClassInstanceApi', `syncAndReleaseInstance`);
    switch (options.className) {
      case 'NativeInnerAudioContext':
        syncAndReleaseInstance(this.innerAudioContextMap, options)
        return
      case 'NativeRequest':
        syncAndReleaseInstance(this.requestMap, options)
        return
      case 'NativeUploadFile':
        syncAndReleaseInstance(this.uploadFileMap, options)
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
    wbLogger.error('ClassInstanceApi', 'the id is not exist in map');
    return
  }

  callInstance(options: CallInstanceParam): classReturnType {
    wbLogger.debug('ClassInstanceApi', `callInstance`);
    let instance: ESObject = this.getInstanceFromMap(options)
    if (!instance){
      wbLogger.error('ClassInstanceApi', 'the instance has not been create');
      return ;
    }
    if (options.type === 'function') {
      wbLogger.debug('ClassInstanceApi', `function call ${options.property}`);
      if (options.option) {
        instance[options.property].call(instance, options.option);
        return ;
      }
      instance[options.property].call(instance);
    } else if (options.type === 'get') {
      wbLogger.debug('ClassInstanceApi', `get call ${options.property}`);
      return instance[options.property];
    } else if (options.type === 'set') {
      wbLogger.debug('ClassInstanceApi', `set call ${options.property}`);
      instance[options.property] = options.option;
    } else {
      wbLogger.error('ClassInstanceApi', 'invalid param', options.type);
      return;
    }
  }

  callInstanceAsync(options: CallInstanceParam): classReturnType {
    wbLogger.debug('ClassInstanceApi', `callInstanceAsync`);
    let instance: ESObject = this.getInstanceFromMap(options)
    if (!instance){
      wbLogger.error('ClassInstanceApi', 'the instance has not been create');
      return ;
    }
    if (options.type !== 'function'){
      wbLogger.error('ClassInstanceApi', 'invalid param', options.type);
      return ;
    }
    return instance[options.property].call(instance, options.option);
  }
}
