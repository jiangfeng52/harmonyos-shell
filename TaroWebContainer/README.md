# web-container
### 简介
**`web-container` 是一个定制化 Web 容器以及提供热更新等功能的模块。支持运行 Taro 生成的 `harmony-hybrid` 应用**

提供的能力：
- 提供 `TaroWebContainer` 组件，支持运行 harmony-hybrid 应用（Taro框架）；
- 提供 `TaroHybrid` 组件支持多Web容器和容器复用；
- 支持通过注册API扩展H5平台不支持的系统访问能力；
- 支持通过注册同层渲染组件扩展前端组件；

### 下载安装

```
ohpm install @hybrid/web-container
```

### 约束与限制
在下述版本验证通过：

- `DevEco Studio 5.0.3.403` (>= 5.0.3.100), API11及以上
- `Taro 3.6.32` （>= 3.6.25）
- `@hybrid/web-container 2.0.0-rc.3` 

### TaroWebContainer组件使用指南
#### 1. 创建鸿蒙工程
- 使用 [DevEco Studio][DevEco Studio] 开发工具新建应用工程，选择 `Empty Ability` 模板，使用默认配置。 
- 在 `entry/oh-package.json5` 文件中添加  `@hybrid/web-container`模块的依赖并点击 `Sync Now` 进行同步：

  ```json
  {
    "license": "ISC",
    "devDependencies": {},
    "name": "entry",
    "description": "演示如何使用TaroWebContainer组件",
    "version": "1.0.0",
    "dependencies": {
      "@hybrid/web-container": "2.0.0-rc.3"
    }
  }
  ```

- 在 `entry/src/main/ets/entryability/EntryAbility.ets` 文件的 `onWindowStageCreate` 生命周期函数中调用 `TaroHybridManager.init` 初始化web-container环境：

  ```js
  import { TaroHybridManager } from '@hybrid/web-container';
  // ...
  export default class EntryAbility extends UIAbility {
    // 其他生命周期函数处理，此处省略
    // ...
    onWindowStageCreate(windowStage: window.WindowStage) {
      windowStage.loadContent('pages/Index', storage, (err, data) => {
        const windowClass: window.Window = windowStage.getMainWindowSync();
        TaroHybridManager.init({
          uiAbilityContext: this.context,
          windowClass,
        })
      });
    }
  }
  ```

- 在 `entry/src/main/ets/pages/Index.ets` 主页面文件中使用 `TaroWebContainer` 组件：

  ```js
  // entry/src/main/ets/pages/Index.ets
  import Url from '@ohos.url';
  import { TaroWebContainer, InjectObject, HostPageState, TaroWebController } from '@hybrid/web-container';
  
  @Entry
  @Component
  struct TaroMpharmonySample {
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
          return '';
      }
    }
  
    build() {
      Column() {
        TaroWebContainer({
          pageState: this.pageState, // 页面状态同步到组件
          webUrl: this.webUrl(), // 初始Url
          webUrlPrefix: this.webUrlPrefix(),
          useCache: false,
          taroWebController: this.taroWebController,
          isFullScreen: true, // 是否全屏显示
          injectObj: this.nativeObj, // 注入对象
          forceDarkAccess: true,
        })
          .width('100%')
          .height('100%')
      }
    }
  }
  ```

- 参考[Taro官方文档](https://taro-docs.jd.com/docs/GETTING-STARTED), 创建Taro工程，并编译成harmony-hybrid应用：
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

  最后把生成的资源文件复制到 `src/main/resources/rawfile` 文件夹下，启动运行应用进行测试。或者放置到Web服务器中，通过`http(s)`协议远程访问。


#### 2. TaroHybridManager.init 参数说明
init方法的参数类型为 `TaroHybridManagerOptions`, 各字段说明如下： 

| 字段名称                   | 类型                           | 描述                            | 必填 |
|------------------------|------------------------------|-------------------------------|----|
| uiAbilityContext       | UIAbilityContext             | UIAbility的上下文对象               | 是  |
| windowClass            | Window                       | 主窗口                           | 是  |
| injectObjectController | () => InjectObjectController | 注入对象控制器                       | 否  |
| nativeBack             | () => void                   | 多容器场景回退自定义函数，只作用于TaroHybrid组件 | 否  |
| rootIndexHtmlPath      | string                       | 主资源路径，只作用于TaroHybrid组件        | 否  |
| forceDarkAccess        | boolean                      | 是否强制反色适配深色模式，只作用于TaroHybrid组件 | 否  |
| domain                 | string                       | 小程序域名，只作用于TaroHybrid组件        | 否  |

#### 3. TaroWebContainer组件参数说明

| 参数名称              | 类型                | 描述                                                    | 必填                    |
|-------------------|-------------------|-------------------------------------------------------|-----------------------|
| taroWebController | TaroWebController | TaroWebContainer组件的控制器                                | 是                     |
| webUrl            | string            | 资源入口url                                               | 是                     |
| webUrlPrefix      | string            | 资源入口url的前缀，一般是 `${webUrl.protocol}://${webUrl.host}/` | 是                     |
| pageState         | HostPageState     | 传递页面状态                                                | 是                     |
| forceDarkAccess   | boolean           | 是否强制反色适配深色模式                                          | 是         |
| useCache          | boolean           | 是否优先使用应用缓存的Web资源                                      | 否，默认值： true           |
| want              | Want              | 传递EntryAbility中`onCreate`和`onNewWant`保存的want信息        | 否，默认值： { }            |
| isFullScreen      | boolean           | 是否全屏显示应用                                              | 否，默认值： true           |
| injectObj         | ESObject          | 注入ets对象到Web环境                                         | 否：默认值：undefined       |
| showCapsule       | boolean           | 是否显示胶囊按钮                                              | 否：默认值：true            |
| capsulePage       | string            | 点击胶囊按钮跳转的页面                                           | 否：默认值：`pages/Capsule` |
| enableWebDebug    | boolean           | [开启Web调试功能][Web调试devtools配置]                          | 否：默认值：true            |
| navigationInitVisible | boolean           | 控制导航栏初始显示状态                                           | 否：默认值：true            |
| userAgent             | string            | 自定义用户代理                                               | 否           |
| getLoadCommittedDetails | Function        | 网页跳转时触发该回调方法                                       | 否           |
#### 4. Taro API - 权限配置表
部分API在使用的时候，需要在应用的src/main/module.json5文件中配置权限，相应的功能才能启用, 如下示例：

```json5
{
  requestPermissions: [{
      "name": "ohos.permission.INTERNET"
    }
  ]
}
```

### 其他能力
TaroHybrid组件以及其他能力说明请参考 `Taro` 官方文档关于 [Harmony Hybrid][Taro Harmony Hybrid] 平台的介绍。

[Web调试devtools配置]: https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/web/web-debugging-with-devtools.md
[Taro Harmony Hybrid]: https://docs.taro.zone/docs/harmony-hybrid/
[DevEco Studio]: https://developer.huawei.com/consumer/cn/download/