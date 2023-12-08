
// TODO-ly 此类都需要重写，因为此类是es5的js

// js
window.apiStubPool = {
    NextId: 0,// 初始ID值
    callbackObjectMap: {},
    // listenerMap: {}, 弱引用自动取消
    registerCallback(callbackObject) {
        var objectId = this.NextId++
        this.callbackObjectMap[objectId] = callbackObject
        return objectId
    },
    // registerListener(listeners) {
    //     var objectId = this.NextId++
    //     this.listenerMap.set(objectId, listeners)
    //     return objectId
    // },
    // 转换方法调用
    onTransact(objectId, callName, argsJson){
        const obj = this.callbackObjectMap[objectId];
        if(!obj) {
            return ;
        }
        // 只回调一次，可能会有问题，需测试
        delete this.callbackObjectMap[objectId]

        const args = JSON.parse(argsJson)
        obj[callName].call(obj, args)
    }
}

// MethodChannel: 给原生声明的方法
window.jsCall = function (objectId, callName, argsJson){
    console.log(`jsCall objectId=${objectId}, callName=${callName}, argsJson=${argsJson}`);
    window.apiStubPool.onTransact(objectId, callName, argsJson)
}


/**
 * 定义的Api的要求：方法参数，要么为空，要么是object对象
 *
 * object对象的要求：除了属性外，回调函数必须是success、fail、complete三个函数Function
 */
const NativeApi = {
    /**
     * 打开系统蓝牙设置
     *
     * @param {Object} options - 选项对象
     * @param {Function} options.success - 成功回调函数
     * @param {Function} options.fail - 失败回调函数
     * @param {Function} options.complete - 完成回调函数
     */
    openSystemBluetoothSetting(options) {}
}
window.NativeApi = new Proxy(NativeApi, {
    get(target, prop, receiver) {
        if(typeof target[prop] === 'function') {
            return function (...args) {
                // 方法调用转换为数据
                var methodCall = {
                    call: prop,
                    argsJson: args.length >= 1 ? JSON.stringify(args[0]) : '',
                    stubId: args.length >= 1 ? window.apiStubPool.registerCallback(args[0]) : -1
                }
                // @ts-ignore
                if (window.as && window.as.nativeCall) {
                    // @ts-ignore
                    window.as.nativeCall(methodCall.call, methodCall.argsJson, methodCall.stubId)
                }
            }
        }

        // 直接返回
        return target[prop];
    }
})

// TODO-ly 测试
setTimeout(()=>{
    window.NativeApi.openSystemBluetoothSetting({
        success: function (){
            console.log('openSystemBluetoothSetting success')
        },
        fail: function (){
            console.log('openSystemBluetoothSetting fail')
        },
        complete: function (){
            console.log('openSystemBluetoothSetting complete')
        }
    })
}, 1000)