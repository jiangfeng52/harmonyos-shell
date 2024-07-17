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

/**
 * JSBridge通道处理器
 */
interface ChannelHandler {
  /**
   * 获取当前ChannelHandler对应的ChannelType
   * @returns ChannelType
   */
  getChannelType(): string

  /**
   * 前端装饰器方法
   * @param options
   * @param callNative 调用native的方法
   * @returns
   */
  registerJSBridge(options: any, callNative: (channelType: string, object: any) => any): any

  /**
   * 原生调用JS方法
   * @param object
   */
  onNativeCallJS(object: any): void
}


// 通信Channel层
// @ts-ignore
window.Channel = {
  channelHandlerMap: new Map<string, ChannelHandler>(),

  /**
   * 注册Channel处理类
   * @param channelHandler
   */
  registerChannelHandler(channelHandler: ChannelHandler) {
    this.channelHandlerMap.set(channelHandler.getChannelType(), channelHandler)
  },

  /**
   * 对前端暴露的装饰器方法
   */
  jsBridge: function (options: {
    channelType: string,
    callType: 'async' | 'sync' | 'listener' | 'removeListener'
  }) {
    return this.channelHandlerMap.get(options.channelType)
      .registerJSBridge(options, (channelType: string, object: any) => {
        // 最终调用原生Channel的通信方法
        var objectJson = JSON.stringify(object)
        // @ts-ignore
        var resultJson = window.JSBridge && window.JSBridge.nativeMethod(channelType, objectJson)
        return resultJson && JSON.parse(resultJson)
      })
  },

  /**
   * 给原生暴露的通信方法，原生调用"window.Channel.nativeCallJS(channelType, object)"
   */
  nativeCallJS: function (channelType: string, object: any) {
    var handler = this.channelHandlerMap.get(channelType)
    handler && handler.onNativeCallJS(object)
  }
}

class MethodChannelHandler implements ChannelHandler {
  channelType = 'MethodChannel'
  _NextTranscationId = 1 // 初始TranscationID值

  _transcationMap = new Map<number, Map<number, any>>()

  getChannelType(): string {
    return this.channelType
  }

  registerJSBridge(options: any, callNative: (channelType: string, object: any) => any): any {
    return (target: any, key: string, descriptor: PropertyDescriptor) => {
      const className = target.constructor.name
      descriptor.value = (...args: any[]) => {

        const firstArg = args.length >= 1 ? args[0] : ''

        let argTypeIsFun = isFunction(firstArg)
        let callId = this.generateCallId(firstArg)

        let transcationId = this.registerTranscation(callId, firstArg, argTypeIsFun ? 'functino' : 'object', options.callType, 'Global')

        // 方法调用转换为数据
        var methodCall = {
          transcationId: transcationId,
          //修改了名称
          callType: options.callType,
          from: 'Global',
          // 调用函数名
          callName: `${className ? className : ''}\$${key.toString()}`,
          optionsMsg: {
            type: argTypeIsFun ? 'function' : 'object',
            properties: firstArg,
            funs: getAllFuns(firstArg),
            callId: callId,
          },
        }
        const result = callNative(this.channelType, methodCall)

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
    const { call, args, transcationId, optionsMsg } = nativeArg
    let transcation = this._transcationMap.get(transcationId)
    if (!transcation) {
      console.debug('nativeapi', 'appjs transcation hash been deleted ')
      return;
    }
    let obj = transcation.get(optionsMsg.callId);
    if (!obj) {
      console.debug('nativeapi', 'appjs obj hash been deleted ')
      return;
    }
    const { options, isFun } = obj
    if (call == 'success' || call == 'fail') {
      this._transcationMap.delete(transcationId)
    }

    if (isFun) {
      options && options(...args)
      return
    }
    if (args) {
      options[call].call(options, ...args)
    } else {
      options[call].call(options)
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
        callId: -1,
      },
    }
    return callNative(this.channelType, methodCall)
  }

  _NextId = 1 // 初始ID值

  // _stubMap = {}

  generateCallId(argObject: any) {
    const hasFun = isFunctionOrObjectWithFunction(argObject)
    if (!hasFun) {
      return -1
    }
    let callId = this._NextId++
    return callId
  }

  registerTranscation(callId: number, argObject: any, argType: string, callType: string, fromType: string) {
    if (callId === -1) {
      return -1
    }
    let transcationId = this._NextTranscationId++
    let obj = {
      type: argType,
      options: argObject,
      callType: callType,
      fromType: fromType
    }
    let callMap = new Map()
    callMap.set(callId, obj)
    this._transcationMap.set(transcationId, callMap)
    return transcationId
  }
}

// @ts-ignore
window.MethodChannel = {

  jsBridgeMode: function (mode: { callType: 'async' | 'sync' | 'listener' | 'removeListener' }) {
    mode['channelType'] = 'MethodChannel'
    // @ts-ignore
    return window.Channel.jsBridge(mode)
  },

  //TODO 同层绘制时会调用此方法，后续处理
  unRegisterArgStub: function (argObject: any) {
  }
}
// @ts-ignore
window.Channel.registerChannelHandler(new MethodChannelHandler())

