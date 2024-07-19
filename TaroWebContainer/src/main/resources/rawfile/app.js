"use strict";

function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread(); }
function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }
function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(o); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }
function _iterableToArray(iter) { if (typeof Symbol !== "undefined" && iter[Symbol.iterator] != null || iter["@@iterator"] != null) return Array.from(iter); }
function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) return _arrayLikeToArray(arr); }
function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) arr2[i] = arr[i]; return arr2; }
function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }
function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, _toPropertyKey(descriptor.key), descriptor); } }
function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); Object.defineProperty(Constructor, "prototype", { writable: false }); return Constructor; }
function _defineProperty(obj, key, value) { key = _toPropertyKey(key); if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }
function _toPropertyKey(t) { var i = _toPrimitive(t, "string"); return "symbol" == _typeof(i) ? i : i + ""; }
function _toPrimitive(t, r) { if ("object" != _typeof(t) || !t) return t; var e = t[Symbol.toPrimitive]; if (void 0 !== e) { var i = e.call(t, r || "default"); if ("object" != _typeof(i)) return i; throw new TypeError("@@toPrimitive must return a primitive value."); } return ("string" === r ? String : Number)(t); }
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

/**
 * JSBridge通道处理器
 */

// 通信Channel层
// @ts-ignore
window.Channel = {
  channelHandlerMap: new Map(),
  /**
   * 注册Channel处理类
   * @param channelHandler
   */
  registerChannelHandler: function registerChannelHandler(channelHandler) {
    this.channelHandlerMap.set(channelHandler.getChannelType(), channelHandler);
  },
  /**
   * 对前端暴露的装饰器方法
   */
  jsBridge: function jsBridge(options) {
    return this.channelHandlerMap.get(options.channelType).registerJSBridge(options, function (channelType, object) {
      // 最终调用原生Channel的通信方法
      var objectJson = JSON.stringify(object);
      // @ts-ignore
      var resultJson = window.JSBridge && window.JSBridge.nativeMethod(channelType, objectJson);
      return resultJson && JSON.parse(resultJson);
    });
  },
  /**
   * 给原生暴露的通信方法，原生调用"window.Channel.nativeCallJS(channelType, object)"
   */
  nativeCallJS: function nativeCallJS(channelType, object) {
    var handler = this.channelHandlerMap.get(channelType);
    handler && handler.onNativeCallJS(object);
  }
};
var MethodChannelHandler = /*#__PURE__*/function () {
  function MethodChannelHandler() {
    _classCallCheck(this, MethodChannelHandler);
    _defineProperty(this, "channelType", 'MethodChannel');
    _defineProperty(this, "_NextTranscationId", 1);
    // 初始TranscationID值
    _defineProperty(this, "_transcationMap", new Map());
    _defineProperty(this, "_NextId", 1);
  }
  return _createClass(MethodChannelHandler, [{
    key: "getChannelType",
    value: function getChannelType() {
      return this.channelType;
    }
  }, {
    key: "registerJSBridge",
    value: function registerJSBridge(options, callNative) {
      var _this = this;
      return function (target, key, descriptor) {
        var className = target.constructor.name;
        descriptor.value = function () {
          var firstArg = arguments.length >= 1 ? arguments.length <= 0 ? undefined : arguments[0] : '';
          var argTypeIsFun = isFunction(firstArg);
          var callId = _this.generateCallId(firstArg);
          var transcationId = _this.registerTranscation(callId, firstArg, argTypeIsFun ? 'functino' : 'object', options.callType, 'Global');

          // 方法调用转换为数据
          var methodCall = {
            transcationId: transcationId,
            //修改了名称
            callType: options.callType,
            from: 'Global',
            // 调用函数名
            callName: "".concat(className ? className : '', "$").concat(key.toString()),
            optionsMsg: {
              type: argTypeIsFun ? 'function' : 'object',
              properties: firstArg,
              funs: getAllFuns(firstArg),
              callId: callId
            }
          };
          var result = callNative(_this.channelType, methodCall);
          if (options.callType == 'sync' && result === 'Promise_Result') {
            var count = 0;
            while (count < 20000) {
              count++;
              if (count % 2000 === 0) {
                var promiseStatus = _this.getPromiseStatus(callNative);
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
    }
  }, {
    key: "onNativeCallJS",
    value: function onNativeCallJS(nativeArg) {
      var call = nativeArg.call,
        args = nativeArg.args,
        transcationId = nativeArg.transcationId,
        callId = nativeArg.callId;
      var transcation = this._transcationMap.get(transcationId);
      if (!transcation) {
        console.debug('nativeapi', 'appjs transcation hash been deleted ');
        return;
      }
      var obj = transcation.get(callId);
      if (!obj) {
        console.debug('nativeapi', 'appjs obj hash been deleted ');
        return;
      }
      var options = obj.options,
        isFun = obj.isFun;
      if (call == 'success' || call == 'fail') {
        this._transcationMap["delete"](transcationId);
      }
      if (isFun) {
        options && options.apply(void 0, _toConsumableArray(args));
        return;
      }
      if (args) {
        var _options$call;
        (_options$call = options[call]).call.apply(_options$call, [options].concat(_toConsumableArray(args)));
      } else {
        options[call].call(options);
      }
    }
  }, {
    key: "getPromiseStatus",
    value: function getPromiseStatus(callNative) {
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
          callId: -1
        }
      };
      return callNative(this.channelType, methodCall);
    }
  }, {
    key: "generateCallId",
    value:
    // 初始ID值

    // _stubMap = {}

    function generateCallId(argObject) {
      var hasFun = isFunctionOrObjectWithFunction(argObject);
      if (!hasFun) {
        return -1;
      }
      var callId = this._NextId++;
      return callId;
    }
  }, {
    key: "registerTranscation",
    value: function registerTranscation(callId, argObject, argType, callType, fromType) {
      if (callId === -1) {
        return -1;
      }
      var transcationId = this._NextTranscationId++;
      var obj = {
        type: argType,
        options: argObject,
        callType: callType,
        fromType: fromType
      };
      var callMap = new Map();
      callMap.set(callId, obj);
      this._transcationMap.set(transcationId, callMap);
      return transcationId;
    }
  }]);
}(); // @ts-ignore
window.MethodChannel = {
  jsBridgeMode: function jsBridgeMode(mode) {
    mode['channelType'] = 'MethodChannel';
    // @ts-ignore
    return window.Channel.jsBridge(mode);
  },
  //TODO 同层绘制时会调用此方法，后续处理
  unRegisterArgStub: function unRegisterArgStub(argObject) {}
};
// @ts-ignore
window.Channel.registerChannelHandler(new MethodChannelHandler());