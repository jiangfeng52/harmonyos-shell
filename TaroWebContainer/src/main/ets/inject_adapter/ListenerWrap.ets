export interface CallInstanceParam {
  option: ESObject;
  className: string;
  type: string;
  property: string;
  objectId: number;
  listenerSubject?: string;
  listenerSwitch?: 'on' | 'off';
}
export const instListenerMap: Map<object, Set<string>> = new Map();

export function listenerOnOff(instance: object, options: CallInstanceParam): boolean {
  if (!options.listenerSubject) {
    return false;
  }
  let listenerSet = instListenerMap.get(instance);
  if (options.listenerSwitch === 'on' || options.property.startsWith('on')) {
    if (!listenerSet) {
      listenerSet = new Set<string>();
    }
    if (!listenerSet.has(options.listenerSubject)) {
      listenerSet.add(options.listenerSubject);
      instance[options.property].call(instance, options.option);
    }
    instListenerMap.set(instance, listenerSet);
    return true;
  } else if (options.listenerSwitch === 'off' || options.property.startsWith('off')) {
    if (!listenerSet || !listenerSet.has(options.listenerSubject)) {
      return true;
    }
    listenerSet.delete(options.listenerSubject)
    instance[options.property].call(instance);
    instListenerMap.set(instance, listenerSet)
    return true;
  }
  return false;
}