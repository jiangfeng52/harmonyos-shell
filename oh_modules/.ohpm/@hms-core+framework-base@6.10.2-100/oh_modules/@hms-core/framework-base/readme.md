# framework-base

# Contents

1. Introduction
2. Installation Guide
3. Function Definitions & Sample
4. Licencing & Terms

## 1. Introduction

The SDK provides the ability to use HMS Core with JavaScript under multiple platforms (RN, OHOS, QuickApp, Cordova).


## 2. Installation Guide

- Go to your project
```bash
cd example/
```
- Install
```bash
npm i @hms-core/framework-base 
```
  
```text
project-name
    |_ node_modules
        |_ ...
        |_  @hms-core/framework-base
        |_ ...
```

- import @hms-core/framework-base package to your application
```JavaScript
import { hmsjsb, hmsbase } from '@hms-core/framework-base'
```

## 3. Function Definitions & Sample

* Function Definitions
    - [hmsjsb](#hmsjsb)
        - [hmsjsb.invoke({apiName, args, success, fail, complete})](#hmsjsbinvokeapiname-args-success-fail-complete)
        - [hmsjsb.on(eventName, callback, eventCallbackMap)](#hmsjsboneventname-callback-eventcallbackmap)
        - [hmsjsb.off(eventName, offKey, eventCallbackMap)](#hmsjsboffeventname-offkey-eventcallbackmap)
        - [hmsjsb.init(params)](#hmsjsbinitparams)
        - [hmsjsb.destroy()](#hmsjsbdestroy)
    - [hmsbase](#hmsbase)
        - [SharedPreferences](#SharedPreferences)<a name="SharedPreferences"></a>
          - [hmsbase.setSPvalue({key, value, spname})](#hmsbase.setSPvalue)
          - [hmsbase.getSPvalue({key, spname})](#hmsbase.getSPvalue)
          - [hmsbase.removeSPvalue({key, spname})](#hmsbase.removeSPvalue)
        - [base](#base)<a name="base"></a>
          - [hmsbase.getMetaData({key, packagename})](#hmsbase.getMetaData)
          - [hmsbase.getPackageName()](#hmsbase.getPackageName)
          - [hmsbase.getAppId()](#hmsbase.getAppId)
          - [hmsbase.getAaId()](#hmsbase.getAaId)
          - [hmsbase.getUid()](#hmsbase.getUid)
          - [hmsbase.getAppVersion()](#hmsbase.getAppVersion)
          - [hmsbase.getAgcConfig({key})](#hmsbase.getAgcConfig)
          - [hmsbase.config({subId})](#hmsbase.config)
        - [report](#report)<a name="report"></a>
          - [hmsbase.reportEntry({uri, kitSdkVersion})](#hmsbase.reportEntry)
          - [hmsbase.reportExit({uri, transactId, statusCode, errorCode, kitSdkVersionName})](#hmsbase.reportExit)
        - [update](#update)<a name="update"></a>
          - [hmsbase.isJsbKitAvailable({min_api_level})](#hmsbase.isJsbKitAvailable)
          - [hmsbase.upgrade()](#hmsbase.upgrade)
          - [hmsbase.reload()](#hmsbase.reload)
* Sample
    * [OHOS example](#OHOSexample)


 <a name="hmsjsb.invoke"></a>

### hmsjsb.invoke({apiName, args, success, fail, complete})
Call the HMS Core method. 

**The returns of callback & promise are supported. When the paramters contain success/fail/complete, it will return from callbacks, otherwise it will return a promise.**

| Parameters | Type | Required |Description |
| --- | --- | --- | --- |
| apiName | <code>string</code> | yes | JAVA API name |
| args | <code>Object</code> | no | params |
| success | [<code>successCallback</code>](#successCallback) | no |success callback |
| fail | [<code>failCallback</code>](#failCallback) | no |fail callback |
| complete | [<code>completeCallback</code>](#completeCallback) | no |complete callback |

### return value： [<code>result</code>](#callbackResult)  


### example

```javascript
// callback
hmsjsb.invoke({
  apiName: 'update.availability',
  args: {
    min_api_level: 2,
  },
  success: (result) => {
    console.info(JSON.stringify(result));
  },
  fail: (error) => {
    console.info(JSON.stringify(error));
  }
});

// promise 
hmsjsb.invoke({
  apiName: 'update.availability',
  args: {
    min_api_level: 2,
  }
}).then(res => console.info(JSON.stringify(res)))
.catch(err => console.info(JSON.stringify(err)));
```

<a name="hmsjsb.on"></a>

### hmsjsb.on(eventName, callback, eventCallbackMap)
listen for HMS Core events. After the interface is called, the listener will start automatically. You can use hmsjsb.off to stop listening.
  
| Parameters | Type | Required |Description |
| --- | --- | --- | --- |
| eventName | <code>string</code> | yes |event name |
| callback | <code>function</code> | yes |event callback |
| eventCallbackMap | <code>Object</code> | no |event callback map, only used in OHOS, other platforms can ignore it  |

### return value： [<code>result</code>](#callbackResult) 

<a name="hmsjsb.off"></a>

### hmsjsb.off(eventName, offKey, eventCallbackMap)
Stop listening for HMS Core events, call it when the page is destroyed. 

| Parameters | Type | Required |Description |
| --- | --- | --- |--- |
| eventName | <code>string</code> | yes| event name |
| offKey | <code>\*</code> | yes | type is function or string, Event callback or hmsjsb.on result |
| eventCallbackMap | <code>Object</code> | no | event callback map,only used in OHOS, other platforms can ignore it  |

### return value ：[<code>result</code>](#callbackResult)

<a name="hmsjsb.init"></a>

### hmsjsb.init(params)
Before calling the hmsjsb methods,call the method to initialize

**Note: Currently only the `React Native` and `OHOS` platforms need to call this method, other platforms can ignore it.**
  

| Parameters | Type | Required |Description |
| --- | --- | --- |--- |
| params | <code>Object</code> | no | RN and OHOS are must input, RN example:{ NativeModules, DeviceEventEmitter }, OHOS example:{}|

### return value： [<code>result</code>](#callbackResult)

<a name="hmsjsb.destroy"></a>

### hmsjsb.destroy()
Before the page is destroyed, call the method to destroy.

**Note: Currently only the `React Native` platform needs to call this method, other platforms can ignore it.**

### return value： [<code>result</code>](#callbackResult)

<a name="hmsbase.setSPvalue"></a>

### hmsbase.setSPvalue({key, value, spname})
SharedPreferences

| Param | Type | Description |
| --- | --- | --- |
| key | <code>string</code> | the key of SharedPreferences |
| value | <code>string</code> | the value of SharedPreferences |
| spname |<code>string</code> | the spname ofSharedPreferences |

<a name="hmsbase.getSPvalue"></a>

### hmsbase.getSPvalue({key, spname})
Read SharedPreferences value

| Param | Type | Description |
| --- | --- | --- |
| key | <code>string</code> | the key of SharedPreferences |
| spname |<code>string</code> | the spname ofSharedPreferences |

<a name="hmsbase.removeSPvalue"></a>

### hmsbase.removeSPvalue({key, spname})
Delete shareapeferences value

| Param | Type | Description |
| --- | --- | --- |
| key | <code>string</code> | the key of SharedPreferences |
| spname |<code>string</code> | the spname ofSharedPreferences |

<a name="hmsbase.getMetaData"></a>

### hmsbase.getMetaData({key, packagename})
Read metadata

| Param | Type | Description |
| --- | --- | --- |
| key | <code>string</code> |the key of metadata|
| packagename |<code>string</code> |packagename|

<a name="hmsbase.getPackageName"></a>

### hmsbase.getPackageName()
Get the package name of the third party application

<a name="hmsbase.getAppId"></a>

### hmsbase.getAppId()
Get the appid of the third party application

<a name="hmsbase.getAaId"></a>


### hmsbase.getAaId()
Get AAID

<a name="hmsbase.getUid"></a>

### hmsbase.getUid()
Get UID, Depends on hms-js-base 5.2.0-300 and bridge-sdk 5.2.0.300. Rename @hms-core/framework-base in hms-js-base of version 6.10.2

<a name="hmsbase.getAppVersion"></a>

### hmsbase.getAppVersion()
Get the application version number, Depends on hms-js-base 5.2.0-300 and bridge-sdk 5.2.0.300. Rename @hms-core/framework-base in hms-js-base of version 6.10.2

<a name="hmsbase.getAgcConfig"></a>

### hmsbase.getAgcConfig({key})
Get AGC configuration, Depends on hms-js-base 5.2.0-300 and bridge-sdk 5.2.0.300. Rename @hms-core/framework-base in hms-js-base of version 6.10.2

| Param | Type | Description |
| --- | --- | --- |
| key | <code>string</code> | the key of AGC configuration |

<a name="hmsbase.config"></a>

### hmsbase.config({subId})
Authentication

| Param | Type | Description |
| --- | --- | --- |
| subId | <code>string</code> | the appId of h5 app|

<a name="hmsbase.reportEntry"></a>

### hmsbase.reportEntry({uri, kitSdkVersion})
Event tracking start

| Param | Type | Description |
| --- | --- | --- |
| uri | <code>string</code> | uri |
| kitSdkVersion |<code>int</code> | kitsdk version|

<a name="hmsbase.reportExit"></a>

### hmsbase.reportExit({uri, transactId, statusCode, errorCode, kitSdkVersionName})
Event tracking end

| Param | Type | Description |
| --- | --- | --- |
| uri | <code>string</code> | uri |
| transactId |<code>string</code> | transact ID|
| statusCode | <code>int</code> | status code |
| errorCode |<code>int</code> | error code|
| kitSdkVersionName |<code>int</code> |kitsdk version|


<a name="hmsbase.isJsbKitAvailable"></a>

### hmsbase.isJsbKitAvailable({min_api_level})
Check jsb kit api_level >= min_api_level

| Param | Type | Description |
| --- | --- | --- |
| min_api_level | <code>int</code> | Expected api_level of JSB kit |

<a name="hmsbase.upgrade"></a>

### hmsbase.upgrade()
Upgrade jsb kit

<a name="hmsbase.reload"></a>

### hmsbase.reload()
After the upgrade is successful, reload the new jsb kit to initialize the jsb kit

<a name="successCallback"></a>

## successCallback : <code>function</code>
success callback.

**Kind**: global typedef  

| Parameters | Type | Description |
| --- | --- | --- |
| result | [<code>object</code>](#callbackResult) | result |

<a name="failCallback"></a>

## failCallback : <code>function</code>
fail callback.

**Kind**: global typedef  

| Parameters | Type | Description |
| --- | --- | --- |
| result | [<code>object</code>](#callbackResult) | result |
<a name="completeCallback"></a>

## completeCallback : <code>function</code>
complete callback.

**Kind**: global typedef  

| Parameters | Type | Description|
| --- | --- | --- |
| result | [<code>object</code>](#callbackResult) | result |

<a name="callbackResult"></a>

## result : <code>object</code>
 the returned value of mothed or callback

**Kind**:  return value 

|Returns	|Type |Description| 
| --- | --- | --- |
| errCode | <code>number</code> | error code |
| errMsg | <code>string</code> | error message |
| data | <code>\*</code> | Type is function or string |
| extras | <code>object</code> | extras |

### OHOSexample

<a name="OHOSexample"></a>


  **Define the global variable eventCallbackMap in app.js, and then init framework-base at the onCreate method.**

```JavaScript
import { hmsjsb } from '@hms-core/framework-base'
//Define the global
hmsData: {
  eventCallbackMap: {},
}

//init
onCreate() {
  hmsjsb.init(this.hmsData.eventCallbackMap);
}
```
**Subscribe and unsubscribe events, need to match use.**

**Notes: When the event linstener is no longer needed or the page is destroyed, please stop listening**

```JavaScript
import router from '@system.router'
import { hmsjsb } from '@hms-core/framework-base'

export default {
  data: {
    title: "",
    eventCallbackId: ""
  },
  onInit() {
    //Subscribe
    this.eventCallbackId = hmsjsb.on("onBackground", (result) => {
      console.info("event callback result: " + JSON.stringify(result));
    }, this.$app.$def.hmsData.eventCallbackMap);
  },
  onDestroy() {
    //unsubscribe
    hmsjsb.off("onBackground", this.eventCallbackId,
      this.$app.$def.hmsData.eventCallbackMap);
  }
}
```

## 4. Licensing and Terms  
@hms-core/framework-base SDK uses the Apache 2.0 license.