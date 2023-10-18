import { DEFAULT_CATEGORY } from '@hw-agconnect/api-ohos'

// depended by Cloud-Storage/HA
export class Singleton<T> {
  private factory: () => T;
  private instance?: T;
  constructor(creator: () => T) {
    this.factory = creator;
  }
  get(): T {
    if (this.instance == null) {
      this.instance = this.factory();
    }
    return this.instance;
  }
}

export class InstanceMap<T> {
  private factory: (args: any[]) => T;
  private instanceMap: { [name: string]: T } = {};

  constructor(creator: (args: any[]) => T) {
    this.factory = creator;
  }

  get(args?: any): T {
    if (args && Array.isArray(args) && args.length >= 1) {
      if (!this.instanceMap[args[0]]) {
        this.instanceMap[args[0]] = this.factory(args);
      }
      return this.instanceMap[args[0]];
    }
    let defaultArray = new Array();
    defaultArray[0] = DEFAULT_CATEGORY;
    return this.get(defaultArray);
  }
}