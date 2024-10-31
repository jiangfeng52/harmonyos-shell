## 2.0.0-rc.8
- 初始化injectNativeMethod 修改为injectObjectController，支持创建和销毁生命周期
- 替换mediaLibrary断代接口
- 页面加载设置导航栏样式时状态栏颜色适配深色模式
- 升级videocompressor依赖版本，支持H265格式的的视频压缩
- 增加TaroHybridManager.getWebController()接口，获取组件绑定webController

## 2.0.0-rc.7
- 小程序资源的热更新功能完成，优化部分api和代码

## 2.0.0-rc.6
- 修复getEmbedWidth和getEmbedHeight返回值为undefined的情况是报错
- 视频文件不再支持压缩 
- 地图的缩放控件和缩放手势保持统一的显示隐藏状态
- 修复web组件打开时闪烁白屏的问题
- url后面拼接的from参数容易引起冲突，修改为tarofrom
- 修复advancedApi中uploadFile中data中字符串再序列化导致的报错

## 2.0.0-rc.5
- TaroWebContainer增加getLoadCommittedDetails属性方法，网页跳转时触发回调方法
- TaroHybridManager增加initLoadCommittedDetails方法，网页跳转时触发回调
- 修复previewImage方法图片无缩放时滑动不跟手问题
- 优化Taro Storage缓存，解决跨Web容器修改Storage后缓存不更新

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