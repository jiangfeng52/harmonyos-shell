import { distributedKVStore } from '@kit.ArkData';
import { taroLogger } from '../utils/Logger';
import { AsyncCallback, BusinessError } from '@ohos.base';
import { CallbackResult, SuccessCallbackResult } from './TaroApi';
import { HashMap } from '@kit.ArkTS';

const TARO_STORAGE = "taro_storage"
const STORE_ID = 'TaroStorage'
export const KEY_PREFIX = "TaroStorage_"

const KEY_HOME_PAGE_KEYS_PREFIX = "home_page_keys_"

enum ErrorCode {
  NO_INIT_STORE = 30001,
  CHANNEL_ERROR = 30002,
}

export interface GetOptions {
  key: string,
  fail?: (res: CallbackResult)=>void
  success?: (res: SuccessCallbackResult<string>)=>void
}

export interface RemoveOptions {
  /** 本地缓存中指定的 key */
  key: string
  /** 接口调用失败的回调函数 */
  fail?: (res: CallbackResult) => void
  /** 接口调用成功的回调函数 */
  success?: (res: CallbackResult) => void
}

export interface SetOptions {
  data: string
  /** 本地缓存中指定的 key */
  key: string
  /** 接口调用失败的回调函数 */
  fail?: (res: CallbackResult) => void
  /** 接口调用成功的回调函数 */
  success?: (res: CallbackResult) => void
}

export interface ClearOptions {
  /** 接口调用失败的回调函数 */
  fail?: (res: CallbackResult) => void
  /** 接口调用成功的回调函数 */
  success?: (res: CallbackResult) => void
}

export interface InfoOptions {
  /** 接口调用失败的回调函数 */
  fail?: (res: CallbackResult) => void
  /** 接口调用成功的回调函数 */
  success?: (option: InfoSuccessCallbackOption) => void
}

export interface InfoSuccessCallbackOption {
  /** 当前占用的空间大小, 单位 KB */
  // currentSize: number
  /** 当前 storage 中所有的 key */
  keys: string[]
  /** 限制的空间大小，单位 KB */
  // limitSize: number
}

export interface BatchGetPageShowDataOptions {
  /** 接口调用失败的回调函数 */
  fail?: (res: CallbackResult) => void
  /** 接口调用成功的回调函数 */
  success?: (options: PageShowDataSuccessCallbackOptions) => void
}

export interface PageShowDataSuccessCallbackOptions {
  keys: string[],
  values: string[]
}

export interface UpdatePageShowDataKeysOptions {
  keys: string[],
  fail?: (res: CallbackResult) => void
  success?: (res: CallbackResult) => void
}



class TaroStorage {

  private kvManager: distributedKVStore.KVManager | undefined;
  private kvStore: distributedKVStore.SingleKVStore | undefined;
  private createKVStorePromise: Promise<void> | undefined

  private pageShowDataPromiseMap = new HashMap<string, Promise<PageShowDataSuccessCallbackOptions>>()

  init(context: Context, bundleName: string){
    if(this.kvStore !== undefined) {
      return
    }

    taroLogger.info(TARO_STORAGE, "do storage constructor");
    this.kvManager = distributedKVStore.createKVManager(
      {
        context: context, // sample context
        bundleName: bundleName, // sample bundle name
      }
    )
    const options: distributedKVStore.Options = {
      createIfMissing: true,
      encrypt: false,
      backup: false,
      autoSync: true,
      kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
      securityLevel: distributedKVStore.SecurityLevel.S2,
    }
    this.createKVStorePromise = this.kvManager.getKVStore(STORE_ID, options)
      .then((store: distributedKVStore.SingleKVStore) => {
        this.kvStore = store
        // GlobalThis.getInstance().setKvStore('kvStore', store)
        taroLogger.info(TARO_STORAGE, "Succeeded in getting KVStore");
        // 获取首屏keys
      })
      .catch((err: BusinessError)=>{
        taroLogger.error(TARO_STORAGE, `Failed to getKVStore is ${err.code},message is ${err.message}`);
      })
  }

  pageToAppear(indexHtmlPath: string){
    // 调用太快，kvStore还没有回调
    const conPromise = this.createKVStorePromise?.then(()=>{return this.batchGetPageShowDataFromDisk(indexHtmlPath)})
    this.pageShowDataPromiseMap.set(indexHtmlPath, conPromise)
  }
  pageToDisappear(indexHtmlPath: string){
    this.pageShowDataPromiseMap.remove(indexHtmlPath)
  }

  verifyKVStore(fail?: (res: CallbackResult)=>void){
    if (this.kvStore === undefined) {
      fail && fail({errMsg:`TaroStorage fail: kvStore is not created}`})
      taroLogger.error(TARO_STORAGE, 'TaroStorage fail: kvStore is not created')
    }
  }

  getByPromise(options: GetOptions): Promise<SuccessCallbackResult<string>> {
    return new Promise((resolve: Function, reject: Function)=>{
      this.get({
        key: options.key,
        fail: (res: CallbackResult)=>{
          reject(res)
        },
        success: (res: SuccessCallbackResult<string>)=>{
          resolve(res)
        }
      })
    })
  }
  get(options: GetOptions) {
    const key:string = options.key
    taroLogger.debug(TARO_STORAGE, 'get(key=%{public}s)', key)

    this.verifyKVStore(options.fail)

    this.kvStore?.get(KEY_PREFIX + key, (err, data) => {
      if (err?.code === 15100004) {
        // Not found.
        taroLogger.debug(TARO_STORAGE, 'get(key=%{public}s), value=%{public}s', key, '')
        options.success && options.success({errMsg:'getStorage fail: not found.', data: '', key: key })
        return ;
      }
      if (err) {
        taroLogger.error(TARO_STORAGE, 'get(key=%{public}s, err.code=%{public}s)', key, err?.code)
        options.fail && options.fail({errMsg:`getStorage fail: ${JSON.stringify(err)}`})
        return ;
      }
      taroLogger.debug(TARO_STORAGE, 'get(key=%{public}s), value=%{public}s', key, data)
      options.success && options.success({errMsg:'ok', data: data.toString(), key: key })
    })
  }

  set(options: SetOptions){
    const key:string = options.key
    const data:string = options.data
    taroLogger.debug(TARO_STORAGE, 'set(key=%{public}s)', key)

    this.verifyKVStore(options.fail)

    this.kvStore?.put(KEY_PREFIX + key, data, (err) => {
      if (err) {
        options.fail && options.fail( {errMsg:`setStorage fail: ${JSON.stringify(err)}`})
        taroLogger.error(TARO_STORAGE, JSON.stringify(err))
      } else {
        options.success && options.success({errMsg:'ok'})
      }
    })
  }

  remove(options: RemoveOptions){
    const key:string = options.key
    taroLogger.debug(TARO_STORAGE, 'remove(key=%{public}s)', key)

    this.verifyKVStore(options.fail)

    this.kvStore?.delete(KEY_PREFIX + key, (err) => {
      if (err) {
        options.fail && options.fail({ errMsg:`removeStorage fail: ${JSON.stringify(err) }` })
        taroLogger.error(TARO_STORAGE, `delete data fail: ${JSON.stringify(err)}`)
      } else{
        options.success && options.success({errMsg:'ok'})
      }
    })
  }

  clear(options: ClearOptions){
    taroLogger.debug(TARO_STORAGE, `clear`)

    this.verifyKVStore(options.fail)

    try {
      this.kvStore?.getEntries(KEY_PREFIX, (err, items) => {
        if (err) {
          options.fail && options.fail({errMsg:`clearStorage fail: ${JSON.stringify(err)}`})
          taroLogger.error(TARO_STORAGE, JSON.stringify(err))
          return
        }
        if (!items) {
          options.success && options.success({ errMsg:'ok' })
          return
        }
        const keys = new Array<string>()
        for (let item of items) {
          keys.push(item.key)
        }
        this.kvStore?.deleteBatch(keys, (err) => {
          if (err) {
            options.fail && options.fail({errMsg:`clearStorage fail: ${JSON.stringify(err)}`})
          }
          else {
            options.success && options.success({ errMsg:'ok' })
          }
        })
      })
    } catch (err) {
      options.fail && options.fail({errMsg:`clearStorage fail: ${JSON.stringify(err)}`})
      taroLogger.error(TARO_STORAGE, `Failed to clear data is ${err.code},message is ${err.message}`)
    }
  }

  getInfo(options: InfoOptions){
    this.verifyKVStore(options.fail)

    taroLogger.debug(TARO_STORAGE, `getStorageInfo`)

    this.kvStore?.getEntries(KEY_PREFIX, (err, items) => {
      if (err) {
        options.fail && options.fail({errMsg:`getStorageInfo fail: ${JSON.stringify(err)}`})
        taroLogger.error(TARO_STORAGE, JSON.stringify(err))
      } else {
        const keys:string[] = []
        for (let item of items) {
          keys.push(item.key.substring(KEY_PREFIX.length))
        }
        options.success && options.success({ keys: keys })
      }
    })
  }

  batchGetPageShowData(indexHtmlPath: string, options: BatchGetPageShowDataOptions) {
    // 冷启动的Promise只使用一次
    let batchPromise = this.pageShowDataPromiseMap.remove(indexHtmlPath);
    // 如果冷启动的Promise已经使用过了，就重新创建重新获取，不再复用
    // 场景：调试时，刷新页面时，如果一直复用容器进入时的Promise对象，会导致值不会更新
    if (batchPromise === undefined) {
      batchPromise = this.batchGetPageShowDataFromDisk(indexHtmlPath)
      // options.fail && options.fail({errMsg:`getStorageInfo fail: batchPromise is not exist}`})
      // return ;
    }
    batchPromise
      .then((res: PageShowDataSuccessCallbackOptions)=>{
        options.success && options.success(res)
      })
      .catch((err: BusinessError)=>{
        options.fail && options.fail({errMsg:`getStorageInfo fail: ${JSON.stringify(err)}`})
      })
  }

  batchGetPageShowDataFromDisk(indexHtmlPath: string) : Promise<PageShowDataSuccessCallbackOptions>{
    return this.getByPromise({key: KEY_HOME_PAGE_KEYS_PREFIX + indexHtmlPath})
      .then((res: SuccessCallbackResult<string>)=>{
        taroLogger.debug(TARO_STORAGE, 'batchGetPageShowDataFromDisk111 %{public}s', res.data)

        if(res.data === "") {
          // 不存在
          return Promise.reject({code: 404, data: 'page show data keys is not exist!!!'})
        }

        // res 解析为数组
        try {
          const keys: string[] = JSON.parse(res.data)
          const promises = keys.map((item)=>this.getByPromise({key: item}))
          return Promise.all(promises)
        } catch (err) {
          return Promise.reject(err)
        }
      })
      .then((resArray: Array<SuccessCallbackResult<string>>)=>{
        taroLogger.debug(TARO_STORAGE, 'batchGetPageShowDataFromDisk222 %{public}s', resArray)

        const result: PageShowDataSuccessCallbackOptions = {
          keys: [],
          values: []
        }
        for (let index = 0; index < resArray.length; index++) {
          const successCallbackResult = resArray[index];
          result.keys.push(successCallbackResult.key)
          result.values.push(successCallbackResult.data)
        }

        taroLogger.debug(TARO_STORAGE, 'batchGetPageShowDataFromDisk333 %{public}s', result)
        return result
      })
  }
  updatePageShowDataKeys(indexHtmlPath: string, options: UpdatePageShowDataKeysOptions){
    this.set({
      key: KEY_HOME_PAGE_KEYS_PREFIX + indexHtmlPath,
      data: JSON.stringify(options.keys),
      fail: options.fail,
      success: options.success
    })
  }
}

export const taroStorage = new TaroStorage()