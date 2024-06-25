# harmonyos-shell
### 简介
harmonyos-shell包含一个定制化的TaroWebContainer实现，旨在为Taro工程的harmony-hybrid平台产物提供运行环境。同时提供Sample例程演示如何使用该容器。

### 使用
- 根据Taro官方文档，把Taro工程编译成harmony-hybrid平台应用
- 把生成产物放置到Sample/src/main/resources/rawfile目录下
- 编译运行Sample应用

### 使用示例
```js
// Sample/src/main/ets/pages/Index.ets
import { TaroWebContainer, InjectObject, HostPageState, TaroWebController } from '@ohos/web-container';
...
@Entry(storage)
@Component
struct TaroMpharmonySample {
  ...
  build() {
    Column() {
      TaroWebContainer({
        indexHtmlPath: 'index.html',
        pageState: this.pageState, // 页面状态同步到组件
        webUrl: this.webUrl(), // 初始Url
        webUrlPrefix: this.webUrlPrefix(),
        useCache: true, // 使用缓存资源
        want: this.want, // want信息
        taroWebController: this.taroWebController,
        isFullScreen: false, // 是否全屏显示
        injectObj: this.nativeObj, // 注入对象
        navigationInitVisible: true, // 导航栏是否显示
        forceDarkAccess: true
      })
        .width('100%')
        .height('100%')
    }
  }
}
```
