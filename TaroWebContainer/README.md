# web-container

**提供定制化Web容器来运行Taro生成的mpharmony类型的Web应用**

## 下载安装

```
ohpm install @ohos/web-container
```

### 使用示例
```js
// entry/src/main/ets/pages/Index.ets
import { TaroWebContainer, InjectObject, HostPageState, TaroWebController } from '@ohos/web-container';
...
@Entry(storage)
@Component
struct TaroMpharmonySample {
  ...
  build() {
    Column() {
      TaroWebContainer({
        pageState: this.pageState, // 页面状态同步到组件
        webUrl: this.webUrl(), // 初始Url
        webUrlPrefix: this.webUrlPrefix(),
        useCache: this.useCache(),
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