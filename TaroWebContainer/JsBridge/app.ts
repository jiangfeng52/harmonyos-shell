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

interface ChannelHandler {
  registerJSBridge(options: any, callNative: (channelType: string, object: any) => any): any

  onNativeCallJS(object: any): void
}


// 通信Channel层
// @ts-ignore
window.Channel = {
  channelHandlerMap: new Map<string, ChannelHandler>(),
  // listenerMap: {}, 弱引用自动取消
  registerJsCall(channelType: string, fun: Function) {
    this.channelHandlerMap.set(channelType, fun)
  },

  jsBridge: function (options: {
    channelType: string,
    callType: 'async' | 'sync' | 'listener' | 'removeListener'
  }) {
    return this.channelHandlerMap.get(options.channelType).registerJSBridge(options, this.jsCallNative)
  },

  /**
   * methodCall的对象结构为：{call: string, argsJson: string, stubId: number}
   */
  jsCallNative:  (channelType: string, object: any) => {
    // 最终调用原生Channel的通信方法
    var objectJson = JSON.stringify(object)
    // @ts-ignore
    var resultJson = window.JSBridge && window.JSBridge.nativeMethod(channelType, objectJson)
    return resultJson && JSON.parse(resultJson)
  },

  /**
   * 给原生暴露的通信方法，原生调用"window.Channel.nativeCallJS(objectId, 'xxx', 'xxxx')"
   */
  nativeCallJS: function (channelType: string, object: any) {
    var handler = this.channelHandlerMap.get(channelType)
    handler && handler.onNativeCallJS(object)
  }
}

const MethodChannelType = 'MethodChannel'

class MethodChannelHandler implements ChannelHandler {
  registerJSBridge(options: any, callNative: (channelType: string, object: any) => any): any {
    return (target: any, key: string, descriptor: PropertyDescriptor) => {
      const className = target.constructor.name
      descriptor.value = (...args: any[]) => {

        const firstArg = args.length >= 1 ? args[0] : ''

        let argTypeIsFun = isFunction(firstArg)
        let objId = this.__registerArgStub(firstArg, argTypeIsFun)

        // 方法调用转换为数据
        var methodCall = {
          transcationId: 1,
          //修改了名称
          callType: options.callType,
          from: 'Global',
          // 调用函数名
          callName: `${className ? className : ''}\$${key.toString()}`,
          optionsMsg: {
            type: argTypeIsFun ? 'function' : 'object',
            properties: firstArg,
            funs: getAllFuns(firstArg),
            objId: objId,
          },
        }
        const result = callNative(MethodChannelType, methodCall)

        if (options.callType == 'sync' && result === 'Promise_Result') {
          let count = 0
          while (count < 20000) {
            count++
            if (count % 2000 === 0) {
              const promiseStatus = this.getPromiseStatus(callNative)
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
  }

  onNativeCallJS(nativeArg: any): void {
    const { call, args, stubId } = nativeArg
    const stub = this._stubMap[stubId];
    if (!stub) {
      console.debug('nativeapi', 'appjs argsStub hash been deleted ')
      return;
    }
    const { object, isFun } = stub
    if (call == 'success' || call == 'fail') {
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

  getPromiseStatus(callNative: (channelType: string, object: any) => any) {
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
    return callNative(MethodChannelType, methodCall)
  }

  _NextTranscationId = 0 // 初始TranscationID值
  _NextId = 0 // 初始ID值
  _stubMap = {}
  _transcationMap = new Map()

  __registerArgStub(argObject: any, isFun: boolean) {
    const hasFun = isFunctionOrObjectWithFunction(argObject)
    if (!hasFun) {
      return -1
    }
    let objectId = this._NextId++
    this._stubMap[objectId] = {
      object: argObject,
      isFun: isFun
    }
    return objectId
  }
}

// @ts-ignore
window.MethodChannel = {

  jsBridgeMode: function (mode: {callType: 'async' | 'sync' | 'listener' | 'removeListener'}) {
    mode['channelType'] = MethodChannelType
    // @ts-ignore
    return window.Channel.jsBridge(mode)
  },

  //TODO 同层绘制时会调用此方法，后续处理
  unRegisterArgStub: function (argObject: any) {
  }
}
// @ts-ignore
window.Channel.registerJsCall(MethodChannelType, new MethodChannelHandler())

