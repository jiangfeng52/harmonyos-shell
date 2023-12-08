
type MethodStub = {target: any, fun: Function}

class NativeApiStub {
  // TODO-ly 当前的实现只适合单实例，如果出现多实例Web容器，当前的实现就会有问题
  private runJavascriptFun?: (jsCode: string)=>void
  setRunJavascriptFun(fun: (jsCode: string)=>void){
    this.runJavascriptFun = fun
  }
  removeRunJavascriptFun(){
    this.runJavascriptFun = null
  }

  private nativeMethods = new Map<string, MethodStub>()
  // TODO-ly 改为装饰器实现
  registerNativeApi(callName: string, methodStub: MethodStub) {
    if(this.nativeMethods.has(callName)){
      return
    }
    this.nativeMethods.set(callName, methodStub)
  }
  onTransact(callName: string, argsJson: string, callbackId: number) {
    const methodStub = this.nativeMethods.get(callName)
    if (!methodStub) {
      return
    }
    let argObject = {
      callbackId:callbackId,
      ...JSON.parse(argsJson)
    }
    argObject = new Proxy(argObject, {
      get(target, prop, receiver) {
        let value = target[prop]
        if (value){
          return value
        }
        return function (...args) {
          let argsJson = args.length >= 1 ? JSON.stringify(args[0]) : ''
          let jsCode = `window.jsCall(${target.callbackId}, ${prop.toString()}, ${argsJson})`
          NativeApiStubInstance.runJavascriptFun && NativeApiStubInstance.runJavascriptFun(jsCode)
        }
      }
    });
    methodStub.fun.call(methodStub.target, argObject)
  }
}

export const NativeApiStubInstance: NativeApiStub = new NativeApiStub()