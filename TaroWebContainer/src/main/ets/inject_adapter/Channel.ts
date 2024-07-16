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
import { taroLogger } from '../utils/Logger'

export class Channel {
  // TODO-ly 当前的实现只适合单实例，如果出现多实例Web容器，当前的实现就会有问题
  private runJavascriptFun?: (jsCode: string)=>void
  setRunJavascriptFun(fun: (jsCode: string)=>void){
    this.runJavascriptFun = fun
  }
  removeRunJavascriptFun(){
    this.runJavascriptFun = null
  }

  private channelListeners: Map<string, (object: any)=>any>
  constructor() {
    this.channelListeners = new Map<string, (object: any)=>any>();
  }
  registerChannel(channelType: string, fun: (object: any)=>any){
    this.channelListeners.set(channelType, fun)
  }

  call(channelType: string, objectJson: string): any{
    const fun = this.channelListeners.get(channelType)
    if(!fun) {
      return undefined;
    }
    const result = fun(JSON.parse(objectJson))
    return JSON.stringify(result);
  }

  jsCall(channelType: string, object: object){
    let jsCode = `window.Channel.nativeCallJS('${channelType}', ${JSON.stringify(object)})`
    this.runJavascriptFun && this.runJavascriptFun(jsCode)
  }
}
// export const ChannelInstance: Channel = new Channel();



const PROMISE_STATUS_PENDING = 'pending';
const PROMISE_STATUS_FULFILLED = 'fulfilled';
const PROMISE_STATUS_REJECTED = 'rejected';
export class MethodChannel {
  private ChannelType = 'MethodChannel'
  private listenerMap = new Map()
  private methodPools = new Map<string, (arg: any)=>any>()
  private channel: Channel
  private promiseStatus = {
    status: PROMISE_STATUS_PENDING,
    result: undefined
  }

  // TODO-ly 改为装饰器实现
  registerMethod(methodName: string, fun: (arg: any, objectId?: number)=>any) {
    if(this.methodPools.has(methodName)){
      return
    }
    this.methodPools.set(methodName, fun)
  }
  registerMethods(className: string, object: object){
    for (const methodName of Object.keys(object)) {
      const method = object[methodName]
      if (typeof method === 'function') {
        // 注册
        let allName:string = `${className}$${methodName}`
        this.registerMethod(allName, (arg: any) => {
          taroLogger.debug('InvokeNativeApi', allName)
          return object[methodName].call(null, arg)
        })
      }
    }
  }

  constructor(channel: Channel) {
    this.channel = channel
    this.channel.registerChannel(this.ChannelType, (object: any)=>{
      return this.call(object)
    })
    // 注册"GetPromiseStatus"方法
    this.registerMethod('GetPromiseStatus', (arg: any, objectId?: number)=>{
      return this.promiseStatus
    })
  }

  call(object): any{
    const {callName, optionsMsg, callType} = object
    const fun = this.methodPools.get(callName)
    if(!fun) {
      return undefined;
    }

    const {type, properties, funs, objId} = optionsMsg

    let argProxy;
    if (objId == -1) { // 没有回调函数
      argProxy = properties;
    } else if(type == 'function') { // arg为函数
      if (this.listenerMap.has(objId)) {
        argProxy = this.listenerMap.get(objId)
      } else {
        argProxy = (...args)=>{//function (...args){
          const object = {
            call: '',
            args: args,
            stubId: objId,
          }
          this.channel.jsCall(this.ChannelType, object)
        }
        this.listenerMap.set(objId, argProxy)
      }
    } else {
      let argObject = properties ?? {};
      // 补充方法的声明
      for(const value of funs) {
        argObject[value] = (...args)=>{//function (...args){
          const object = {
            call: value,
            args: args,
            stubId: objId
          }
          this.channel.jsCall(this.ChannelType, object)
        }
      }
      // arg为对象
      argProxy = argObject;
    }
    const result = fun.call(null, argProxy)

    // 支持Promise返回值
    if(callType == 'sync' && (result instanceof Promise)) {
      this.promiseStatus.status = PROMISE_STATUS_PENDING
      this.promiseStatus.result = undefined
      result
        .then((res: any)=>{
          this.promiseStatus.status = PROMISE_STATUS_FULFILLED
          this.promiseStatus.result = res
        })
        .catch((err: any)=>{
          this.promiseStatus.status = PROMISE_STATUS_REJECTED
          this.promiseStatus.result = undefined
        })
      return "Promise_Result";
    }
    return result;
  }
}

// export const MethodChannelInstance: MethodChannel = new MethodChannel();