// Script for compiling build behavior. It is built in the build plug-in and cannot be modified currently.
export { appTasks } from '@ohos/hvigor-ohos-plugin';


NativeApi

function isFunction(object:any) {
  if (typeof object === 'function') {
    // 如果是函数，直接返回 true
    return true;
  }
  return false;
}

function getAllFuns(object:any) {
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

function isFunctionOrObjectWithFunction(object:any) {
  if(isFunction(object)) {
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
  jsCallListeners: {},
  // listenerMap: {}, 弱引用自动取消
  registerJsCall(channelType:string, fun:any) {
    this.jsCallListeners[channelType] = fun
  },

  /**
   * methodCall的对象结构为：{call: string, argsJson: string, stubId: number}
   */
  nativeCall: function (channelType:String, object:Object) {
    // 最终调用原生Channel的通信方法
    var objectJson = JSON.stringify(object)
    console.log(objectJson)
    // @ts-ignore
    var resultJson = window.JSBridge && window.JSBridge.nativeMethod(channelType, objectJson)
    return resultJson && JSON.parse(resultJson)
  },

  /**
   * 给原生暴露的通信方法，原生调用"window.Channel.jsCall(objectId, 'xxx', 'xxxx')"
   */
  jsCall: function (channelType:string, objectJson:object) {
    console.log(`jsCall channelType=${channelType}, objectJson=${JSON.stringify(objectJson)}`);
    var fun = this.jsCallListeners[channelType]
    fun && fun(objectJson)
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
  methodCallByNative: function (className:string, methodName:string, args:any, isAsync:boolean, autoRelease:boolean){

    const firstArg = args.length >= 1 ? args[0] : ''
    const objectId = args.length >= 2 ? args[1] : undefined

    let argTypeIsFun = isFunction(firstArg)
    // @ts-ignore
    let stubId = window.MethodChannel.__registerArgStub(firstArg, argTypeIsFun, autoRelease)
    if (argTypeIsFun) {
      if (this._listenerMap.has(firstArg)) {
        stubId = this._listenerMap.get(firstArg)
      } else {
        this._listenerMap.set(firstArg, stubId)
      }
    }

    // 方法调用转换为数据
    var methodCall = {
      //修改了名称
      isAsync: isAsync,
      // 调用函数名
      call: `${className ? className : ''}\$${methodName.toString()}`,
      arg: {
        isFun: argTypeIsFun,
        properties: firstArg,
        funs: getAllFuns(firstArg), // ['success', 'fail']
        stubId: stubId,
        objectId: objectId,
      },
    }
    // @ts-ignore
    return window.Channel.nativeCall(window.MethodChannel.ChannelType, methodCall)
  },
  //提交了一次到本地，只修改了app.js文件
  createNativeApiProxy: function (nativeApi:any) {
    return nativeApi
  },

  _NextId: 0, // 初始ID值
  _stubMap: {},
  // @ts-ignore
  _listenerMap: new Map(),
  __registerArgStub: function (argObject:any, isFun:boolean, autoRelease:boolean) {
    const hasFun = isFunctionOrObjectWithFunction(argObject)
    if(!hasFun) {
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
  __ArgsMethodStub: function (nativeArg:any) {
    const {call, args, stubId} = nativeArg

    const stub = this._stubMap[stubId];
    if (!stub) {
      console.debug('nativeapi', 'appjs argsStub hash been deleted ')
      return;
    }
    const {object, isFun, autoRelease} = stub
    if(autoRelease) {
      delete this._stubMap[stubId]
    }
    else if (call == 'complete') {
      delete this._stubMap[stubId]
    }

    if(isFun) {
      object && object(...args)
      return
    }
    if(args) {
      object[call].call(object, ...args)
    } else {
      object[call].call(object)
    }
  }
}
//@ts-ignore
window.MethodChannel.init()

hvigor-config.json5
    "@ohos/hvigor-ohos-plugin": "4.0.2",
    "@babel/core": "^7.17.4",
    "@babel/preset-env": "^7.16.7",
    "@babel/plugin-transform-runtime": "^7.17.0",
    "@babel/plugin-transform-typescript": "^7.23.6",
    "@babel/preset-typescript": "^7.23.3"


hvigorfile.ts
import { harTasks } from '@ohos/hvigor-ohos-plugin';
import { transformSync } from '@babel/core';
import * as fs from 'fs'
import presetEnv from '@babel/preset-env'
// import presetEnv from '@babel/preset-typescript'


export function customPluginFunction(str?: string) {
    return {
        pluginId: 'CustomPluginID',
        apply(pluginContext) {
            pluginContext.registerTask({
                // 编写自定义任务
                name: 'babelTranform',
                run: (taskContext) => {
                    const path = require('path');
                    let injectFilePath = path.join(taskContext.modulePath, "NativeApi", "inject.ts")
                    let rawFileContent = fs.readFileSync(injectFilePath, 'utf8')

                    const result = transformSync(rawFileContent, {
                        presets: [presetEnv],
                        plugins: ["@babel/plugin-transform-typescript"]
                    })
                    let outputFilePath = path.join(taskContext.modulePath, "src", "main", "resources", "rawfile", "native.js")
                    fs.writeFileSync(outputFilePath, result.code)
                },
                // 确认自定义任务插入位置
                postDependencies: ['default@PreBuild']
            })
        }
    }
}

export default {
    system: harTasks, /* Built-in plugin of Hvigor. It cannot be modified. */
    plugins: [customPluginFunction()]         /* Custom plugin to extend the functionality of Hvigor. */
}



