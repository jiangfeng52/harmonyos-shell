
// TODO-ly 此类都需要重写，因为此类是es5的js

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
                  return function (...args) {
                      // 方法调用转换为数据
                      var methodCall = {
                          call: prop,
                          argsJson: args.length >= 1 ? JSON.stringify(args[0]) : '',
                          stubId: args.length >= 1 ? window.MethodChannel.__registerArgsStub(args[0]) : -1
                      }
                      return window.Channel.nativeCall(window.MethodChannel.ChannelType, methodCall)
                  }
              }

              // 直接返回
              return target[prop];
          }
      });
    },

    _NextId: 0,// 初始ID值
    _argsStubMap: {},
    // listenerMap: {}, 弱引用自动取消
    __registerArgsStub: function (argsStub) {
        var objectId = this._NextId++
        this._argsStubMap[objectId] = argsStub
        return objectId
    },
    __ArgsMethodStub: function (object){
        const {objectId, callName, arg} = object

        const argsStub = this._argsStubMap[objectId];
        if(!argsStub) {
            return ;
        }
        // 只回调一次，可能会有问题，需测试
        delete this._argsStubMap[objectId]

        argsStub[callName].call(argsStub, arg)
    }
}
window.MethodChannel.init()


window.NativeApi = {

    /**
     * 类型1：同步调用
     *
     * @returns 返回值对象里无方法
     */
    getWindowInfo(){
        return ''
    },

    /**
     * 类型2：异步调用，res无方法
     * 打开系统蓝牙设置
     *
     * @param {Object} options - 选项对象
     * @param {Function} options.success - 成功回调函数
     * @param {Function} options.fail - 失败回调函数
     * @param {Function} options.complete - 完成回调函数
     */
    openSystemBluetoothSetting(options) {}
}
window.NativeApi = window.MethodChannel.createNativeApiProxy(window.NativeApi)

// TODO-ly 测试
setTimeout(()=>{
    var result = window.NativeApi.getWindowInfo();
    console.log('window.NativeApi.getWindowInfo() result is ', result ? JSON.stringify(result) : '')


    // @ts-ignore
    window.NativeApi.openSystemBluetoothSetting({
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
}, 1000)