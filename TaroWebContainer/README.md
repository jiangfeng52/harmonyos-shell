# web-container
### 简介
**web-container 是一个定制化Web容器以及提供热更新等功能的模块。支持运行Taro生成的harmony-hybrid应用**

提供的能力：
- 提供`TaroWebContainer`组件，支持运行harmony-hybrid应用（Taro框架）
- 支持热更新

### 下载安装

```
ohpm install @hybrid/web-container
```

### 约束与限制
在下述版本验证通过：

- `DevEco Studio NEXT Developer Preview1`, SDK: API11 （可以通过 [HarmonyOS NEXT 开发者
  预览版 Beta 招募][NEXT招募] 申请获得）
- Taro 版本 3.6.24

上述版本也是最低版本要求

## TaroWebContainer组件使用指南
1. 使用DevEco Studio开发工具新建应用工程，选择`Empty Ability`模板，使用默认配置。
2. 在`entry/oh-package.json5`文件中添加`@hybrid/web-container`模块的依赖并点击`Sync`进行同步：

```json
{
  "license": "ISC",
  "devDependencies": {},
  "name": "entry",
  "description": "演示如何使用TaroWebContainer组件",
  "version": "1.0.0",
  "dependencies": {
    "@hybrid/web-container": "1.0.0"
  }
}

```
3. 在`entry/src/main/ets/entryability/EntryAbility.ets`中增加Want信息的处理：
```js
import Want from '@ohos.app.ability.Want';
import { wbLogger } from '@hybrid/web-container';

const ABILITY_TAG = 'EntryAbility';
const storage = new LocalStorage();

export default class EntryAbility extends UIAbility {
  onCreate(want: Want) {
    wbLogger.info(ABILITY_TAG, '%{public}s', 'Ability onCreate');
    storage.setOrCreate('want', want);
  }
  onNewWant(want: Want) {
    storage.setOrCreate('want',  want);
  }
  //...
}
```

4. 在`entry/src/main/ets/pages/Index.ets`主页面文件中使用`TaroWebContainer`组件：

<details>
<summary>示例源码</summary>

```js
// entry/src/main/ets/pages/Index.ets
import Want from '@ohos.app.ability.Want';
import Url from '@ohos.url';
import { TaroWebContainer, InjectObject, HostPageState, TaroWebController, Logger, LoggerLevel, wbLogger } from '@hybrid/web-container';

const SAMPLE_INDEX_TAG = 'SampleIndex';
let storage = LocalStorage.getShared() // 获取共享的本地存储对象

@Entry(storage)
@Component
struct TaroMpharmonySample {
  @LocalStorageProp('want') want: Want = {};
  @State pageState: HostPageState = HostPageState.PageInit;
  @State taroWebController: TaroWebController = new TaroWebController();

  // 用户可以自定义对象注入到Web环境中，使用native.sayHello格式进行调用
  nativeObj: InjectObject = {
    sayHello: () => console.log('Hello World'),
  }

  onBackPress() {
    if (this.taroWebController.accessBackward()) {
      this.taroWebController.backward();
      return true;
    }
    return false;
  }

  aboutToAppear() {
    Logger.setLogLevel(LoggerLevel.LOG_DEBUG);
  }

  onPageShow() {
    this.pageState = HostPageState.PageOnShow;
  }

  onPageHide() {
    this.pageState = HostPageState.PageOnHide;
  }

  webUrl(): string {
    // 开发阶段可以把网站静态资源文件放置到src/main/resources/rawfile/目录下
    // 生产环境下把网站静态资源放置到web服务器, 这里填写实际的网站地址url
    return 'resource://rawfile/index.html';
  }

  webUrlPrefix() {
    try {
        const url = Url.URL.parseURL(this.webUrl());
        return `${url.protocol}//${url.host}/`;
    } catch (err) {
        wbLogger.error(SAMPLE_INDEX_TAG, `Invalid webUrl: ${this.webUrl()}`);
        return '';
    }
  }

  build() {
    Column() {
      TaroWebContainer({
        pageState: this.pageState, // 页面状态同步到组件
        webUrl: this.webUrl(), // 初始Url
        webUrlPrefix: this.webUrlPrefix(),
        useCache: true,
        want: this.want, // want信息
        taroWebController: this.taroWebController,
        isFullScreen: true, // 是否全屏显示
        injectObj: this.nativeObj, // 注入对象
      })
        .width('100%')
        .height('100%')
    }
  }
}
```
</details>

5. 参考[Taro官方文档](https://taro-docs.jd.com/docs/GETTING-STARTED), 创建Taro工程，并编译成harmony-hybrid应用：
```shell
# yarn
$ yarn build:harmony-hybrid

# npm script
$ npm run build:harmony-hybrid

# pnpm script
$ pnpm build:harmony-hybrid

# 仅限全局安装
$ taro build --type harmony-hybrid

# npx 用户也可以使用
$ npx taro build --type harmony-hybrid
```

生成资源文件目录(默认在工程dist/目录下)：
- index.html
- chunk/
- css/
- js/
- static/

最后把生成的资源文件复制到`src/main/resources/rawfile`文件夹下，启动运行应用进行测试。或者放置到Web服务器中，通过`http(s)`协议远程访问。

### 接口说明
#### TaroWebContainer组件参数说明
| 参数名称              | 类型                | 描述                                                    | 必填                    |
|-------------------|-------------------|-------------------------------------------------------|-----------------------|
| taroWebController | TaroWebController | TaroWebContainer组件的控制器                                | 是                     |
| webUrl            | string            | 资源入口url                                               | 是                     |
| webUrlPrefix      | string            | 资源入口url的前缀，一般是 `${webUrl.protocol}://${webUrl.host}/` | 是                     |
| pageState         | HostPageState     | 传递页面状态                                                | 是                     |
| useCache          | boolean           | 是否优先使用应用内置的Web资源                                      | 否，默认值： true           |
| want              | Want              | 传递EntryAbility中`onCreate`和`onNewWant`保存的want信息        | 否，默认值： { }            |
| isFullScreen      | boolean           | 是否全屏显示应用                                              | 否，默认值： true           |
| injectObj         | ESObject          | 注入ets对象到Web环境                                         | 否：默认值：undefined       |
| showCapsule       | boolean           | 是否显示胶囊按钮                                              | 否：默认值：true            |
| capsulePage       | string            | 点击胶囊按钮跳转的页面                                           | 否：默认值：`pages/Capsule` |
| enableWebDebug    | boolean           | [开启Web调试功能][Web调试devtools配置]                          | 否：默认值：true            |


### Taro API - 权限配置表
部分API在使用的时候，需要在应用的src/main/module.json5文件中配置权限，相应的功能才能启用, 如下示例：

```json5
{
  requestPermissions: [{
      "name": "ohos.permission.INTERNET"
    }
  ]
}
```

详细信息如下：
<table>
  <tr><th>分类</th><th>Taro API</th><th>需要权限</th></tr>

  <tr>
    <td rowspan="3"  align="center">网络</td>
    <td>Taro.request</td>
    <td rowspan="3">ohos.permission.INTERNET</td>
  </tr>
  <tr><td>Taro.downloadFile</td></tr>
  <tr><td>Taro.uploadFile</td></tr>

  <tr>
    <td rowspan="9"  align="center">位置</td>
    <td>Taro.getLocation</td>
    <td rowspan="8">
      ohos.permission.LOCATION<br>
      ohos.permission.APPROXIMATELY_LOCATION
    </td>
  </tr>
  <tr><td>Taro.getFuzzyLocation</td></tr>
  <tr><td>Taro.onLocationChange</td></tr>
  <tr><td>Taro.offLocationChange</td></tr>
  <tr><td>Taro.onLocationChangeError</td></tr>
  <tr><td>Taro.offLocationChangeError</td></tr>
  <tr><td>Taro.startLocationUpdate</td></tr>
  <tr><td>Taro.stopLocationUpdate</td></tr>
  <tr>
    <td>Taro.startLocationUpdateBackground</td>
    <td>
      ohos.permission.LOCATION<br>
      ohos.permission.APPROXIMATELY_LOCATION<br>
      ohos.permission.LOCATION_IN_BACKGROUND<br>
      ohos.permission.KEEP_BACKGROUND_RUNNING
    </td>
  </tr>

  <tr>
    <td rowspan="11" align="center">设备 - 蓝牙(通用)</td>
    <td>Taro.openBluetoothAdapter</td>
    <td rowspan="9">
      ohos.permission.USE_BLUETOOTH<br>
      ohos.permission.DISCOVER_BLUETOOTH
    </td>
  </tr>
  <tr><td>Taro.closeBluetoothAdapter</td></tr>
  <tr><td>Taro.getBluetoothAdapterState</td></tr>
  <tr><td>Taro.getBluetoothDevices</td></tr>
  <tr><td>Taro.getConnectedBluetoothDevices</td></tr>
  <tr><td>Taro.onBluetoothAdapterStateChange</td></tr>
  <tr><td>Taro.offBluetoothAdapterStateChange</td></tr>
  <tr><td>Taro.onBluetoothDeviceFound</td></tr>
  <tr><td>Taro.offBluetoothDeviceFound</td></tr>
  <tr>
    <td>Taro.startBluetoothDevicesDiscovery</td>
    <td rowspan="2">
      ohos.permission.LOCATION<br>
      ohos.permission.APPROXIMATELY_LOCATION<br>
      ohos.permission.USE_BLUETOOTH<br>
      ohos.permission.DISCOVER_BLUETOOTH<br>
      ohos.permission.MANAGE_BLUETOOTH
    </td>
  </tr>
  <tr><td>Taro.stopBluetoothDevicesDiscovery</td></tr>

  <tr>
    <td rowspan="11" align="center">设备 - 蓝牙(低功耗中心设备)</td>
    <td>Taro.createBLEConnection</td>
    <td rowspan="11">
      ohos.permission.USE_BLUETOOTH<br>
      ohos.permission.DISCOVER_BLUETOOTH
    </td>
  </tr>
  <tr><td>Taro.closeBLEConnection</td></tr>
  <tr><td>Taro.getBLEDeviceCharacteristics</td></tr>
  <tr><td>Taro.getBLEDeviceRSSI</td></tr>
  <tr><td>Taro.getBLEDeviceServices</td></tr>
  <tr><td>Taro.notifyBLECharacteristicValueChange</td></tr>
  <tr><td>Taro.onBLECharacteristicValueChange</td></tr>
  <tr><td>Taro.onBLEConnectionStateChange</td></tr>
  <tr><td>Taro.readBLECharacteristicValue</td></tr>
  <tr><td>Taro.setBLEMTU</td></tr>
  <tr><td>Taro.writeBLECharacteristicValue</td></tr>

  <tr>
    <td rowspan="11" align="center">设备 - WIFI</td>
    <td>Taro.startWifi</td>
    <td rowspan="2">
      ohos.permission.GET_WIFI_INFO<br>
      ohos.permission.SET_WIFI_INFO<br>
      ohos.permission.MANAGE_WIFI_CONNECTION
    </td>
  </tr>
  <tr><td>Taro.stopWifi</td></tr>
  <tr>
    <td>Taro.connectWifi</td>
    <td>
      ohos.permission.GET_WIFI_INFO<br>
      ohos.permission.SET_WIFI_INFO<br>
      ohos.permission.MANAGE_WIFI_CONNECTION<br>
      ohos.permission.SET_WIFI_CONFIG
    </td>
  </tr>
  <tr>
    <td>Taro.getConnectedWifi</td>
    <td rowspan="8">
      ohos.permission.GET_WIFI_INFO<br>
      ohos.permission.SET_WIFI_INFO<br>
    </td>
  </tr>
  <tr><td>Taro.getWifiList</td></tr>
  <tr><td>Taro.onGetWifiList</td></tr>
  <tr><td>Taro.offWifiList</td></tr>
  <tr><td>Taro.onWifiConnected</td></tr>
  <tr><td>Taro.offWifiConnected</td></tr>
  <tr><td>Taro.onWifiConnectedWithPartialInfo</td></tr>
  <tr><td>Taro.offWifiConnectedWithPartialInfo</td></tr>

  <tr>
    <td rowspan="7" align="center">设备 - 其他</td>
    <td>Taro.startAccelerometer</td><td>ohos.permission.ACCELEROMETER</td>
  </tr>
  <tr><td>Taro.startGyroscope</td><td>ohos.permission.GYROSCOPE</td></tr>
  <tr><td>Taro.vibrateShort</td><td rowspan="2">ohos.permission.VIBRATE</td></tr>
  <tr><td>Taro.vibrateLong</td></tr>
  <tr><td>Taro.addPhoneContact</td><td>ohos.permission.WRITE_CONTACTS</td></tr>
  <tr><td>Taro.hideKeyboard</td><td>ohos.permission.CONNECT_IME_ABILITY</td></tr>
  <tr><td>Taro.getRecorderManager</td><td>ohos.permission.MICROPHONE</td></tr>

  <tr>
    <td rowspan="12" align="center">媒体</td>
    <td>Taro.previewImage</td>
    <td>
      ohos.permission.READ_MEDIA<br>
      ohos.permission.WRITE_MEDIA<br>
      ohos.permission.READ_IMAGEVIDEO<br>
      ohos.permission.INTERNET
    </td>
  </tr>
  <tr>
    <td>Taro.previewMedia</td>
    <td rowspan="11">
      ohos.permission.READ_MEDIA<br>
      ohos.permission.WRITE_MEDIA<br>
      ohos.permission.READ_IMAGEVIDEO<br>
    </td>
  </tr>
  <tr><td>Taro.chooseImage</td></tr>
  <tr><td>Taro.compressImage</td></tr>
  <tr><td>Taro.getImageInfo</td></tr>
  <tr><td>Taro.saveImageToPhotosAlbum</td></tr>
  <tr><td>Taro.chooseMedia</td></tr>
  <tr><td>Taro.chooseVideo</td></tr>
  <tr><td>Taro.compressVideo</td></tr>
  <tr><td>Taro.getVideoInfo</td></tr>
  <tr><td>Taro.saveVideoToPhotosAlbum</td></tr>
  <tr><td>Taro.createInnerAudioContext</td></tr>

</table>

权限配置相关说明请访问官方文档指南的《开发 -- 安全 -- 访问控制》章节。
权限基本信息如下：

| 权限                                      | 权限级别         | 授权方式         | ACL使能 |
|-----------------------------------------|--------------|--------------|-------|
| ohos.permission.INTERNET                | normal       | system_grant | TRUE  |
| ohos.permission.LOCATION                | normal       | user_grant   | TRUE  |
| ohos.permission.APPROXIMATELY_LOCATION  | normal       | user_grant   | FALSE |
| ohos.permission.LOCATION_IN_BACKGROUND  | normal       | user_grant   | FALSE |
| ohos.permission.KEEP_BACKGROUND_RUNNING | normal       | system_grant | TRUE  |
| ohos.permission.USE_BLUETOOTH           | normal       | system_grant | TRUE  |
| ohos.permission.DISCOVER_BLUETOOTH      | normal       | system_grant | TRUE  |
| ohos.permission.MANAGE_BLUETOOTH        | system_basic | system_grant | TRUE  |
| ohos.permission.GET_WIFI_INFO           | normal       | system_grant | TRUE  |
| ohos.permission.SET_WIFI_INFO           | normal       | system_grant | TRUE  |
| ohos.permission.MANAGE_WIFI_CONNECTION  | system_core  | system_grant | TRUE  |
| ohos.permission.SET_WIFI_CONFIG         | system_basic | system_grant | TRUE  |
| ohos.permission.ACCELEROMETER           | normal       | system_grant | TRUE  |
| ohos.permission.GYROSCOPE               | normal       | system_grant | TRUE  |
| ohos.permission.VIBRATE                 | normal       | system_grant | TRUE  |
| ohos.permission.WRITE_CONTACTS          | system_basic | user_grant   | TRUE  |
| ohos.permission.CONNECT_IME_ABILITY     | system_core  | system_grant | TRUE  |
| ohos.permission.MICROPHONE              | normal       | user_grant   | TRUE  |
| ohos.permission.READ_MEDIA              | normal       | user_grant   | TRUE  |
| ohos.permission.WRITE_MEDIA             | normal       | user_grant   | TRUE  |
| ohos.permission.READ_IMAGEVIDEO         | system_basic | user_grant   | TRUE  |


## 热更新使用指南

热更新功能支持开发者设置应用启动时访问远程API接口获取升级信息、下载远程升级包，并在应用下次启动时生效。开发者也可以结合Taro框架的API `Taro.getUpdateManager()`得到`updateManager`对象, 使用该对象的方法与用户进行交互, 提示是否立即应用更新。

### `arkts`端配置

热更新功能的配置与调用, 如示例所示：

```ts
import { LocalUpdateManagerInstance, UpdateConfig } from '@hybrid/web-container';
const localDefaultVersion: string = '0';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want) {
    const versionCompare = (a: string, b: string) => a > b;
    const urlFunc = (version: string) => `http://域名/apis/config?local_version=${version}`;
    const updateConfig = UpdateConfig.getInstance().setup(localDefaultVersion, urlFunc, versionCompare);
    LocalUpdateManagerInstance.updateMiniOnLaunch(this.context);
  }
  onNewWant(want: Want) {
    storage.setOrCreate('want',  want);
  }
  //...
}
```
UpdateConfig的setup方法包含三个参数：
- initialVersion: string 初始版本号；应用内置的资源初始版本。
- urlFunc: (string) => string 自定义版本信息url生成函数；通过该函数生成新的网络请求url，附带有本地的版本号，用于服务器判断是否需要升级。
- versionCompare: (string, string) => boolean 自定义版本比对函数；通过该函数排序本地缓存的升级包，得到本地在用的最新版本号。


服务器端通过版本比对，返回两种信息之一：
- 需要更新离线资源

假设本地版本号为`0`，服务端的最新资源版本为`1`，则需要更新。服务端根据接口约定将升级信息返回给应用。信息示例如下所示：

```json
{
  "code": 200,
  "message":"request OK",
  "data": {
    "mini_download_url": "https://域名/mpharmony/mpharmony.zip",
    "mini_version": 1
  }
}
```

其中，`data`字段中的`mini_download_url`字段表示需要下载资源的网络url，热更新模块使用该url进行资源下载。

- 本地资源是最新的

假设本地版本号为`1`，服务端的最新资源版本为`1`，则不需要更新。服务端根据接口约定将信息返回给应用。信息示例如下所示：

```json
{
  "code": "300",
  "message": "latest version"
}
```

### js端

用户可以在`js`端通过Taro API实现相应的业务，实现例子如下所示：

```ts
const updateManager = Taro.getUpdateManager()
updateManager.onCheckForUpdate((hasUpdate: boolean) => {
    console.log("onCheckForUpdate")
})
updateManager.onUpdateReady((updatedPath: string) => {
    updateManager.applyUpdate()
})
updateManager.onUpdateFailed(() => {
    console.log("UpdateFailed")
})
```

**注意：需要确保在arkTs端热更新模块请求网络完成或者下载好更新之前完成监听函数的注册，不然可能arkTs已通知完毕，js端监听不到通知**

[Web调试devtools配置]: https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/web/web-debugging-with-devtools.md
[NEXT招募]: https://developer.huawei.com/consumer/cn/activityDetail/harmonyos-next-preview/