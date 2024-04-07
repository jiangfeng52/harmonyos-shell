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
  jsBridgeMode: function (mode: {
    isAsync: boolean,
    autoRelease?: boolean
  }) {
    return function (target: any, key: string, descriptor: PropertyDescriptor) {
      const className = target.constructor.name
      descriptor.value = function (...args: any[]) {

        const firstArg = args.length >= 1 ? args[0] : ''
        const objectId = args.length >= 2 ? args[1] : undefined

        let argTypeIsFun = isFunction(firstArg)
        // @ts-ignore
        let stubId = window.MethodChannel.__registerArgStub(firstArg, argTypeIsFun, mode?.autoRelease ?? true)
        if (argTypeIsFun) {
          // @ts-ignore
          if (window.MethodChannel._listenerMap.has(firstArg)) {
            // @ts-ignore
            stubId = window.MethodChannel._listenerMap.get(firstArg)
          } else {
            // @ts-ignore
            window.MethodChannel._listenerMap.set(firstArg, stubId)
          }
        }

        // 方法调用转换为数据
        var methodCall = {
          //修改了名称
          isAsync: mode?.isAsync ?? true,
          // 调用函数名
          call: `${className ? className : ''}\$${key.toString()}`,
          arg: {
            isFun: argTypeIsFun,
            properties: firstArg,
            funs: getAllFuns(firstArg),
            stubId: stubId,
            objectId: objectId,
          },
        }
        // @ts-ignore
        return window.Channel.nativeCall(window.MethodChannel.ChannelType, methodCall)
      }
    }
  },

  _NextId: 0, // 初始ID值
  _stubMap: {},
  _listenerMap: new Map(),
  __registerArgStub: function (argObject: any, isFun: boolean, autoRelease: boolean) {
    const hasFun = isFunctionOrObjectWithFunction(argObject)
    if (!hasFun) {
      return -1
    }
    var objectId = this._NextId++
    this._stubMap[objectId] = {
      object: argObject,
      isFun: isFun,
      autoRelease: autoRelease
    }
    return objectId
  },
  __ArgsMethodStub: function (nativeArg: any) {
    const {call, args, stubId} = nativeArg
    const stub = this._stubMap[stubId];
    if (!stub) {
      console.debug('nativeapi', 'appjs argsStub hash been deleted ')
      return;
    }
    const {object, isFun, autoRelease} = stub
    if (autoRelease) {
      delete this._stubMap[stubId]
    } else if (call == 'complete') {
      delete this._stubMap[stubId]
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

