"use strict";

function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread(); }
function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }
function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }
function _iterableToArray(iter) { if (typeof Symbol !== "undefined" && iter[Symbol.iterator] != null || iter["@@iterator"] != null) return Array.from(iter); }
function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) return _arrayLikeToArray(arr); }
function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) arr2[i] = arr[i]; return arr2; }
function _typeof(o) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (o) { return typeof o; } : function (o) { return o && "function" == typeof Symbol && o.constructor === Symbol && o !== Symbol.prototype ? "symbol" : typeof o; }, _typeof(o); }
/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

function isFunction(object) {
  if (typeof object === 'function') {
    // 如果是函数，直接返回 true
    return true;
  }
  return false;
}
function getAllFuns(object) {
  if (_typeof(object) !== 'object' || object === null) {
    return [];
  }
  var funs = [];
  // 如果是对象，遍历对象的每个属性，检查属性是否是函数
  for (var key in object) {
    if (object.hasOwnProperty(key) && typeof object[key] === 'function') {
      funs.push(key);
    }
  }
  return funs;
}
function isFunctionOrObjectWithFunction(object) {
  if (isFunction(object)) {
    return true;
  }
  if (_typeof(object) !== 'object' || object === null) {
    return false;
  }

  // 如果是对象，遍历对象的每个属性，检查属性是否是函数
  for (var key in object) {
    if (object.hasOwnProperty(key) && typeof object[key] === 'function') {
      return true;
    }
  }
  return false;
}

// 通信Channel层
// @ts-ignore
window.Channel = {
  jsCallListeners: new Map(),
  // listenerMap: {}, 弱引用自动取消
  registerJsCall: function registerJsCall(channelType, fun) {
    this.jsCallListeners.set(channelType, fun);
  },
  /**
   * methodCall的对象结构为：{call: string, argsJson: string, stubId: number}
   */
  nativeCall: function nativeCall(channelType, object) {
    // 最终调用原生Channel的通信方法
    var objectJson = JSON.stringify(object);
    // @ts-ignore
    var resultJson = window.JSBridge && window.JSBridge.nativeMethod(channelType, objectJson);
    return resultJson && JSON.parse(resultJson);
  },
  /**
   * 给原生暴露的通信方法，原生调用"window.Channel.jsCall(objectId, 'xxx', 'xxxx')"
   */
  jsCall: function jsCall(channelType, object) {
    var fun = this.jsCallListeners.get(channelType);
    fun && fun(object);
  }
};
// @ts-ignore
window.MethodChannel = {
  ChannelType: 'MethodChannel',
  init: function init() {
    // @ts-ignore
    window.Channel.registerJsCall(this.ChannelType, function (object) {
      // @ts-ignore
      window.MethodChannel.__ArgsMethodStub(object);
    });
  },
  getPromiseStatus: function getPromiseStatus() {
    // 方法调用转换为数据
    var methodCall = {
      //修改了名称
      isAsync: false,
      // 调用函数名
      call: "GetPromiseStatus",
      arg: {
        isFun: false,
        properties: '',
        funs: '',
        stubId: -1,
        objectId: -1
      }
    };
    // @ts-ignore
    return window.Channel.nativeCall(window.MethodChannel.ChannelType, methodCall);
  },
  unRegisterArgStub: function unRegisterArgStub(argObject) {
    var stubId = this._listenerMap.get(argObject);
    delete this._stubMap[stubId];
    this._listenerMap["delete"](argObject);
  },
  jsBridgeMode: function jsBridgeMode(mode) {
    return function (target, key, descriptor) {
      var className = target.constructor.name;
      descriptor.value = function () {
        var _mode$autoRelease, _mode$isAsync;
        var firstArg = arguments.length >= 1 ? arguments.length <= 0 ? undefined : arguments[0] : '';
        var argTypeIsFun = isFunction(firstArg);
        // @ts-ignore
        var stubId = window.MethodChannel.__registerArgStub(firstArg, argTypeIsFun, (_mode$autoRelease = mode === null || mode === void 0 ? void 0 : mode.autoRelease) !== null && _mode$autoRelease !== void 0 ? _mode$autoRelease : true);
        var isAsync = (_mode$isAsync = mode === null || mode === void 0 ? void 0 : mode.isAsync) !== null && _mode$isAsync !== void 0 ? _mode$isAsync : true;

        // 方法调用转换为数据
        var methodCall = {
          //修改了名称
          isAsync: isAsync,
          // 调用函数名
          call: "".concat(className ? className : '', "$").concat(key.toString()),
          arg: {
            isFun: argTypeIsFun,
            properties: firstArg,
            funs: getAllFuns(firstArg),
            stubId: stubId
          }
        };
        // @ts-ignore
        var result = window.Channel.nativeCall(window.MethodChannel.ChannelType, methodCall);
        if (!isAsync && result === 'Promise_Result') {
          var count = 0;
          while (count < 20000) {
            count++;
            if (count % 2000 === 0) {
              // @ts-ignore
              var promiseStatus = window.MethodChannel.getPromiseStatus();
              if (promiseStatus.status === 'pending') {
                continue;
              }
              return promiseStatus.result;
            }
          }
          return undefined;
        }
        return result;
      };
    };
  },
  _NextId: 0,
  // 初始ID值
  _stubMap: {},
  _listenerMap: new Map(),
  __registerArgStub: function __registerArgStub(argObject, isFun, autoRelease) {
    var hasFun = isFunctionOrObjectWithFunction(argObject);
    if (!hasFun) {
      return -1;
    }
    // 尝试从map中取出变量id，如果有，直接返回对应id
    var objectId = this._listenerMap.get(argObject);
    if (objectId) {
      return objectId;
    }
    objectId = this._NextId++;
    this._stubMap[objectId] = {
      object: argObject,
      isFun: isFun,
      autoRelease: autoRelease
    };
    // 将变量存储到map中，防止相同变量多次注册
    this._listenerMap.set(argObject, objectId);
    return objectId;
  },
  __ArgsMethodStub: function __ArgsMethodStub(nativeArg) {
    var call = nativeArg.call,
      args = nativeArg.args,
      stubId = nativeArg.stubId;
    var stub = this._stubMap[stubId];
    if (!stub) {
      console.debug('nativeapi', 'appjs argsStub hash been deleted ');
      return;
    }
    var object = stub.object,
      isFun = stub.isFun,
      autoRelease = stub.autoRelease;
    if (autoRelease) {
      delete this._stubMap[stubId];
      delete this._listenerMap[object];
      this._listenerMap["delete"](object);
    } else if (call == 'complete') {
      delete this._stubMap[stubId];
      delete this._listenerMap[object];
      this._listenerMap["delete"](object);
    }
    if (isFun) {
      object && object.apply(void 0, _toConsumableArray(args));
      return;
    }
    if (args) {
      var _object$call;
      (_object$call = object[call]).call.apply(_object$call, [object].concat(_toConsumableArray(args)));
    } else {
      object[call].call(object);
    }
  }
};
// @ts-ignore
window.MethodChannel.init();