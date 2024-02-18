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
import  AdvancedAPI from '../utils/advancedapi.min';
import { NavigationBar, NavigationBarData } from './NavigationBar';
import { TaroWeb, TaroWebController } from './TaroWeb';
import { Album } from './Album/Album';
import { ApiAdapter } from '../inject_adapter/ApiAdapter'
import { NativeInject  } from '../inject_adapter/NativeInject';
import { LaunchOptions } from '../interfaces/LaunchOptions';
import { InjectObject, MenuButtonOptions, CapsuleController } from '../interfaces/InjectObject';
import { setFullScreen, setSystemBarProperties, getWindowWidth, getSystemBarHeight } from '../utils/WindowUtil';
import { GlobalThis } from '../utils/GlobalThis';
import { getBundleInfoPermissions } from '../utils/PermissionMapScopeUtil';
import { HostPageState } from '../interfaces/HostPageState';
import { RouterUtils } from '../utils/RouterUtils';
import router from '@ohos.router';
import { wbLogger } from '../utils/Logger';
import { AlbumBackward, ChooseAlbumResult, MediaItemData, chooseAlbumOptions } from '../interfaces/Media'
import { ChannelInstance, MethodChannelInstance } from '../inject_adapter/Channel';
import { BusinessError } from '@ohos.base';

const CONTAINER_TAG = 'TaroWebContainer';

/**
 * TaroWebContainer组件，包含定制的Web组件和自定义导航栏
 */
@Component
export struct TaroWebContainer {
  // 初始化资源url
  @Prop webUrl: string;
  // 资源url的前缀
  @Prop webUrlPrefix: string;
  // 使用缓存
  @Prop useCache: boolean = true;
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
    this.navigationBarData.canBackward = this.taroWebController.accessBackward();
  }
  onRefreshAccessedHistory = ()=>{
    this.navigationBarData.loading = false;
  }

  onNavigationBarBackPressed = ()=>{
    if (Number(router.getLength()) > 1) {
      router.back();
      return;
    }

    if(this.taroWebController.accessBackward()) {
      wbLogger.debug(CONTAINER_TAG, 'backWord:webViewController')
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
    accessBackward: () => { return this.showAlbum; },
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

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      TaroWeb({
        webUrl: this.webUrl,
        webUrlPrefix: this.webUrlPrefix,
        useCache: this.useCache,
        apiAdapter: this.adapter,
        taroWebController: this.taroWebController,
        onTitleReceive: this.onTitleReceive,
        onRefreshAccessedHistory: this.onRefreshAccessedHistory,
        enableWebDebug: this.enableWebDebug,
      })
      NavigationBar({
        navigationBarData: this.navigationBarData,
        onBackPressed: this.onNavigationBarBackPressed
      })
      if(this.showCapsule) {
        Image($r("app.media.capsule"))
          .margin({ top: (this.isFullScreen ? this.systemBarHeight : 0) + this.capsuleOptions.height - 25, right: this.capsuleOptions.marginRight })
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
    // 加载组件时，url更新
    this.originIndexUrl = this.webUrl;
    this.handleWantInfo();
    const context = getContext(this) as common.UIAbilityContext;
    // 使用UIAbility的context初始化对象
    AdvancedAPI.init(context);
    GlobalThis.getInstance().setContext('context', context);

    // 创建高阶API适配器，合并注入的对象
    this.adapter = new ApiAdapter();
    this.adapter.setWebController(this.taroWebController.webController)
    const nativeInject = new NativeInject(this.navigationBarData, this.capsuleOptions, this.capsuleController);
    this.taroWebController.setAlbumBackward(this.albumBackward);
    nativeInject.setChooseAlbumCallback(this.chooseAlbumCallback);
    this.adapter.mergeInjectObj(nativeInject.buildInjectObj(context));
    this.injectObj && this.adapter.mergeInjectObj(this.injectObj);

    MethodChannelInstance.registerMethod('NativeApi$navigateToMiniProgram', (options: ESObject)=>{
      wbLogger.debug('JsBridgeNative', `NativeApi$navigateToMiniProgram`)
      return nativeInject.buildInjectObj(context).navigateToMiniProgram(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$setNavigationBarColor', (options: ESObject)=>{
      wbLogger.debug('JsBridgeNative', `NativeApi$setNavigationBarColor`)
      return nativeInject.buildInjectObj(context).setNavigationBarColor(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$getMenuButtonBoundingClientRect', (options: ESObject)=>{
      wbLogger.debug('JsBridgeNative', `NativeApi$getMenuButtonBoundingClientRect`)
      return nativeInject.buildInjectObj(context).getMenuButtonBoundingClientRect()
    })

    MethodChannelInstance.registerMethod('NativeApi$saveDataUrlToFile', (options: ESObject)=>{
      wbLogger.debug('JsBridgeNative', `NativeApi$getMenuButtonBoundingClientRect`)
      return nativeInject.buildInjectObj(context).saveDataUrlToFile(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$copyFileToSandboxCache', (options: ESObject)=>{
      wbLogger.debug('JsBridgeNative', `NativeApi$copyFileToSandboxCache`)
      return nativeInject.buildInjectObj(context).copyFileToSandboxCache(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$chooseMediaAssets', (options: ESObject)=>{
      wbLogger.debug('JsBridgeNative', `NativeApi$chooseMediaAssets`)
      return nativeInject.buildInjectObj(context).chooseMediaAssets(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$openSetting', (options: ESObject)=>{
      wbLogger.debug('JsBridgeNative', `NativeApi$openSetting`)
      return nativeInject.buildInjectObj(context).openSetting(options)
    })

    MethodChannelInstance.registerMethod('NativeApi$getSetting', (options: ESObject)=>{
      wbLogger.debug('JsBridgeNative', `NativeApi$getSetting`)
      return nativeInject.buildInjectObj(context).getSetting(options)
    })


    ChannelInstance.setRunJavascriptFun((jsCode: string)=>{
      try {
        this.taroWebController.webController.runJavaScript(jsCode, (error, result) => {
          if (error) {
            wbLogger.error(CONTAINER_TAG, `Run JavaScript error: ${JSON.stringify(error)}`)
            return;
          }
        });
      } catch (error) {
        wbLogger.error(CONTAINER_TAG, `runJavaScript error: ${(error as BusinessError).message}`);
      }
    })

    // 注入对象的内部依赖更新
    // nativeInject.setNaviController(this.navigationBarData);
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
  }

  onPageStateUpdated(): void {
  }

  onWantUpdated() {
    wbLogger.debug(CONTAINER_TAG, `onWantUpdated want`);
    this.handleWantInfo();
  }

  handleWantInfo() {
    wbLogger.info(CONTAINER_TAG, `want: ${JSON.stringify(this.want)}`);
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
      wbLogger.info(CONTAINER_TAG, `webUrl: ${this.webUrl}`);
      if (this.appearDone) {
        try {
          this.taroWebController.loadUrl(this.webUrl);
        } catch(e) {
          wbLogger.error(CONTAINER_TAG, `failed loadUrl: ${this.webUrl}`);
        }
      }
    }
  }
}
