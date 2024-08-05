## 3.6.29-harmony-hybrid-alpha.37
- 把changelog.md由大写改为小写

## 3.6.29-harmony-hybrid-alpha.36
- 修改命名空间

## 3.6.29-harmony-hybrid-alpha.35
- 添加版本修改命令，用于正式发布
- 修改版本号：与Taro的版本号配对
- Merge pull request #1 from handsomeliuyang/fix-mix-router-animation
- build(rawfile): 更新mini-program小程序的内置资源
- fix(混合路由)：解决混合路由的bug：直接从Taro返回时，原生侧不能同步返回 解决思路： 1. 原生侧向Taro提供nativeBack() Api 2. 从Taro侧发起返回：拦截navigateBack()方法，判断当前页面的来源，来自原生则同步通知原生侧back
- Merge pull request #184 from jiangfeng52/f-scene-build-error-kxj
- 引用错误修改
- Merge pull request #183 from jiangfeng52/f-res-upgrade-kxj
- 修改语法错误
- 1. 解决前端资源升级后白屏的问题 2. 优化启动时前端资源的版本更新逻辑，确保页面加载时版本信息已更新
- Merge pull request #182 from heweishui/main
- fix: 修改memoryManager导入路径
- Merge pull request #181 from heweishui/main
- fix: 修复缺少引号报错
- Merge pull request #180 from xiaoyan428820/harmonyos-shell-sameLayerRender
- Delete TaroWebContainer/src/main/ets/scene_apis/location/location.ets
- Merge pull request #177 from xiaoyan428820/harmonyos-shell-sameLayerRender
- 补充同层渲染地图修改
- Merge branch 'harmonyos-shell-sameLayerRender' of github.com:xiaoyan428820/harmonyos-shell into harmonyos-shell-sameLayerRender
- Merge branch 'jiangfeng52:main' into harmonyos-shell-sameLayerRender
- fix: 修复无网状态下previewImage背景透明问题，修改保存图片为长按弹窗实现。
- Merge pull request #179 from handsomeliuyang/main
- 缓存策略优化：缓存没有命中时，不走网络，因为webUrlPrefix域名为假域名，与微信小程序的机制一样，需要走真实不一样的全路径
- Merge pull request #178 from handsomeliuyang/main
- 通过jsbridge发起网络请求，统一添加user-agent
- Delete TaroWebContainer/src/main/ets/scene_apis/interface/index.ets
- Delete TaroWebContainer/src/main/ets/scene_apis/index.ets
- feat: 新增previewImage实现，优化地图加载速度。
- Merge pull request #176 from handsomeliuyang/main
- loadUrl()返回是否成功的标识
- Merge pull request #175 from handsomeliuyang/main
- 容器复用时，采用Taro的路由实现navigate，而不是直接重新loadUrl
- TaroHybridCoreInstance提取为独立文件
- Merge pull request #173 from guoenxuan/fix-capsule-api
- Merge pull request #174 from handsomeliuyang/main
- nativeBack支持连续多次返回
- Merge pull request #172 from handsomeliuyang/main
- 解决多容器共用后，返回白屏问题
- 修改setCapsuleState接口
- Merge pull request #171 from jiangfeng52/f-window-util-kxj
- 去除app.js
- 去除签名
- Sample更新：SafeArea组件的topRectHeight赋值；更新资源
- Merge pull request #170 from heweishui/main
- fix: 修改chooseMedia返回的路径，替换advancedapi产物，access支持Internal路径
- Merge pull request #168 from licunhao1/main
- Merge pull request #167 from jiangfeng52/fix-safe-area-kxj
- Merge pull request #163 from jiangfeng52/fix-web-back-native-kxj
- Merge pull request #169 from xiaoyan428820/harmonyos-shell-sameLayerRender
- fix: 优化日志打印，优化API调用，修复部分API调用报错问题
- feat: 删除navigateToMiniProgram相关实现
- 去除多余修改
- 签名配置去除
- Merge remote-tracking branch 'origin/main' into fix-safe-area-kxj
- 更新Sample：安全区域适配
- Merge pull request #165 from chenai02/main
- Merge pull request #166 from handsomeliuyang/main
- fix: 优化JSBridge部分引用未能及时释放问题
- Merge remote-tracking branch 'upstream/main'
- 解决页面刷新时，批量获取的数据为老数据
- Merge pull request #164 from handsomeliuyang/main
- 优化Log日志的写法
- web回退原生判断逻辑修改
- web回退原生判断逻辑修改
- Merge pull request #162 from chenai02/main
- fix: 修复JSBridge对监听函数内存泄漏问题
- Merge pull request #161 from heweishui/main
- fix: chooseMedia适配为两种实现方式
- feat: 为request兼容ArrayBuffer数据
- Merge pull request #160 from handsomeliuyang/main
- 优化热更新的缓存兜底策略
- 解决Webview的ssl安全性问题，以及关闭h5的geolocation api，如果需要定位，走jsbridge
- Merge pull request #159 from handsomeliuyang/main
- 删除app.js里的console.log
- Merge pull request #158 from jiangfeng52/f-choose-api-sandbox-path-kxj
- FileSystemManager不支持internal路径，因此选择的文件不再使用internal路径
- Merge pull request #155 from xiaoyan428820/harmonyos-shell-sameLayerRender
- Merge pull request #157 from jiangfeng52/f-choose-media-picker-kxj
- chooseMedia修改为使用picker版本
- Merge pull request #156 from handsomeliuyang/main
- Merge pull request #147 from jiangfeng52/f-opt-navigation-bar-kxj
- 解决冲突
- Merge branch 'main' into f-opt-navigation-bar-kxj
- 新增：首屏storage原生提前加载 -- 补充log
- 新增：首屏storage原生提前加载--bug修改
- 更新mini-program的内置资源
- 处理log日志
- Merge remote-tracking branch 'upstream/main'
- Merge pull request #154 from jiangfeng52/f-reload-imme-kxj
- 首屏storage原生提前加载
- 重构：JSBridge支持异步转同步执行，解决arkTS仅有异步函数的情况（如kvStore） 新增：首屏storage原生提前加载
- feat: 同层渲染Map添加Marker属性支持
- 重新加载按钮点击后不生效的问题修复
- Merge pull request #152 from chenai02/test1
- fix: 修复部分实例无法创建以及与web端实例同步问题
- Merge pull request #153 from handsomeliuyang/main
- 提交“端上预渲染”的代码，暂时先不生效
- 支持Javascript预编译（ResponseDataID）
- 迁移到DevEco 5.0
- Merge pull request #151 from adewu/f-usecache-logic-opt_wxm
- [mod]:优化调试模式走缓存逻辑、收敛HybridCore中调试布局的代码提高可读性
- Merge pull request #150 from xiaoyan428820/harmonyos-shell-sameLayerRender
- fix: 修复request超时timeout参数未设置时导致请求立即超时问题
- Merge pull request #149 from licunhao1/main
- feat: 修复previewImage样例预览图片长按保存图片不生效问题
- Merge branch 'test' into test1
- feat: 优化JSBridge中实例方法过多问题
- 导航栏样式优化
- Merge pull request #146 from xiaoyan428820/harmonyos-shell-sameLayerRender
- fix: 修复音频播放无法暂停问题，修复request请求超时设置及无法返回ArrayBuffer数据问题
- Merge pull request #145 from jiangfeng52/f-opt-native-cache-manager-kxj
- 1. NativeRegister接口修改，支持一个NativeRegister类注册多个native api 2. 支持前端注册多个NativeDataChangeListener
- NativeRegister接口修改，增强实现类约束力
- 去重
- 导出修改
- Merge branch 'main' of github.com:jiangfeng52/harmonyos-shell into f-opt-native-cache-manager-kxj
- Merge pull request #144 from handsomeliuyang/main
- Native API缓存优化，可在任意处调用注册，不依赖初始化方法
- Native API缓存优化，可在任意处调用注册，不依赖初始化方法
- 添加trace,默认关闭，支持业务配置打开
- Merge pull request #143 from jiangfeng52/f-logger-opt-kxj
- 日志打印模块优化：新增debuggable配置，目前可以控制日志打印；日志模块不再对外部导出；Sample中新增日志工具类
- Merge pull request #142 from handsomeliuyang/main
- 最低支持版本改为11，可以支持mate 40手机使用
- Merge pull request #136 from jiangfeng52/f-native-api-cache2
- feat: fix_error
- Merge branch 'main' of github.com:jiangfeng52/harmonyos-shell into f-native-api-cache2
- Merge pull request #141 from heweishui/main
- fix: 修复同层渲染map问题
- Merge pull request #140 from xiaoyan428820/harmonyos-shell-sameLayerRender
- MapManager修改。
- 新增Map同层渲染、openLocation/chooseLocation新增桥接原生控件，定位接口优化。
- feat: NativeCacheManager修改解除注册方法
- feat: NativeCacheManager和容器绑定
- Merge pull request #139 from jiangfeng52/f-hide-navigation-bar-default-kxj
- feat: taro同步缓存方法，在容器disappear时解除注册
- 默认不显示导航栏
- Merge branch 'main' of github.com:jiangfeng52/harmonyos-shell into f-native-api-cache2
- feat: taro同步方法支持缓存，优化代码
- Merge pull request #137 from jiangfeng52/f-support-force-dark-kxj
- forceDarkAccess参数放到init方法中
- forceDarkAccess参数放到init方法中
- 支持设置强制反色适配深色模式
- feat: taro同步方法支持缓存，并且支持外部注册管理
- feat: taro同步方法支持缓存，重新采用注册的机制
- Merge pull request #134 from heweishui/main
- feat: 增加视频/图片选择接口chooseMedium
- Merge pull request #133 from licunhao1/main
- fix:删除dialogShownResults，外发SDK该字段未满足
- Merge pull request #132 from handsomeliuyang/main
- 多容器支持物理返回
- Merge pull request #127 from adewu/f-cross-origin_wxm
- Merge pull request #131 from licunhao1/main
- fix: module配置属性名更改
- Merge remote-tracking branch 'origin/f-cross-origin_wxm' into f-cross-origin_wxm
- [mod]:优化文件结构
- Merge branch 'main' into f-cross-origin_wxm
- [mod]:优化taroWeb拦截器逻辑
- Merge pull request #130 from jiangfeng52/fix-url-encode-kxj
- Merge branch 'main' of github.com:jiangfeng52/harmonyos-shell into fix-url-encode-kxj
- fix: 解决url被encode的bug
- fix: 解决url被encode的bug
- Merge pull request #129 from heweishui/main
- fix: 替换advanceapi,修复模拟器报错
- Merge pull request #128 from jiangfeng52/fix-spell-error-kxj
- fix: 修复拼写错误
- [mod]:修改默认加载地址
- [mod]:删除无用变量，抽离公共方法
- [mod]:直接使用http请求获得资源文件并返回，优化handler调用逻辑
- Merge pull request #126 from licunhao1/main
- feat: 新增动态权限支持用户自定义逻辑
- Merge branch 'main' into f-cross-origin_wxm
- 处理调试模式下跨域问题
- Merge pull request #124 from handsomeliuyang/main
- Merge remote-tracking branch 'upstream/main'
- 返回逻辑优化：支持业务扩展
- Merge pull request #125 from xiaoyan428820/harmonyos-shell-sameLayerRender
- Merge branch 'harmonyos-shell-sameLayerRender' of github.com:xiaoyan428820/harmonyos-shell into harmonyos-shell-sameLayerRender
- fix: 修复同层渲染失效问题
- 返回逻辑优化：当已经返回到此容器的rootPage时，不再进行Web的back()了
- Merge pull request #123 from jiangfeng52/huzhan
- feat: 增加navigationInitVisible参数,在初始化是否显示导航栏
- Merge pull request #120 from jiangfeng52/f-5-0
- Merge pull request #121 from xiaoyan428820/harmonyos-shell-sameLayerRender
- Merge branch 'jiangfeng52:main' into harmonyos-shell-sameLayerRender
- Web容器支持自定义组件同层渲染能力
- 升级为5.0.0(12)：多容器的情况下，通过dispose()方法，及时释放BuilderNode的内存
- Merge pull request #119 from zxdsax/main
- fix: 更新壳工程中的advanceApi
- 升级为5.0.0(12)
- Merge pull request #118 from zxdsax/main
- fix: 日志打印格式修改
- Merge pull request #117 from zxdsax/main
- fix: 日志打印格式修改
- Merge pull request #116 from zhangzhixin2199/f-zhangzhixin
- 小程序内置磁盘更新
- Merge pull request #115 from jiangfeng52/osChannel
- Merge remote-tracking branch 'origin/main' into osChannel
- Merge pull request #114 from guoenxuan/taro-web-example
- 增加TaroWebContainer组件使用示例
- Revert "feat: 支持osChannelApi"
- Merge pull request #112 from jiangfeng52/osChannel
- Revert "删除TaroWebContainer组件无效的storage参数"
- Merge pull request #110 from guoenxuan/fix-storage
- 删除TaroWebContainer组件无效的storage参数
- Merge pull request #109 from guoenxuan/update-advanceapi-0325
- 更新高级api
- Merge pull request #107 from jiangfeng52/osChannel
- Merge pull request #108 from jiangfeng52/f-navigatorback-ly
- 解决原生导航的返回事件问题
- fix: osChannel开启说明
- feat: 支持osChannelApi
- Merge pull request #106 from guoenxuan/fix-api-context
- 修复直接使用TaroWebContainer组件应用崩溃的问题
- Merge pull request #105 from jiangfeng52/delete-storage
- fix: 删除多余的属性storage
- Merge pull request #104 from jiangfeng52/f-ly-recycle
- 多容器实例重构: 引用计数器回收
- 多容器实例重构
- Merge pull request #103 from jiangfeng52/f-ly-persistent
- 解决domain退出无法持久化的问题
- Merge pull request #102 from jiangfeng52/f-multi
- Merge remote-tracking branch 'origin/f-multi-instance-liuyang' into f-multi-instance-liuyang
- 多容器和容器共用
- 多容器和容器共用：融合数据共享的代码
- 多容器和容器共用：mini-program模拟的测试Case
- 多容器和容器共用
- Merge pull request #98 from jiangfeng52/dataSharing
- 多容器和容器共用：mini-program模拟的测试Case
- 多容器和容器共用
- Merge remote-tracking branch 'origin/main' into dataSharing
- Merge pull request #100 from jiangfeng52/f-liuyang-multi-instance
- Channel通道支持多实例
- Channel通道支持多实例
- Merge pull request #99 from chenai02/main
- feat：补充getSetting和openSetting接口的complete回调
- feat: 数据共享，实现数据共享NativeApi
- Merge remote-tracking branch 'origin/main' into dataSharing
- Merge pull request #96 from chenai02/main
- feat：桥接部分蓝牙模块功能
- feat: 数据共享，实现数据共享NativeApi
- Merge pull request #93 from chenai02/main
- fix: 修复getWindowInfo在折叠屏展开模式和折叠模式获取屏幕宽度错误问题
- Merge pull request #92 from jiangfeng52/feat_subscribemessage
- feat: 桥接requestSubscribeMessage接口
- Merge pull request #91 from chenai02/main
- feat: 桥接login接口和setNavigationStyle接口
- Merge pull request #89 from jiangfeng52/device_fix
- 增加对屏幕、联系人、罗盘等设备类接口的适配
- Merge pull request #88 from chenai02/main
- 删除一些不必要的代码及注释，修改自定义方法注册方式，并适配getUpdateManager对象方法
- 合并主分支代码
- Merge branch 'main' of github.com:chenai02/harmonyos-shell into test1
- Merge pull request #87 from chenai02/test1
- fix: 将通道中map改为对象
- Merge pull request #85 from chenai02/test1
- fix: 修复rawfile路径不存在导致编译失败问题
- Merge pull request #84 from chenai02/test1
- feat:将通信通道js侧内容转移到ts文件内，并将装饰器内容也转移其中
- Merge pull request #82 from chenai02/test1
- Update TaroWeb.ets
- Update NativeApi.ets
- feat:适配取消屏幕截图监听函数接口
- Delete TaroWebContainer/BuildProfile.ets
- feat:将注册方式修改为批量注册
- Merge pull request #81 from chenai02/test1
- fix:优化通信通道，改变了部分监听函数的注册方式,修复监听函数多次注册以及无法取消已经注册的监听函数等问题
- Merge pull request #80 from chenai02/test1
- 优化通信通道
- Merge remote-tracking branch 'origin/test1' into test1
- Merge pull request #74 from guoenxuan/ohos-to-hybrid
- 对innerAudioContext进行适配
- @ohos/web-container改名为@hybrid/web-container
- Merge pull request #79 from guoenxuan/test1
- 增加readFile(Sync)实现
- Merge pull request #76 from jiangfeng52/f-add-exit-api-kxj
- fix: 删除签名配置
- Merge pull request #78 from jiangfeng52/main
- Merge pull request #77 from chenai02/test1
- 对优化后的JsBridge通信通道重新接口适配
- fix: 修改接口定义
- Merge branch 'main' of github.com:jiangfeng52/harmonyos-shell into f-add-exit-api-kxj
- Merge pull request #75 from guoenxuan/upate-build-dependencies
- 更新hvigor编译依赖配置
- 优化jsbridge通信
- 优化jsbridge通信
- 通信通道优化测试
- 移除通信通道后缀注册方式，改为mode对象注册
- fix: 添加exitMiniProgram API
- Merge pull request #70 from jiangfeng52/jf_dev
- fix:修复压缩png无效
- Merge pull request #69 from chenai02/main
- 修复热更新立即更新机制不生效问题
- Merge pull request #68 from guoenxuan/fix-duration-config
- chooseMedia改用cameraPicker拉起相机
- Merge pull request #67 from guoenxuan/fix-album-status-bar
- 进入相册时系统状态栏设置为白色/退出时恢复
- Merge pull request #66 from guoenxuan/add-api-permission-info
- 补充Taro API与权限配置表
- Merge pull request #64 from guoenxuan/fix-esobject-warn
- 修复报警信息并升级videocompressor模块到1.0.2正式版
- Merge pull request #63 from jiangfeng52/jf_dev
- fix：更新advancedapi.min.js包,剔除扫码功能
- Merge pull request #62 from jiangfeng52/jf_dev
- fix：更新advancedapi.min.js包
- Merge pull request #61 from guoenxuan/fix-debug-config
- 增加开启Web调试配置参数
- Merge pull request #60 from guoenxuan/fix-md
- mpharmony修正为harmony-hybrid
- Merge pull request #59 from guoenxuan/fix-choose-gif
- 非jpg/png/webp图片压缩时返回原图
- Merge pull request #58 from guoenxuan/optimize-docs
- 优化热更新文档
- Merge pull request #57 from jiangfeng52/test
- 优化热更新代码逻辑
- Merge pull request #53 from secondone21/main
- 壳工程升级，由api 10升级到api 11
- Merge pull request #49 from guoenxuan/fix-read-file
- arkts和js通信增加支持ArrayBuffer
- Merge pull request #48 from jiangfeng52/f-kxj
- fix: 修复TaroWebContainer中导入代码大小写错误
- fix: 修复TaroWebContainer中导入代码大小写错误
- Merge pull request #47 from jiangfeng52/test2
- Update 热更新使用.md
- Merge pull request #45 from jiangfeng52/jf_dev
- fix：更新advancedapi.min.js包，修复文件和getImageInfo接口使其能正确处理internal协议的路径
- 增加热更新使用说明文档
- Merge pull request #43 from qican777/main
- fix：屏蔽advancedAPi中的ScanCode，支持在模拟器上运行
- Merge pull request #42 from guoenxuan/optimze-web-container-docs
- 增加TaroWebContainer说明文档
- Merge pull request #41 from jiangfeng52/test1
- 默认关闭热更新功能
- Merge pull request #40 from guoenxuan/fix-original-path
- Merge pull request #26 from jiangfeng52/test
- 修复getimageinfo和保存图片到相册失败的问题
- Merge pull request #39 from guoenxuan/fix-compressed-path
- 修复压缩图片/压缩视频/缩率图的返回路径
- Merge pull request #38 from jiangfeng52/jf_dev
- 更新advancedapi.min.js包
- Merge pull request #37 from wangzhenhuiOne/main
- fix: 修改订阅消息代码不合规问题
- Merge pull request #36 from guoenxuan/add-size-origin
- chooseImage拍照后根据sizeType增加原图选择设置
- Merge pull request #35 from xiaoyan428820/main
- Merge pull request #34 from guoenxuan/add-album
- fix: 解决场景化API实例方法抛出异常时导致程序崩溃问题
- 增加相册组件和媒体处理工具并增加chooseMediaAssets接口
- Merge pull request #33 from tangcq-code/main
- feat: 增加压缩视频的接口；
- Merge pull request #32 from tangcq-code/main
- fix: 删除多余注释
- fix: 删除多余注释
- feat: 增加chooseImage的ets实现；
- Merge pull request #31 from guoenxuan/fix-full-screen
- 增加胶囊按钮状态切换natvie接口
- Merge pull request #30 from jiangfeng52/permission
- Merge pull request #27 from guoenxuan/add-save-data-url-file
- 增加授权接口，统一日志打印语句
- 增加授权接口
- 增加saveDataUrlToFile接口
- 完善热更新流程
- Merge pull request #24 from guoenxuan/fix-navigation-text
- 修复标题文本过长导致换行的问题
- Merge pull request #23 from tangcq-code/main
- fix: 加入scope.bluetoothBackground
- Merge pull request #22 from wangzhenhuiOne/main
- fix: 修改订阅消息部分不必要的暴露
- Merge pull request #21 from licunhao1/main
- fix: 修复访问外部资源异常
- Merge pull request #20 from guoenxuan/fix-fail-off-listener
- fix: 修复无法关闭匿名监听函数的问题
- Merge pull request #19 from guoenxuan/release-web-container
- 补充web-container模块发布所需的文档
- Merge pull request #18 from jiangfeng52/jf_dev
- 更新advanced-api包，修复request请求参数丢失问题
- Merge pull request #16 from wangzhenhuiOne/main
- Merge pull request #17 from xiaoyan428820/main
- feat: 注入的JS代码中新增系统导航栏高度全局变量
- feat: 新增消息通知模块
- Merge pull request #13 from jiangfeng52/f-liuyang
- jsBridge通信优化思路图
- 修复API返回值对象属性缺失的问题
- feat: 新增原生方法copyFileToSandboxCache，支持将file://开头文件复制到应用沙盒cache路径下并返回沙盒路径
- Merge pull request #15 from guoenxuan/update-manager
- 修复API返回值对象属性缺失的问题
- Merge pull request #14 from xiaoyan428820/main
- feat: 新增原生方法copyFileToSandboxCache，支持将file://开头文件复制到应用沙盒cache路径下并返回沙盒路径
- 热更新缓存的文件生效
- Merge pull request #12 from guoenxuan/fix-developer-config
- 优化开发者页面配置
- Update README.md
- 补充热更新的整体结构
- 补充热更新的整体结构
- Merge pull request #10 from guoenxuan/fix-refresh-url
- 修复应用从后台切入前台时web页面没停留在切入后台前的页面的问题
- Merge pull request #9 from guoenxuan/fix-status-color
- 修复setNavigationBarColor调用时状态栏前景色未变化的问题
- Merge pull request #8 from guoenxuan/to-do-list
- 增加问题列表以及导航栏设计问题描述
- Merge pull request #7 from jiangfeng52/test16
- Merge pull request #6 from tangcq-code/main
- API update
- fix: 同步codehub中权限的更新
- Merge pull request #5 from jiangfeng52/optimize-module-and-log
- 优化日志信息打印
- 滑动屏幕返回优先Web容器返回
- TaroWebContainer与NavigationBar解藕
- 修复胶囊在非全屏下的问题
- Merge pull request #4 from jiangfeng52/refactor-prj-gex
- 重构代码目录
- 重构壳工程框架
- Merge pull request #3 from tangcq-code/main
- fix: 同步codehub的代码
- Merge pull request #2 from guoenxuan/fix-remote-files
- fix: 删除自动生成的中间产物文件
- Merge pull request #1 from tangcq-code/main
- fix: 提交壳工程框架代码
- Initial commit

## 2.0.0-rc.0
优化JSBridge通道

## 1.0.1
修复部分API的bug以及添加IDE/SDK/Taro版本限制

## 1.0.0
提供定制化Web容器来运行Taro生成的harmony-hybrid类型的Web应用