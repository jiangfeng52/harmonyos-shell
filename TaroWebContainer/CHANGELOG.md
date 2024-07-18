## 2.0.0-rc.4
- TaroWebContainer增加userAgent属性，支持设置自定义用户代理
- 修复advanceAPI的uploadFile接口报错
- 解决混合路由bug,直接从Taro返回时，原生侧不能同步返回
- 导航栏适配深色模式

## 2.0.0-rc.3
- 修复TaroHybridManagerOptions接口的uiAbilityContext拼写问题
- TaroWebContainer支持使用TaroHybridManager.init的injectNativeMethod参数注入API
- 导出taroStorage对象支持业务访问Taro数据缓存

## 2.0.0-rc.2
- 修复request问题
- 同层渲染Map添加Marker属性支持
- chooseMedia修改为使用系统picker，支持两种实现方式
- 修改previewImage为原生实现
- 通过JSBridge发起网络请求，统一添加user-agent

## 2.0.0-rc.1
- 优化组件同层渲染能力
- 修复previewImage保存不生效的问题
- 修复音频播放无法暂停的问题
- 修复request请求无法返回ArrayBuffer数据问题
- 默认不显示导航栏
- 适配H5暗黑模式
- TaroWebContainer组件增加navigationInitVisible参数

## 2.0.0-rc.0
优化JSBridge通道

## 1.0.1
修复部分API的bug以及添加IDE/SDK/Taro版本限制

## 1.0.0
提供定制化Web容器来运行Taro生成的harmony-hybrid类型的Web应用