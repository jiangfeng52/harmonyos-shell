import rpc from "@ohos.rpc";

/**
 * IDE 3.0.0.901版本无法直接使用rpc.RemoteObject，只能继承自rpc.RemoteObject;
 * 并且实现addDeathRecipient/removeDeathRecipient/isObjectDead三个方法。
 */
export class OHOSCallbackObject extends rpc.RemoteObject {
  onRemoteRequest;

  constructor(descriptor: string) {
    super(descriptor);
  }

  addDeathRecipient(): boolean {
    return true;
  }

  removeDeathRecipient(): boolean {
    return true;
  }

  isObjectDead(): boolean {
    return false;
  }
}