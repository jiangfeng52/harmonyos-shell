/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
// 将Taro-storage 桥接到 native 的 kvStore中; 实现 native 和 web 数据共享
import distributedKVStore from '@ohos.data.distributedKVStore';
import { GlobalThis } from './GlobalThis'
import { wbLogger } from './Logger'
import { AsyncCallback, BusinessError } from '@ohos.base';

const STORAGE = "storage"
const STORE_ID = 'storeId'
export const KEY_PREFIX = "storeId_"

enum ErrorCode {
  NO_INIT_STORE = 30001,
  CHANNEL_ERROR = 30002,
}

interface EntryValue {
  key: string,
  value: string | number | boolean | Uint8Array,
}

const options: distributedKVStore.Options = {
  createIfMissing: true,
  encrypt: false,
  backup: false,
  autoSync: true,
  kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
  securityLevel: distributedKVStore.SecurityLevel.S2,
}


export class Storage {
  private kvManager: distributedKVStore.KVManager | undefined;
  public kvStore: distributedKVStore.SingleKVStore | undefined;

  constructor(context: Context, bundleName: string) {
    wbLogger.info(STORAGE, "do storage constructor");
    this.kvManager = distributedKVStore.createKVManager(
      {
        context: context, // sample context
        bundleName: bundleName, // sample bundle name
      }
    )
    this.kvManager.getKVStore(STORE_ID, options, (err, store: distributedKVStore.SingleKVStore) => {
      if (err) {
        wbLogger.error(STORAGE, `Failed to getKVStore is ${err.code},message is ${err.message}`);
        return;
      }
      this.kvStore = store
      GlobalThis.getInstance().setKvStore('kvStore', store)
      wbLogger.info(STORAGE, "Succeeded in getting KVStore");
    });
  }

  /**
   * Writes a key-value pair of the string type into the {@code SingleKVStore} database.
   * <p>If you do not want to synchronize this key-value pair to other devices, set the write option in the local database.
   *
   * @param { string } key - Indicates the key. Length must be less than {@code MAX_KEY_LENGTH}.
   * @param { ESObject } data - 支持原生类型、Date、及能够通过`JSON.stringify`序列化的对象
   */
  put(key: string, data: ESObject, callback: AsyncCallback<void>) {
    if (!this.kvStore) {
      callback(
        { code: ErrorCode.NO_INIT_STORE, message: 'not init kvStore' } as BusinessError
      );
      return
    }
    const type = typeof data
    let obj: ESObject = {}
    if (type === 'symbol') {
      obj = { data: '' }
    } else {
      obj = { data }
    }
    this.kvStore.put(KEY_PREFIX + key, JSON.stringify(obj), callback)
  }

  /*
    批量插入数据
   */
  putBatch(entries: Map<string, ESObject>, callback: AsyncCallback<void>) {

  }

  /**
   * Deletes the key-value pair based on a specified key,
   * And delete the corresponding data from the localStorage.
   */
  delete(key: string, callback: AsyncCallback<void>) {
    if (!this.kvStore) {
      callback({ code: ErrorCode.NO_INIT_STORE, message: 'no init kvStore' } as BusinessError);
      return
    }
    this.kvStore?.delete(KEY_PREFIX + key, callback)
    // ChannelInstance.jsCallRemoveLocalStorage(key)
  }

  /**
   * Obtains the value of a specified key.
   */
  get(key: string, callback: AsyncCallback<boolean | string | number | Uint8Array>) {
    if (!this.kvStore) {
      callback({ code: ErrorCode.NO_INIT_STORE, message: 'no init kvStore' } as BusinessError, '');
      return
    }
    this.kvStore?.get(KEY_PREFIX + key, callback)
  }

  /**
   * Obtains all key-value pairs that match a specified key prefix.
   * @param { AsyncCallback<Entry[]> } callback - {Entry[]}: the list of all key-value pairs
   */
  getAllEntries(callback: AsyncCallback<EntryValue[]>) {
    if (!this.kvStore) {
      callback({ code: ErrorCode.NO_INIT_STORE, message: 'no init kvStore' } as BusinessError, []);
      return
    }

    this.kvStore?.getEntries(KEY_PREFIX, (err, items) => {
      if (err) {
        callback(err, []);
        return;
      }

      const processedItems = items.map((item): EntryValue => {
        return {
          key: item.key.substring(KEY_PREFIX.length),
          value: item.value.value,
        };
      });

      callback(null, processedItems);
    });
  }

  /**
   * Delete the data whose prefix is KEY_PREFIX in batches,
   * that is, the data stored in the sample application.
   */
  clear() {
    if (!this.kvStore) {
      wbLogger.error(STORAGE, `no init kvStore`)
    }
    this.kvStore?.getEntries(KEY_PREFIX, (err, items) => {
      if (err != undefined) {
        wbLogger.error(STORAGE, `Failed to get Entries.code is ${err.code},message is ${err.message}`)
      }
      for (let item of items) {
        this.kvStore?.delete(item.key, (err) => {
          if (err != undefined) {
            wbLogger.error(STORAGE, `Failed to delete.code is ${err.code},message is ${err.message}`)
          }
          wbLogger.info(STORAGE, `success to delete.code, key: ${item.key}`)
        })
      }
    })
  }
}