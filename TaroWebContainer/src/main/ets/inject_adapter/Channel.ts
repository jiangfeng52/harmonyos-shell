class Channel {
  // TODO-ly 当前的实现只适合单实例，如果出现多实例Web容器，当前的实现就会有问题
  private runJavascriptFun?: (jsCode: string)=>void
  setRunJavascriptFun(fun: (jsCode: string)=>void){
    this.runJavascriptFun = fun
  }
  removeRunJavascriptFun(){
    this.runJavascriptFun = null
  }

  private channelListeners: Map<string, (object: any)=>void>
  constructor() {
    this.channelListeners = new Map<string, (object: any)=>void>();
  }
  registerChannel(channelType: string, fun: (object: any)=>void){
    this.channelListeners.set(channelType, fun)
  }

  call(channelType: string, objectJson: string){
    const fun = this.channelListeners.get(channelType)
    fun && fun(JSON.parse(objectJson))
  }

  jsCall(channelType: string, object: object){
    let jsCode = `window.Channel.jsCall('${channelType}', '${JSON.stringify(object)}')`
    this.runJavascriptFun && this.runJavascriptFun(jsCode)
  }
}
export const ChannelInstance: Channel = new Channel();

class MethodChannel {
  private ChannelType = 'MethodChannel'

  private methodPools = new Map<string, (object: any)=>void>()
  // TODO-ly 改为装饰器实现
  registerMethod(methodName: string, fun: (object: any)=>void) {
    if(this.methodPools.has(methodName)){
      return
    }
    this.methodPools.set(methodName, fun)
  }

  constructor() {
    ChannelInstance.registerChannel(this.ChannelType, (object: Object)=>{
      this.call(object)
    })
  }

  call(object){
    const {call, argsJson, stubId} = object
    const fun = this.methodPools.get(call)
    if(!fun) {
      return ;
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
            argsJson: args.length >= 1 ? JSON.stringify(args[0]) : ''
          }
          ChannelInstance.jsCall(MethodChannelInstance.ChannelType, object)
        }
      }
    });
    fun.call(null, argObject)
  }
}

export const MethodChannelInstance: MethodChannel = new MethodChannel();