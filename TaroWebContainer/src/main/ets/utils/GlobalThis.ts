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
import { Context } from '@ohos.abilityAccessCtrl';
import distributedKVStore from '@ohos.data.distributedKVStore';

/**
 * 存储全局信息，构造单例对象
 */
export class GlobalThis {
  private constructor() {
  }

  private static instance: GlobalThis;
  private _uiContexts = new Map<string, Context>();
  private _kvStore = new Map<string, distributedKVStore.SingleKVStore>()
  private _RawFile = 'mps'
  private _diskUpdateEnable = true;

  public static getInstance(): GlobalThis {
    if (!GlobalThis.instance) {
      GlobalThis.instance = new GlobalThis();
    }
    return GlobalThis.instance;
  }

  getContext(key: string): Context | undefined {
    return this._uiContexts.get(key);
  }

  setContext(key: string, value: Context): void {
    this._uiContexts.set(key, value);
  }

  getKvStore(key: string): distributedKVStore.SingleKVStore | undefined {
    return this._kvStore.get(key);
  }

  setKvStore(key: string, value: distributedKVStore.SingleKVStore): void {
    this._kvStore.set(key, value);
  }
  setRawFile(rawFileName:string){
    this._RawFile = rawFileName
  }
  getRawFile(){
    return this._RawFile
  }
  setDiskUpdateEnable(value) {
    this._diskUpdateEnable = value;
  }

  getDiskUpdateEnable() {
    return this._diskUpdateEnable;
  }
}