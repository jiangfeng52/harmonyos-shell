import { taroLogger } from '../../utils/Logger';
import { taroStorage } from '../TaroStorage';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';

const TARO_STORAGE_MANAGER = "TaroStorageManager"
const TYPE_STORAGE_UPDATE_EVENT_SET = "TYPE_STORAGE_UPDATE_EVENT_SET"
const TYPE_STORAGE_UPDATE_EVENT_REMOVE = "TYPE_STORAGE_UPDATE_EVENT_REMOVE"
const TYPE_STORAGE_UPDATE_EVENT_CLEAR = "TYPE_STORAGE_UPDATE_EVENT_CLEAR"

/**
 * StorageApi，非单例模式，提供Storage相关API，并为前端实现storage状态的监听和回调
 */
export class StorageApi {
  private indexHtmlPath: string
  private storageChangeListeners: Set<(type: string, key: string) => void> = new Set()
  private instanceId: string = util.generateRandomUUID(false);
  // 用于保存创建成功的订阅者对象，后续使用其完成订阅及退订的动作
  private taroStorageUpdatedSubscriber: commonEventManager.CommonEventSubscriber | null = null;

  constructor(indexHtmlPath: string) {
    this.indexHtmlPath = indexHtmlPath;
  }

  public onWebViewAboutToAppear() {
    this.subscribeTaroStorageUpdateEvent()
  }

  public onWebViewAboutToDisappear() {
    this.unsubscribeTaroStorageUpdateEvent()
  }

  public setStorage(options: ESObject) {
    taroStorage.set(options)
    if (options.key) {
      this.publishStoreUpdateEvent(TYPE_STORAGE_UPDATE_EVENT_SET, options.key)
    }
  }

  public removeStorage(options: ESObject) {
    taroStorage.remove(options)
    if (options.key) {
      this.publishStoreUpdateEvent(TYPE_STORAGE_UPDATE_EVENT_REMOVE, options.key)
    }
  }

  public getStorage(options: ESObject) {
    taroLogger.debug('taro_storage', 'getStorage({key: %{public}s}) from jsbridge', options?.key)
    taroStorage.get(options)
  }

  public getStorageSync(options: ESObject) {
    taroLogger.debug('taro_storage', 'getStorageSync({key: %{public}s}) from jsbridge', options?.key)
    return taroStorage.getByPromise(options)
  }

  public getStorageInfo(options: ESObject) {
    taroStorage.getInfo(options)
  }

  public clearStorage(options: ESObject) {
    taroStorage.clear(options)
    this.publishStoreUpdateEvent(TYPE_STORAGE_UPDATE_EVENT_CLEAR, "CLEAR")
  }

  public batchGetPageShowDataStorage(options: ESObject) {
    taroStorage.batchGetPageShowData(this.indexHtmlPath, options)
  }

  public updatePageShowDataKeys(options: ESObject) {
    taroStorage.updatePageShowDataKeys(this.indexHtmlPath, options)
  }

  public onStorageStatusChange(listener: (type: string, key: string) => void) {
    this.storageChangeListeners.add(listener)
  }

  public offStorageStatusChange(listener: (type: string, key: string) => void) {
    this.storageChangeListeners.delete(listener)
  }

  /**
   * 发布store 更新事件
   * @param key
   */
  private publishStoreUpdateEvent(type: string, key: string) {
    let options: commonEventManager.CommonEventPublishData = {
      parameters: {
        key: key,
        type: type,
        id: this.instanceId
      }
    };
    commonEventManager.publish('TaroStorageUpdated', options, (err: BusinessError) => {
      if (err) {
        taroLogger.error(TARO_STORAGE_MANAGER, `publish store update event error, key = ${key} , reason : %{public}s`,
          JSON.stringify(err))
      } else {
        taroLogger.debug(TARO_STORAGE_MANAGER, `publish store update event success, key = ${key} `)
      }
    });
  }

  /**
   * 订阅TaroStorageUpdated事件
   */
  private subscribeTaroStorageUpdateEvent() {
    // 订阅者信息，其中的event字段需要替换为实际的事件名称。
    let storageUpdateSubscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: ['TaroStorageUpdated'], // 订阅TaroStorageUpdated事件
    };
    // 创建订阅者回调
    commonEventManager.createSubscriber(storageUpdateSubscribeInfo,
      (err: BusinessError, data: commonEventManager.CommonEventSubscriber) => {
        if (err) {
          return;
        }
        this.taroStorageUpdatedSubscriber = data;
        // 订阅公共事件回调
        if (this.taroStorageUpdatedSubscriber !== null) {
          commonEventManager.subscribe(this.taroStorageUpdatedSubscriber,
            (err: BusinessError, data: commonEventManager.CommonEventData) => {
              if (err) {
                taroLogger.error(TARO_STORAGE_MANAGER, `subscribeTaroStorageUpdateEvent error: ${JSON.stringify(err)}`)
                return;
              }
              if (data.parameters) {
                this.dispatchStorageUpdateEventToJS(data.parameters)
              }
            })
        } else {
          taroLogger.error(TARO_STORAGE_MANAGER,
            `subscribeTaroStorageUpdateEvent error: this.taroStorageUpdatedSubscriber is null or undefined`)
        }
      })
  }

  /**
   * 把StorageUpdate事件分发给前端
   * @param parameters
   */
  private dispatchStorageUpdateEventToJS(parameters: ESObject) {
    if (parameters.id && parameters.key && parameters.type) {
      if (parameters.id !== this.instanceId) {
        this.storageChangeListeners.forEach(listener => {
          listener(parameters.type, parameters.key)
        })
      }
    }
  }

  /**
   * 取消订阅TaroStorageUpdated事件
   */
  private unsubscribeTaroStorageUpdateEvent() {
    // subscriber为订阅事件时创建的订阅者对象
    if (this.taroStorageUpdatedSubscriber !== null) {
      commonEventManager.unsubscribe(this.taroStorageUpdatedSubscriber, (err: BusinessError) => {
        if (err) {
          taroLogger.error(TARO_STORAGE_MANAGER, `unsubscribeTaroStorageUpdateEvent error: ${JSON.stringify(err)}`)
        } else {
          this.taroStorageUpdatedSubscriber = null;
        }
      })
    }
  }
}