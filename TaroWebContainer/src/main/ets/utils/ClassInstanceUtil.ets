import { as } from './advancedapi.min'
import { wbLogger } from './Logger'

export interface CallInstanceParam {
  type: string;
  name: string;
  objectId: number;
}


class InstanceConfig {
  public instancesMap: Map<number, ESObject>;
  public instanceId: number;
  private static INSTANCE: InstanceConfig;

  public static getInstance() {
    if (!InstanceConfig.INSTANCE) {
      InstanceConfig.INSTANCE = new InstanceConfig();
    }
    return InstanceConfig.INSTANCE;
  }

  constructor() {
    this.instancesMap = new Map();
    this.instanceId = 0;
  }

  createInnerAudioContext(): ESObject {
    const innerAudioContext: ESObject = as.createInnerAudioContext();
    instanceConfig.instancesMap.set(instanceConfig.instanceId, innerAudioContext);
    return instanceConfig.instanceId++;
  }

  createRequestTask(options: ESObject): ESObject {
    const networkTask: ESObject = as.request(options);
    instanceConfig.instancesMap.set(instanceConfig.instanceId, networkTask);
    return instanceConfig.instanceId++;
  }

  createUploadTask(options: ESObject): ESObject {
    const networkTask: ESObject = as.uploadFile(options);
    instanceConfig.instancesMap.set(instanceConfig.instanceId, networkTask);
    return instanceConfig.instanceId++;
  }
}

const instanceConfig = InstanceConfig.getInstance();


export class ClassInstanceApi {
  static callInstance(options: ESObject, args: CallInstanceParam): ESObject {
    wbLogger.debug('ClassInstanceApi', `callInstance`);
    if (args.type === 'create') {
      switch (args.name) {
        case 'InnerAudioContext':
          wbLogger.debug('ClassInstanceApi', `create InnerAudioContext`);
          return instanceConfig.createInnerAudioContext();
        case 'RequestTask':
          wbLogger.debug('ClassInstanceApi', `create RequestTask`);
          return instanceConfig.createRequestTask(options);
        case 'UploadTask':
          wbLogger.debug('ClassInstanceApi', `create RequestTask`);
          return instanceConfig.createUploadTask(options);
      }
    }
    if (!instanceConfig.instancesMap.has(args?.objectId ?? -1)) {
      wbLogger.error('ClassInstanceApi', 'the instance has not been init');
      return;
    }

    const instance: object = instanceConfig.instancesMap.get(args.objectId);

    if (args.type === 'function') {
      wbLogger.debug('ClassInstanceApi', `function call ${args.name}`);
      if (options) {
        return instance[args.name].call(instance, options);
      }
      return instance[args.name].call(instance);
    } else if (args.type === 'get') {
      wbLogger.debug('ClassInstanceApi', `get call ${args.name}`);
      return instance[args.name];
    } else if (args.type === 'set') {
      wbLogger.debug('ClassInstanceApi', `set call ${args.name}`);
      instance[args.name] = options;
    } else {
      wbLogger.error('ClassInstanceApi', 'invalid param', args.type);
      return;
    }
  }
}

