// TODO-ly 此类都需要重写，因为此类是es5的js

function isFunction(object) {
    if (typeof object === 'function') {
        // 如果是函数，直接返回 true
        return true;
    }
    return false;
}

function getAllFuns(object) {
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

function isFunctionOrObjectWithFunction(object) {
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

function isOnMethod(methodName) {
    const regex = /^on[A-Z]\w*$/;
    if (regex.test(methodName)) {
        return true // 以on开头的方法调用
    }
    return false
}

// 通信Channel层
window.Channel = {
    jsCallListeners: {},
    // listenerMap: {}, 弱引用自动取消
    registerJsCall(channelType, fun) {
        this.jsCallListeners[channelType] = fun
    },

    /**
     * methodCall的对象结构为：{call: string, argsJson: string, stubId: number}
     */
    nativeCall: function (channelType, object) {
        // 最终调用原生Channel的通信方法
        var objectJson = JSON.stringify(object)
        // @ts-ignore
        var resultJson = window.JSBridge && window.JSBridge.nativeMethod(channelType, objectJson)
        return resultJson && JSON.parse(resultJson)
    },

    /**
     * 给原生暴露的通信方法，原生调用"window.Channel.jsCall(objectId, 'xxx', 'xxxx')"
     */
    jsCall: function (channelType, objectJson) {
        console.log(`jsCall channelType=${channelType}, objectJson=${objectJson}`);
        // window.apiStubPool.onTransact(objectId, callName, argsJson)
        var fun = this.jsCallListeners[channelType]
        fun && fun(JSON.parse(objectJson))
    }
}

window.MethodChannel = {
    ChannelType: 'MethodChannel',

    init: function () {
        window.Channel.registerJsCall(this.ChannelType, function (object) {
            window.MethodChannel.__ArgsMethodStub(object)
        })
    },
    methodCallByNative: function (className, methodName, args, isAsync, autoRelease){
        // console.debug('nativeapi', 'appjs createNativeApiProxy args JSON: ' + JSON.stringify(args))
        // if (isAsync == undefined) {
        //     return Func()
        // }
        // console.debug('nativeapi', 'appjs createNativeApiProxy args JSON: ' + JSON.stringify(args))
        // console.debug('nativeapi', 'appjs createNativeApiProxy args: ' + args)

        const firstArg = args.length >= 1 ? args[0] : ''
        // 约定异步回调的方式，一次性回调，监听回调
        let isListener = isOnMethod(methodName.toString())
        let hasFun = isFunctionOrObjectWithFunction(firstArg)

        let argTypeIsFun = isFunction(firstArg)

        // 方法调用转换为数据
        var methodCall = {
            //修改了名称
            isAsync: isAsync,
            // 调用函数名
            call: `${className ? className : ''}\$${methodName.toString()}`,
            arg: {
                isFun: argTypeIsFun,
                properties: firstArg,
                funs: getAllFuns(firstArg),
                stubId: window.MethodChannel.__registerArgStub(firstArg, argTypeIsFun, autoRelease)
            },
        }
        return window.Channel.nativeCall(window.MethodChannel.ChannelType, methodCall)
    },
    //提交了一次到本地，只修改了app.js文件
    createNativeApiProxy: function (nativeApi) {
        return nativeApi
        // return new Proxy(nativeApi, {
        //     get(target, prop, receiver) {
        //         // 确保函数上的装饰器生效
        //         const originalValue = Reflect.get(target, prop, receiver);
        //
        //         if (typeof originalValue === 'function') {
        //             // const isSync = prop.toString().endsWith("BridgeSync")
        //             // const isAsync = prop.toString().endsWith("BridgeAsync")
        //             // if(isSync || isAsync) { // 走代理
        //             const className = target.constructor.name;
        //             return function (...args) {
        //                 const isAsync = args[1]?.isAsync
        //                 const autoRelease = args[1]?.autoRelease ?? false
        //
        //                 console.debug('nativeapi', 'appjs createNativeApiProxy args JSON: ' + JSON.stringify(args))
        //                 if (isAsync == undefined) {
        //                     return Func()
        //                 }
        //                 console.debug('nativeapi', 'appjs createNativeApiProxy args JSON: ' + JSON.stringify(args))
        //                 console.debug('nativeapi', 'appjs createNativeApiProxy args: ' + args)
        //
        //                 const firstArg = args.length >= 1 ? args[0] : ''
        //                 // 约定异步回调的方式，一次性回调，监听回调
        //                 let isListener = isOnMethod(prop.toString())
        //                 let hasFun = isFunctionOrObjectWithFunction(firstArg)
        //
        //                 let argTypeIsFun = isFunction(firstArg)
        //
        //                 // 方法调用转换为数据
        //                 var methodCall = {
        //                     //修改了名称
        //                     isAsync: isAsync,
        //                     // 调用函数名
        //                     call: `${className ? className : ''}\$${prop.toString()}`,
        //                     arg: {
        //                         isFun: argTypeIsFun,
        //                         properties: firstArg,
        //                         funs: getAllFuns(firstArg),
        //                         stubId: window.MethodChannel.__registerArgStub(firstArg, argTypeIsFun, autoRelease)
        //                     },
        //                 }
        //                 return window.Channel.nativeCall(window.MethodChannel.ChannelType, methodCall)
        //             }
        //         }
        //         // }
        //
        //         // 直接返回
        //         return originalValue;
        //     }
        // });
    },

    _NextId: 0, // 初始ID值
    _stubMap: {},
    __registerArgStub: function (argObject, isFun, autoRelease) {
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
    __ArgsMethodStub: function (nativeArg) {
        const {call, args, stubId} = nativeArg

        const stub = this._stubMap[stubId];
        console.debug('nativeapi', 'appjs the __registerArgStub nativeArg JSON: ' + JSON.stringify(nativeArg))
        if (!stub) {
            console.debug('nativeapi', 'appjs the __registerArgStub argsStub hash been deleted: ')
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
window.MethodChannel.init()

