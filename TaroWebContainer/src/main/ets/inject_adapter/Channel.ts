import { wbLogger } from '../utils/Logger'

class Channel {
  // TODO-ly 当前的实现只适合单实例，如果出现多实例Web容器，当前的实现就会有问题
  private runJavascriptFun?: (jsCode: string)=>void
  setRunJavascriptFun(fun: (jsCode: string)=>void){
    this.runJavascriptFun = fun
  }
  removeRunJavascriptFun(){
    this.runJavascriptFun = null
  }

  private channelListeners: Map<string, (object: any)=>any>
  constructor() {
    this.channelListeners = new Map<string, (object: any)=>any>();
  }
  registerChannel(channelType: string, fun: (object: any)=>any){
    this.channelListeners.set(channelType, fun)
  }

  call(channelType: string, objectJson: string): any{
    const fun = this.channelListeners.get(channelType)
    if(!fun) {
      return undefined;
    }
    const result = fun(JSON.parse(objectJson))
    return JSON.stringify(result);
  }

  jsCall(channelType: string, object: object){
    let jsCode = `window.Channel.jsCall('${channelType}', '${JSON.stringify(object)}')`
    this.runJavascriptFun && this.runJavascriptFun(jsCode)
  }
}
export const ChannelInstance: Channel = new Channel();

class MethodChannel {
  private ChannelType = 'MethodChannel'

  private methodPools = new Map<string, (arg: any)=>any>()
  // TODO-ly 改为装饰器实现
  registerMethod(methodName: string, fun: (arg: any)=>any) {
    if(this.methodPools.has(methodName)){
      return
    }
    this.methodPools.set(methodName, fun)
  }
  registerMethods(object: object){
    for (const methodName of Object.keys(object)) {
      const method = object[methodName]
      if (typeof method === 'function') {
        // 注册
        this.registerMethod(methodName, (arg: any)=>{
          method.apply(object, arg)
        })
      }
    }
  }

  constructor() {
    ChannelInstance.registerChannel(this.ChannelType, (object: any)=>{
      return this.call(object)
    })
  }

  call(object): any{
    const {call, isListener, arg, stubId} = object
    const fun = this.methodPools.get(call)
    if(!fun) {
      return undefined;
    }

    if (stubId == -1) { // 没有回调函数
      return fun.call(null, arg)
    }

    if(isListener) { // arg为函数
      const argProxy = new Proxy(function (){}, {
        apply(target, thisArg: any, argArray: any[]){
          const object = {
            call: '',
            args: argArray,
            stubId: stubId,
            isListener: true
          }
          ChannelInstance.jsCall(MethodChannelInstance.ChannelType, object)
        }
      });
      return fun.call(null, argProxy)
    }

    // arg为对象
    const argProxy = new Proxy(arg??{}, {
      get(target, prop, receiver) {
        let value = target[prop]
        if (value){
          return value
        }
        return function (...args) {
          const object = {
            call: prop.toString(),
            args: args,
            stubId: stubId,
            isListener: false
          }
          ChannelInstance.jsCall(MethodChannelInstance.ChannelType, object)
        }
      }
    });
    return fun.call(null, argProxy)
  }
}

export const MethodChannelInstance: MethodChannel = new MethodChannel();