# harmonyos-shell
### 简介
harmonyos-shell包含一个定制化的TaroWebContainer实现，旨在为Taro工程的mpharmony平台产物提供运行环境。同时提供Sample例程演示如何使用该容器。

### 使用
- 根据Taro官方文档，把Taro工程编译成mpharmony平台应用
- 把生成产物放置到Sample/src/main/resources/rawfile目录下
- 编译运行Sample应用

### [项目目录解析](./design/目录结构解析.md)
- Sample： TaroWebContainer应用示例 
- TaroWebContainer: 定制化的Web运行环境，允许运行Taro的mpharmony类型生成的bundles
  - src
    - main
      - ets
         - components： 自定义组件
         - inject_adapter： 高阶API注入对象适配
         - interfaces： 接口
         - utils： 实用工具类和函数

### 使用示例
```js
// Sample/src/main/ets/pages/Index.ets
import { TaroWebContainer, InjectObject, HostPageState, TaroWebController } from 'web-container';
...
@Entry(storage)
@Component
struct TaroMpharmonySample {
  ...
  build() {
    Column() {
      TaroWebContainer({
        pageState: this.pageState, // 页面状态同步到组件
        indexUrl: this.entryUrl(), // 初始Url
        useBuildIn: this.useBuildIn, // 是否使用内置的rawfile资源
        entryDomain: this.entryDomain, // 远程资源域名
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

### 问题列表
| 问题描述 | 优先级 | 处理情况 | 问题相关链接                     |
| ------- | ------ | -------- |----------------------------|
| 导航栏与Web组件层叠布局情况下，页面插入的空白div导致页面内元素的position:fixed定位时效 | `高` | 未解决 | [导航栏设计](./design/导航栏设计.md) |
| 应用切入后台在切入前台，web页面没停留在切入后台前的页面，而是回到了首页 | 中 | 未解决 ||
| 当页面加载异常的时候，导航栏标题显示的是异常url，应该显示navigationBarTitleText配置值 | 低 |  未解决 ||
| 通过chrome://inspect进行调试的页面出现GET http://10.253.108.182:10086/favicon.ico net::ERR_ADDRESS_UNREACHABLE 的错误 | 低 | 未解决 ||
|  通过chrome://inspect进行调试的页面，使用内置资源，但调试界面地址栏显示的还是IP，误导开发者 | 低 | 未解决 ||



### 版本修订记录
2023/11/11
 - 修复Taro.setNavigationBarColor 时，状态栏的前景色没跟着变化

2023/11/02
 - 新增功能
   - 增加日志类，优化日志打印
   - web容器模块发布名称改成web-container, 通过 `import { TaroWebContainer } from 'web-container'` 的格式进行导入

2023/10/31
 - 重构目录，封装Web容器模块
   - 增加TaroWebContainer组件
   - 增加TaroWeb组件
   - 增加NavigationBar导航栏
   - 增加BaseCapsule组件以及BaseDeveloper组件
  
export const NativeApiUpdate: ESObject = {
  getWindowInfoBridgeSync: as['getWindowInfo'],
  getSystemSettingBridgeSync: as['getSystemSetting'],
  makePhoneCallBridgeAsync: (options: ESObject) => {
    // as.makePhoneCall(options)
    as.makePhoneCall({
      ...options,
      success:(args:ESObject)=>{
        console.log('[advancedAPI 5]')
        options.success(args)
      },
      fail:(args:ESObject)=>{
        console.log('[advancedAPI 5]')
        options.fail(args)
      }
    })
  },

  onUserCaptureScreenBridgeAsync: (options: ESObject) => {
    as.onUserCaptureScreen(options)
  }
}

import { MethodChannelInstance } from '../inject_adapter/Channel';
import { NativeApiUpdate } from '../inject_adapter/NativeApi'
MethodChannelInstance.registerMethods(NativeApiUpdate)

if (methodName.startsWith('on')) {


