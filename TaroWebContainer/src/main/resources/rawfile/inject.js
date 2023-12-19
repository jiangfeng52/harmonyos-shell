window.addEventListener('unhandledrejection', (event) => {
    console.info('[ADSAPI] unhandledrejection: ', event);
})
if (typeof (adapterInited) === 'undefined') {
    var asCallbackMap = new Map();
    var asAPIMap = new Map();
    var asCallbackId = 0;
    var receiveTask = (callbackId, resObject) => {
        if (asCallbackMap.get(callbackId)) {
            asCallbackMap.get(callbackId).apply(null, resObject);
        }
        return true
    }
    var temp_uni = {}
    native = new Proxy({}, {
        get(target, property) {
            if (asAPIMap.has(property)) {
                return asAPIMap.get(property)
            }
            return temp_uni[property]
        }
    })

    var getCallbackParam = (args) => {
        const callbackObj = []
        args.forEach((arg, index) => {
            if (typeof (arg) === 'object') {
                callbackObj[index] = {}
                for (let name in arg) {
                    if (typeof (arg[name]) === 'function') {
                        asCallbackMap.set(asCallbackId, arg[name]);
                        callbackObj[index][name] = asCallbackId++;
                    }
                }
            } else if (typeof (arg) === 'function') {
                let tempId = null;
                for (let prop of asCallbackMap) {
                    if (prop[1] === arg) {
                        tempId = prop[0];
                        break;
                    }
                }
                if (tempId !== null) {
                    callbackObj[index] = tempId + '_' + (arg.name ? arg.name : 'func');
                } else {
                    asCallbackMap.set(asCallbackId, arg);
                    callbackObj[index] = asCallbackId + '_' + (arg.name ? arg.name : 'func');
                    asCallbackId++;
                }

            }
        })
        const argsStr = JSON.stringify(args);
        const callbackString = JSON.stringify(callbackObj);
        return [callbackString, argsStr]
    }

    var setAsAPIFunction = (method) => {
        return (...args) => {
            const callbackParam = getCallbackParam(args)
            const result = as[method](callbackParam[0], callbackParam[1])
            if (result) {
                const resultObj = JSON.parse(result)
                const resultObjT = JSON.parse(result)
                const asObjectId = resultObj.asObjectId
                const proxy = new Proxy(resultObjT, {
                    get: (target, property) => {
                        const type = resultObj[property]
                        if (type === 'function') {
                            return (...args1) => {
                                const callbackParam = getCallbackParam(args1)
                                return as.sendToAs(asObjectId, 'get_function', property, callbackParam[0], callbackParam[1])
                            }
                        } else {
                            return as.sendToAs(asObjectId, 'get_value', property)
                        }
                    },
                    set: (target, property, value) => {
                        as.sendToAs(asObjectId, 'set', property, value)
                        return true
                    }
                })
                return proxy
            } else if (typeof (result) === 'boolean') {
                return result
            }
        }
    }
    var adapterInited = true;
}