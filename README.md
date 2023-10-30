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
         - controllers： 包含导航栏状态控制和路由控制 
         - inject_adapter： 高阶API注入对象适配
         - interfaces： 接口
         - utils： 实用工具类和函数

### 使用示例
```js
// Sample/src/main/ets/pages/Index.ets
import { TaroWebContainer, InjectObject, HostPageState, RouterController } from 'TaroWebContainer';
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
        routerController: this.routerController, // 页面路由控制
        isFullScreen: true, // 是否全屏显示
        injectObj: this.nativeObj, // 注入对象
      })
        .width('100%')
        .height('100%')
    }
  }
}
```
    
### 版本修订记录
20230830:
 - 添加advanced_api_har.har包及依赖配置，原advancedapi.min.js直接引用方式修改为引用har包。
 - 修改web组件执行js脚本的时机，将onPageEnd修改为onPageBegin，解决生命周期方法报错问题。