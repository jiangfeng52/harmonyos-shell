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
    return fun(JSON.parse(objectJson))
  }

  jsCall(channelType: string, object: object){
    let jsCode = `window.Channel.jsCall('${channelType}', '${JSON.stringify(object)}')`
    this.runJavascriptFun && this.runJavascriptFun(jsCode)
  }
}
export const ChannelInstance: Channel = new Channel();

class MethodChannel {
  private ChannelType = 'MethodChannel'

  private methodPools = new Map<string, (object: any)=>any>()
  // TODO-ly 改为装饰器实现
  registerMethod(methodName: string, fun: (object: any)=>any) {
    if(this.methodPools.has(methodName)){
      return
    }
    this.methodPools.set(methodName, fun)
  }

  constructor() {
    ChannelInstance.registerChannel(this.ChannelType, (object: any)=>{
      return this.call(object)
    })
  }

  call(object): any{
    const {call, argsJson, stubId} = object
    const fun = this.methodPools.get(call)
    if(!fun) {
      return undefined;
    }

    if(argsJson == '') { // 无参数
      return fun.call(null)
    }

    let argObject = {
      callbackId:stubId,
      ...JSON.parse(argsJson)
    }
    argObject = new Proxy(argObject, {
      get(target, prop, receiver) {
        let value = target[prop]
        if (value){
          return value
        }
        return function (...args) {
          const object = {
            objectId: target.callbackId,
            callName: prop.toString(),
            arg: args.length >= 1 ? args[0] : ''
          }
          ChannelInstance.jsCall(MethodChannelInstance.ChannelType, object)
        }
      }
    });
    return fun.call(null, argObject)
  }
}

export const MethodChannelInstance: MethodChannel = new MethodChannel();