/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import common from '@ohos.app.ability.common';
import bundleManager from '@ohos.bundle.bundleManager';
import { NavigationBar, NavigationBarData } from './NavigationBar';
import { TaroWeb, TaroWebController } from './TaroWeb';
import { Album } from './Album/Album';
import { ApiAdapter } from '../inject_adapter/ApiAdapter';
import { NativeInject } from '../inject_adapter/NativeInject';
import { LaunchOptions } from '../interfaces/LaunchOptions';
import { CapsuleController, InjectObject, MenuButtonOptions } from '../interfaces/InjectObject';
import { getSystemBarHeight, getWindowWidth, setFullScreen, setSystemBarProperties } from '../utils/WindowUtil';
import { GlobalThis } from '../utils/GlobalThis';
import { getBundleInfoPermissions } from '../utils/PermissionMapScopeUtil';
import { HostPageState } from '../interfaces/HostPageState';
import { RouterUtils } from '../utils/RouterUtils';
import { taroLogger } from '../utils/Logger';
import { AlbumBackward, chooseAlbumOptions, ChooseAlbumResult, MediaItemData } from '../interfaces/Media';
import { BusinessError } from '@ohos.base';
import { Channel, MethodChannel } from '../inject_adapter/Channel';
import { GetWindowInfoCache } from '../inject_adapter/nativecache/GetWindowInfoCache';
import { GetDeviceInfoCache } from '../inject_adapter/nativecache/GetDeviceInfoCache';
import { GetSystemSettingCache } from '../inject_adapter/nativecache/GetSystemSettingCache';
import { imageViewerManager, ImageViewerOptions } from '../scene_apis/media/image/imageviewer/utils/ImageViewerManager';
import { ImageViewer } from '../scene_apis/media/image/imageviewer/view/ImageViewer';
import { TaroHybridManager } from '../tarohybrid/TaroHybridManager';
import { ConfigurationConstant, EnvironmentCallback } from '@kit.AbilityKit';

const CONTAINER_TAG = 'TaroWebContainer';

/**
 * TaroWebContainer组件，包含定制的Web组件和自定义导航栏
 */
@Component
export struct TaroWebContainer {
  @State colorMode : ConfigurationConstant.ColorMode | undefined = ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
  // 初始化资源url
  @Prop indexHtmlPath: string;
  @Prop webUrl: string;
  // 资源url的前缀
  @Prop webUrlPrefix: string;
  // 使用缓存
  @Prop @Watch('onUseCacheStateChanged') useCache: boolean = true;
  // 是否强制反色适配深色模式
  @Prop forceDarkAccess: boolean;
  // 导航栏初始化visible值
  @Prop navigationInitVisible: boolean = false;
  // 显示胶囊
  @Prop showCapsule: boolean = true;
  // 胶囊按钮点击后跳转的页面
  @Prop capsulePage: string = 'pages/Capsule';
  // 同步宿主页面的状态
  @Prop @Watch('onPageStateUpdated') pageState: HostPageState;
  // 监听UIAbility的Want
  @Prop @Watch('onWantUpdated') want: Want = {};
  // 导航栏状态控制器
  @State navigationBarData: NavigationBarData = new NavigationBarData();
  // 系统状态状态栏高度
  @State systemBarHeight: number = 0;
  @State channel: Channel = new Channel()
  @State methodChannel: MethodChannel = new MethodChannel(this.channel)
  @Prop isRoot: boolean = true
  getLoadCommittedDetails: Function = (value: LoadCommittedDetails): void => {}

  // 显示图库
  @State showAlbum: boolean = false;
  // 退出图库返回选择的媒体数据
  private mediaResolve?: (res: ChooseAlbumResult) => void;
  // 退出图库取消选择
  private mediaReject?: () => void;
  // 是否处在图库的详情页面
  @State isAlbumOnDetail: boolean = false;
  // 图库初始配置
  albumOptions?: chooseAlbumOptions;
  // 图库媒体数据数据列表
  mediaItems: MediaItemData[] = [];
  @State previewOneImage: boolean = false;

  // 路由控制器
  @Link taroWebController: TaroWebController;

  // 自定义用户代理
  @Prop userAgent: string | undefined = undefined;

  @State environmentCallbackId: number | undefined = undefined

  hookInterceptorWithoutCache?: (request: WebResourceRequest) => WebResourceResponse | null;

  // 用户自定义的注入对象
  injectObj: InjectObject | undefined;
  // 是否全屏显示应用
  isFullScreen: boolean = true;
  // 高阶API适配器
  private adapter: ApiAdapter | undefined;

  // 启动参数
  private launchOptions: string = '';
  // aboutToAppear阶段是否已经完成
  private appearDone: boolean = false
  // 备份初始indexUrl
  private originIndexUrl: string = '';
  // 开启Web组件调试功能
  enableWebDebug: boolean = true;

  capsuleOptions: MenuButtonOptions = { width: 50, height: this.navigationBarData.titleHeight, marginRight: 16 };

  onTitleReceive = (title: string)=>{
    this.navigationBarData.title = title
    if (this.isRoot) {
      this.navigationBarData.canBackward = this.taroWebController.accessBackward();
    } else {
      // 多容器时，当不是第1个容器，即使Web不能返回，也应该显示返回按钮
      this.navigationBarData.canBackward = true
    }
  }
  onRefreshAccessedHistory = ()=>{
    this.navigationBarData.loading = false;
  }

  onNavigationBarBackPressed?: (taroWebController: TaroWebController)=>void

  defaultNavigationBarBackPressed = ()=>{
    if(this.onNavigationBarBackPressed) {
      this.onNavigationBarBackPressed(this.taroWebController)
      return ;
    }
    if(this.taroWebController.accessBackward()) {
      taroLogger.debug(CONTAINER_TAG, 'backWord:webViewController')
      this.taroWebController.backward();
    }
  }

  capsuleController: CapsuleController = {
    changeCapsuleState: (visible: boolean) => {
      this.showCapsule = visible;
    },
    getCapsuleState: () => {
      return this.showCapsule;
    }
  }

  setSystemBarFrontColor = (color: string) => {
    const context = getContext(this) as common.UIAbilityContext;
    window.getLastWindow(context).then((windowClass) => {
      setSystemBarProperties(windowClass, color);
    });
  }

  onUseCacheStateChanged(propName: string): void {
    if(this.taroWebController.webController){
      this.taroWebController.webController.loadUrl(this.webUrl)
    }
  }


  chooseAlbumCallback = (options: chooseAlbumOptions, mediaItems: MediaItemData[], previewOneMode?: boolean) => {
    const mediaPromise = new Promise<ChooseAlbumResult>((resolve, reject) => {
      this.mediaResolve = resolve;
      this.mediaReject = reject;
    })
    this.albumOptions = options;
    this.mediaItems = mediaItems;
    this.previewOneImage = previewOneMode === undefined ? false : previewOneMode;
    this.isAlbumOnDetail = false
    this.showAlbum = true;
    this.setSystemBarFrontColor('#ffffff');
    return mediaPromise;
  }

  onExitAlbumHandler = (success: boolean, res: ChooseAlbumResult) => {
    if (success) {
      this.mediaResolve?.(res)
    } else {
      this.mediaReject?.()
    }
    this.setSystemBarFrontColor(this.navigationBarData.barFrontColor);
    this.showAlbum = false;
  }

  albumBackward: AlbumBackward = {
    accessBackward: () => {
      return this.showAlbum;
    },
    backward: () => {
      if (this.isAlbumOnDetail) {
        this.isAlbumOnDetail = false;
        return;
      } else {
        this.setSystemBarFrontColor(this.navigationBarData.barFrontColor);
        this.showAlbum = false;
        this.mediaReject?.()
      }
    },
  }

  // 图片预览模态窗触发器
  imageViewerTrigger = (options: ImageViewerOptions) => {
    let dialogController: CustomDialogController | null = null;
    dialogController = new CustomDialogController({
      builder: ImageViewer({
        options: options,
      }),
      cancel: () => {
        dialogController = null; // 清理dialogController
      },
      customStyle: true, // 自适应弹出容器样式
    })

    if (dialogController !== null) {
      dialogController.open()
    }
  }

  environmentCallback: EnvironmentCallback  =  {
    onConfigurationUpdated: (config) => {
      this.colorMode = config.colorMode
    },

    onMemoryLevel(level){
    }
  };

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      TaroWeb({
        indexHtmlPath: this.indexHtmlPath,
        webUrl: this.webUrl,
        webUrlPrefix: this.webUrlPrefix,
        hookInterceptorWithoutCache: this.hookInterceptorWithoutCache,
        useCache: this.useCache,
        apiAdapter: this.adapter,
        taroWebController: this.taroWebController,
        onTitleReceive: this.onTitleReceive,
        onRefreshAccessedHistory: this.onRefreshAccessedHistory,
        enableWebDebug: this.enableWebDebug,
        channel: this.channel,
        methodChannel: this.methodChannel,
        forceDarkAccess: this.forceDarkAccess,
        userAgent: this.userAgent,
        getLoadCommittedDetails:(value:LoadCommittedDetails)=>{this.getLoadCommittedDetails(value)}
      })
      NavigationBar({
        navigationBarData: this.navigationBarData,
        onBackPressed: this.defaultNavigationBarBackPressed,
        colorMode: this.colorMode
      })
      if(this.showCapsule) {
        Image($r("app.media.capsule"))
          .margin({
            top: (this.isFullScreen ? this.systemBarHeight : 0) + this.capsuleOptions.height - 25,
            right: this.capsuleOptions.marginRight
          })
          .fillColor(this.navigationBarData.barFrontColor)
          .width(this.capsuleOptions.width)
          .height(25)
          .borderRadius(10)
          .borderColor('#40cccccc')
          .borderWidth(1)
          .backgroundColor(this.navigationBarData.barFrontColor === '#ffffff' ? '#30000000' : '#9affffff')
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            RouterUtils.pushUrlWithLog(this.capsulePage)
          })
      }
      if (this.showAlbum) {
        Album({
          mediaItemList: this.mediaItems,
          onExitAlbumHandler: this.onExitAlbumHandler,
          showDetail: this.isAlbumOnDetail,
          options: this.albumOptions,
          avoidAreaHeight: this.systemBarHeight,
          previewOneMode: this.previewOneImage,
        })
          .width('100%')
          .height('100%')
      }
    }.layoutWeight(1)
  }

  aboutToAppear() {
    this.colorMode = GlobalThis.getInstance().getContext('context')?.resourceManager.getConfigurationSync().colorMode.valueOf()
    this.environmentCallbackId = GlobalThis.getInstance().getContext('context')?.getApplicationContext().on('environment', this.environmentCallback)
    // 加载组件时，url更新
    this.originIndexUrl = this.webUrl;
    this.navigationBarData.visible = this.navigationInitVisible
    this.handleWantInfo();
    let context = GlobalThis.getInstance().getContext('context') as common.UIAbilityContext;
    if (!context) {
      throw new Error('Env not init yet! Please call TaroHybridManager.init first')
    }
    // 创建高阶API适配器，合并注入的对象
    this.adapter = new ApiAdapter();
    const nativeInject = new NativeInject(this.navigationBarData, this.capsuleOptions, this.capsuleController,this.taroWebController.getNativeCacheManager());
    this.taroWebController.setAlbumBackward(this.albumBackward);
    nativeInject.setChooseAlbumCallback(this.chooseAlbumCallback);
    imageViewerManager.setImageViewerTrigger(this.imageViewerTrigger);

    this.channel.setRunJavascriptFun((jsCode: string)=>{
      try {
        this.taroWebController.webController.runJavaScript(jsCode, (error, result) => {
          if (error) {
            taroLogger.error(CONTAINER_TAG, `Run JavaScript error: ${JSON.stringify(error)}`)
            return;
          }
        });
      } catch (error) {
        taroLogger.error(CONTAINER_TAG, `runJavaScript error: ${(error as BusinessError).message}`);
      }
    })

    this.methodChannel.registerMethods('NativeApi', nativeInject.buildInjectObj(context))

    if (!!this.injectObj){
      this.methodChannel.registerMethods('NativeApi', this.injectObj)
    }

    const nativeMethod = TaroHybridManager.getOptions()?.injectNativeMethod?.(this.indexHtmlPath, context)
    if (nativeMethod) {
      this.methodChannel.registerMethods('NativeApi', nativeMethod)
    }

    getBundleInfoPermissions().then((permissions: bundleManager.ReqPermissionDetail[]) => {
      nativeInject.setPermissionInfo(permissions);
    })

    window.getLastWindow(context).then((windowClass) => {
      setSystemBarProperties(windowClass);
      this.isFullScreen && setFullScreen(windowClass);
      this.systemBarHeight = this.isFullScreen ? getSystemBarHeight(windowClass) : 0;
      this.navigationBarData.systemBarHeight = this.systemBarHeight;
      nativeInject.setSystemBarHeight(this.systemBarHeight);
      nativeInject.setWindowWidth(getWindowWidth(windowClass));
      this.adapter!.setLaunchOptions(this.launchOptions);
      this.adapter!.setNavigationBarHeight(this.systemBarHeight + this.navigationBarData.titleHeight + this.navigationBarData.paddingBottom);
      this.adapter!.setSystemBarHeight(this.systemBarHeight);
    })
    this.appearDone = true;

    this.taroWebController.getNativeCacheManager().initCacheData(context)
    this.taroWebController.getNativeCacheManager().register(new GetWindowInfoCache(), new GetDeviceInfoCache(), new GetSystemSettingCache())

  }

  aboutToDisappear(): void {
    this.environmentCallbackId && GlobalThis.getInstance().getContext('context')?.getApplicationContext().off('environment', this.environmentCallbackId)
    this.taroWebController.getNativeCacheManager().dispose()
  }

  onPageStateUpdated(): void {
  }

  onWantUpdated() {
    taroLogger.debug(CONTAINER_TAG, `onWantUpdated want`);
    this.handleWantInfo();
  }

  handleWantInfo() {
    taroLogger.info(CONTAINER_TAG, `want: ${JSON.stringify(this.want)}`);
    this.structLaunchOptions();
    this.redirectNewUrl();
  }

  structLaunchOptions() {
    if (!this.want || Object.keys(this.want).length === 0 || this.appearDone) {
      return;
    }
    const params = this.want.parameters;
    const appId = params?.['ohos.aafwk.param.callerBundleName'] || '';
    this.launchOptions = JSON.stringify({
      path: params?.path || '',
      query: (!params?.query || params.query === 'null') ? '' : params.query,
      appId,
      extraData: params?.extraData || {},
    } as LaunchOptions);
  }

  redirectNewUrl() {
    if (!this.want || Object.keys(this.want).length === 0) {
      return;
    }
    // want 中附带有新的目标url的信息
    const params = this.want.parameters;
    const pagePath = params?.path ? `${params.path}${params?.query ? '?' + params.query : ''}` : '';
    if (pagePath) {
      this.webUrl = `${this.originIndexUrl}#${pagePath}`;
      taroLogger.info(CONTAINER_TAG, `webUrl: ${this.webUrl}`);
      if (this.appearDone) {
        try {
          this.taroWebController.loadUrl(this.webUrl);
        } catch(e) {
          taroLogger.error(CONTAINER_TAG, `failed loadUrl: ${this.webUrl}`);
        }
      }
    }
  }
}
