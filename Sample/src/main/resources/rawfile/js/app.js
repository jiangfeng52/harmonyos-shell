
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

function isOnMehtod(methodName){
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
    nativeCall: function(channelType, object){
        // 最终调用原生Channel的通信方法
        var objectJson = JSON.stringify(object)
        // @ts-ignore
        var resultJson = window.JSBridge && window.JSBridge.nativeMethod(channelType, objectJson)
        return resultJson && JSON.parse(resultJson)
    },

    /**
     * 给原生暴露的通信方法，原生调用"window.Channel.jsCall(objectId, 'xxx', 'xxxx')"
     */
    jsCall: function(channelType, objectJson){
        console.log(`jsCall channelType=${channelType}, objectJson=${objectJson}`);
        // window.apiStubPool.onTransact(objectId, callName, argsJson)
        var fun = this.jsCallListeners[channelType]
        fun && fun(JSON.parse(objectJson))
    }
}

window.MethodChannel = {
    ChannelType: 'MethodChannel',

    init: function (){
        window.Channel.registerJsCall(this.ChannelType, function (object){
            window.MethodChannel.__ArgsMethodStub(object)
        })
    },

    createNativeApiProxy: function (nativeApi){
      return new Proxy(nativeApi, {
          get(target, prop, receiver) {
              if(typeof target[prop] === 'function') {
                  const shouldProxy = Reflect.get(target, `__proxy_${prop.toString()}`);
                  if (shouldProxy) {
                      const className = Reflect.get(target, `__proxy_className`);
                      return function (...args) {
                          const firstArg = args.length >= 1 ? args[0] : ''
                          // 约定异步回调的方式，一次性回调，监听回调
                          let isListener = isOnMehtod(prop.toString())
                          let hasFun = isFunctionOrObjectWithFunction(firstArg)

                          // 方法调用转换为数据
                          var methodCall = {
                              call: `${className?className:''}\$${prop.toString()}`,
                              isListener: isListener,
                              arg: firstArg,
                              stubId: hasFun ? window.MethodChannel.__registerArgStub(firstArg, isListener) : -1
                          }
                          return window.Channel.nativeCall(window.MethodChannel.ChannelType, methodCall)
                      }
                  }
              }

              // 直接返回
              return target[prop];
          }
      });
    },

    _NextId: 0,// 初始ID值
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
    __ArgsMethodStub: function (object){
        const {call, args, stubId, isListener} = object

        if(isListener) {
            const listener = this._listenerMap[stubId]
            listener && listener(...args)

            return
        }
        
        const argsStub = this._argsStubMap[stubId];
        if(!argsStub) {
            return ;
        }
        // 只回调一次，可能会有问题，需测试
        delete this._argsStubMap[stubId]

        argsStub[call].call(argsStub, ...args)
    }
}
window.MethodChannel.init()

function proxyClassSign(className) {
    return function (target) {
        Reflect.defineProperty(target, `__proxy_className`, {
            value: className,
            configurable: true,
            enumerable: false
        })
    }
}
function proxyMethodSign (target, propertyKey, descriptor){
    Reflect.defineProperty(target, `__proxy_${propertyKey}}`, {
        value: true,
        configurable: true,
        enumerable: false
    })
}

// @proxyClassSign('UpdateManager')
class UpdateManager {
    // TODO 采用typescript的装饰器来写，es6不支持装饰器，临时验证方案
    __proxy_className = 'UpdateManager'
    __proxy_applyUpdate = true
    __proxy_onCheckForUpdate = true

    // @proxyMethodSign
    applyUpdate() {}

    // @proxyMethodSign
    onCheckForUpdate(){}
}

// @proxyClassSign('')
class NativeApi {
    // TODO 采用typescript的装饰器来写，es6不支持装饰器，临时验证方案
    __proxy_className = ''
    __proxy_getWindowInfo = true
    __proxy_openSystemBluetoothSetting = true
    __proxy_onWindowResize = true

    updateManage = window.MethodChannel.createNativeApiProxy(new UpdateManager())

    /**
     * 类型1：同步调用
     *
     * @returns 返回值对象里无方法
     */
    // @proxyMethodSign
    getWindowInfo(){
        return ''
    }

    /**
     * 类型2：异步调用，res无方法
     * 打开系统蓝牙设置
     *
     * @param {Object} options - 选项对象
     * @param {Function} options.success - 成功回调函数
     * @param {Function} options.fail - 失败回调函数
     * @param {Function} options.complete - 完成回调函数
     */
    // @proxyMethodSign
    openSystemBluetoothSetting(options) {}

    /**
     * 类型3：持续监听，res无方法
     *
     * @param listener
     */
    // @ts-ignore
    // @proxyMethodSign
    onWindowResize(listener) {}

    getUpdateManager(){
        return this.updateManage
    }

}
window.NativeApiInstance = window.MethodChannel.createNativeApiProxy(new NativeApi())

// TODO-ly 测试代码
setTimeout(()=>{
    var result = window.NativeApiInstance.getWindowInfo();
    console.log('window.NativeApi.getWindowInfo() result is ', result ? JSON.stringify(result) : '')

    window.NativeApiInstance.openSystemBluetoothSetting({
        success: function (res){
            console.log('window.NativeApi.openSystemBluetoothSetting() success, res is ', res ? JSON.stringify(res) : '')
        },
        fail: function (res){
            console.log('window.NativeApi.openSystemBluetoothSetting() fail, res is ', res ? JSON.stringify(res) : '')
        },
        complete: function (res){
            console.log('window.NativeApi.openSystemBluetoothSetting() complete, res is ', res ? JSON.stringify(res) : '')
        }
    })

    window.NativeApiInstance.onWindowResize((res)=>{
        console.log('window.NativeApi.onWindowResize() listen result is ', JSON.stringify(res));
    });

    const updateManager = window.NativeApiInstance.getUpdateManager();
    updateManager.applyUpdate()
    updateManager.onCheckForUpdate((res)=>{
        console.log('updateManager.onCheckForUpdate listener result is ', JSON.stringify(res));
    })
}, 1000)