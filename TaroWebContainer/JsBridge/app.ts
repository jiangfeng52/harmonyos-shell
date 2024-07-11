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

function isFunction(object: any): boolean {
  if (typeof object === 'function') {
    // 如果是函数，直接返回 true
    return true;
  }
  return false;
}

function getAllFuns(object: any): string[] {
  if (typeof object !== 'object' || object === null) {
    return [];
  }

  const funs = []
  // 如果是对象，遍历对象的每个属性，检查属性是否是函数
  for (const key in object) {
    if (object.hasOwnProperty(key) && typeof object[key] === 'function') {
      funs.push(key)
    }
  }
  return funs
}

function isFunctionOrObjectWithFunction(object: any): boolean {
  if (isFunction(object)) {
    return true
  }

  if (typeof object !== 'object' || object === null) {
    return false;
  }

  // 如果是对象，遍历对象的每个属性，检查属性是否是函数
  for (const key in object) {
    if (object.hasOwnProperty(key) && typeof object[key] === 'function') {
      return true;
    }
  }
  return false
}


// 通信Channel层
// @ts-ignore
window.Channel = {
  jsCallListeners: new Map(),
  // listenerMap: {}, 弱引用自动取消
  registerJsCall(channelType: string, fun: Function) {
    this.jsCallListeners.set(channelType, fun)
  },

  /**
   * methodCall的对象结构为：{call: string, argsJson: string, stubId: number}
   */
  nativeCall: function (channelType: string, object: any) {
    // 最终调用原生Channel的通信方法
    var objectJson = JSON.stringify(object)
    // @ts-ignore
    var resultJson = window.JSBridge && window.JSBridge.nativeMethod(channelType, objectJson)
    return resultJson && JSON.parse(resultJson)
  },

  /**
   * 给原生暴露的通信方法，原生调用"window.Channel.jsCall(objectId, 'xxx', 'xxxx')"
   */
  jsCall: function (channelType: string, object: any) {
    var fun = this.jsCallListeners.get(channelType)
    fun && fun(object)
  }
}
// @ts-ignore
window.MethodChannel = {
  ChannelType: 'MethodChannel',

  init: function () {
    // @ts-ignore
    window.Channel.registerJsCall(this.ChannelType, function (object) {
      // @ts-ignore
      window.MethodChannel.__ArgsMethodStub(object)
    })
  },
  getPromiseStatus: function (){
    // 方法调用转换为数据
    var methodCall = {
      //修改了名称
      isAsync: false,
      // 调用函数名
      call: `GetPromiseStatus`,
      arg: {
        isFun: false,
        properties: '',
        funs: '',
        stubId: -1,
        objectId: -1,
      },
    }
    // @ts-ignore
    return window.Channel.nativeCall(window.MethodChannel.ChannelType, methodCall)
  },
  unRegisterArgStub: function (argObject: any) {
    const stubId = this._listenerMap.get(argObject);
    delete this._stubMap[stubId];
    this._listenerMap.delete(argObject)
  },
  jsBridgeMode: function (mode: {
    isAsync: boolean
  }) {
    return function (target: any, key: string, descriptor: PropertyDescriptor) {
      const className = target.constructor.name
      descriptor.value = function (...args: any[]) {

        const firstArg = args.length >= 1 ? args[0] : ''

        let argTypeIsFun = isFunction(firstArg)
        // @ts-ignore
        let stubId = window.MethodChannel.__registerArgStub(firstArg, argTypeIsFun)

        const isAsync = mode?.isAsync ?? true;

        // 方法调用转换为数据
        var methodCall = {
          //修改了名称
          isAsync:isAsync,
          // 调用函数名
          call: `${className ? className : ''}\$${key.toString()}`,
          arg: {
            isFun: argTypeIsFun,
            properties: firstArg,
            funs: getAllFuns(firstArg),
            stubId: stubId,
          },
        }
        // @ts-ignore
        const result = window.Channel.nativeCall(window.MethodChannel.ChannelType, methodCall)

        if (!isAsync && result === 'Promise_Result') {
          let count = 0
          while (count < 20000) {
            count++
            if (count % 2000 === 0) {
              // @ts-ignore
              const promiseStatus = window.MethodChannel.getPromiseStatus()
              if (promiseStatus.status === 'pending') {
                continue
              }
              return promiseStatus.result
            }
          }
          return undefined
        }

        return result
      }
    }
  },

  _NextId: 0, // 初始ID值
  _stubMap: {},
  _listenerMap: new Map(),
  __registerArgStub: function (argObject: any, isFun: boolean) {
    const hasFun = isFunctionOrObjectWithFunction(argObject)
    if (!hasFun) {
      return -1
    }
    // 尝试从map中取出变量id，如果有，直接返回对应id
    let objectId = this._listenerMap.get(argObject)
    if (objectId){
      return objectId
    }
    objectId = this._NextId++
    this._stubMap[objectId] = {
      object: argObject,
      isFun: isFun
    }
    // 将变量存储到map中，防止相同变量多次注册
    this._listenerMap.set(argObject, objectId)
    return objectId
  },
  __ArgsMethodStub: function (nativeArg: any) {
    const {call, args, stubId} = nativeArg
    const stub = this._stubMap[stubId];
    if (!stub) {
      console.debug('nativeapi', 'appjs argsStub hash been deleted ')
      return;
    }
    const {object, isFun} = stub
    if (call == 'success' || call == 'fail') {
      delete this._stubMap[stubId]
      delete this._listenerMap[object]
      this._listenerMap.delete(object)
    }

    if (isFun) {
      object && object(...args)
      return
    }
    if (args) {
      object[call].call(object, ...args)
    } else {
      object[call].call(object)
    }
  }
}
// @ts-ignore
window.MethodChannel.init()

// @ts-ignore
window.NativeMethod = {
  sync: function () {
    // @ts-ignore
    return window.MethodChannel.jsBridgeMode({isAsync: false})
  },
  async: function () {
    // @ts-ignore
    return window.MethodChannel.jsBridgeMode({isAsync: true})
  },
  listener: function () {
    // @ts-ignore
    return window.MethodChannel.jsBridgeMode({isAsync: true})
  },
  removeListener: function () {
    // @ts-ignore
    return window.MethodChannel.jsBridgeMode({isAsync: true})
  }
}
