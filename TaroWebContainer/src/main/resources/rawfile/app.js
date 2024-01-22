// TODO-ly 此类都需要重写，因为此类是es5的js

function isFunctionOrObjectWithFunction(object) {
    if (typeof object === 'function') {
        // 如果是函数，直接返回 true
        return true;
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
    //提交了一次到本地，只修改了app.js文件
    createNativeApiProxy: function (nativeApi) {
        return new Proxy(nativeApi, {
            get(target, prop, receiver) {
                if (typeof target[prop] === 'function') {
                    const Func = target[prop]
                    // const isSync = prop.toString().endsWith("BridgeSync")
                    // const isAsync = prop.toString().endsWith("BridgeAsync")
                    // if(isSync || isAsync) { // 走代理
                    const className = target.constructor.name;
                    return function (...args) {
                        const isAsync = args[1]?.isAsync
                        const autoRelease = args[1]?.autoRelease

                        console.debug('nativeapi', 'appjs createNativeApiProxy args JSON: ' + JSON.stringify(args))
                        if (isAsync == undefined) {
                            return Func()
                        }
                        console.debug('nativeapi', 'appjs createNativeApiProxy args JSON: ' + JSON.stringify(args))
                        console.debug('nativeapi', 'appjs createNativeApiProxy args: ' + args)

                        const firstArg = args.length >= 1 ? args[0] : ''
                        // 约定异步回调的方式，一次性回调，监听回调
                        let isListener = isOnMethod(prop.toString())
                        let hasFun = isFunctionOrObjectWithFunction(firstArg)

                        // 方法调用转换为数据
                        var methodCall = {
                            //修改了名称
                            isAsync: isAsync,
                            call: `${className ? className : ''}\$${prop.toString()}`,
                            isListener: isListener,
                            arg: firstArg,
                            stubId: hasFun ? window.MethodChannel.__registerArgStub(firstArg, isListener) : -1,
                            //增加了字段，channel端需要做适配
                            autoRelease: autoRelease
                        }
                        return window.Channel.nativeCall(window.MethodChannel.ChannelType, methodCall)
                    }
                }
                // }

                // 直接返回
                return target[prop];
            }
        });
    },

    _NextId: 0, // 初始ID值
    _argsStubMap: {},
    _listenerMap: {}, // TODO 弱引用自动取消
    __registerArgStub: function (arg, isListener) {
        var objectId = this._NextId++
        if (isListener) {
            this._listenerMap[objectId] = arg
        } else {
            this._argsStubMap[objectId] = arg
        }
        return objectId
    },
    __ArgsMethodStub: function (object) {
        const {call, args, stubId, isListener, autoRelease} = object
        if (isListener) {
            const listener = this._listenerMap[stubId]
            listener && listener(...args)

            return
        }

        const argsStub = this._argsStubMap[stubId];
        console.debug('nativeapi', 'appjs the __registerArgStub object JSON: ' + JSON.stringify(object))
        if (!argsStub) {
            console.debug('nativeapi', 'appjs the __registerArgStub argsStub hash been deleted: ')
            return;
        }
        if (!autoRelease) {
            if (call == 'complete') {
                delete this._argsStubMap[stubId]
            }
        } else {
            delete this._argsStubMap[stubId]
        }

        if (args[0] === null) {
            argsStub[call].call(argsStub)
            return
        }
        argsStub[call].call(argsStub, ...args)
    }
}
window.MethodChannel.init()

