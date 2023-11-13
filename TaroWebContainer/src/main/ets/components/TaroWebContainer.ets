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
import { AdvancedAPI } from '@ohos/advanced-api';
import { TaroWeb } from './taroweb';
import { ApiAdapter } from '../inject_adapter/ApiAdapter'
import { NativeInject  } from '../inject_adapter/NativeInject';
import { LaunchOptions } from '../interfaces/LaunchOptions';
import { InjectObject, MenuButtonOptions } from '../interfaces/InjectObject';
import { setFullScreen, setSystemBarProperties, getWindowWidth, getSystemBarHeight } from '../utils/WindowUtil';
import { GlobalThis } from '../utils/GlobalThis';
import { getBundleInfoPermissions } from '../utils/PermissionMapScopeUtil';
import { HostPageState } from '../interfaces/HostPageState';
import { RouterUtils } from '../utils/RouterUtils';
import { TaroWebController } from './TaroWeb';
import { NavigationBarData } from './NavigationBar';
import router from '@ohos.router';
import { wbLogger } from '../utils/Logger';

const CONTAINER_TAG = 'TaroWebContainer';
const DEFAULT_TITLE_LEFT = 40;

// import { TaroWebController } from './TaroWeb';

/**
 * TaroWebContainer组件，包含定制的Web组件和自定义导航栏
 */
@Component
export struct TaroWebContainer {
  // 第一次加载资源时初始化资源url
  @Prop indexUrl: string = 'about:blank';
  // 使用内置资源文件（rawfile目录）
  @Prop useBuildIn: boolean;
  // 初始的远程资源域名
  @Prop entryDomain: string;
  // 显示胶囊
  @Prop showCapsule: boolean = true;
  // 胶囊按钮点击后跳转的页面
  @Prop capsulePage: string = 'pages/Capsule';
  // 同步宿主页面的状态
  @Prop @Watch('onPageStateUpdated') pageState: HostPageState;
  // 监听UIAbility的Want
  @Prop @Watch('onWantUpdated') want: Want;
  // 导航栏状态控制器
  @State @Watch('onNavigationStateUpdated') navigationBarData: NavigationBarData = new NavigationBarData();
  // 记录web当前的url
  @State currentUrl: string = '';
  // 系统状态状态栏高度
  @State systemBarHeight: number = 0;
  // 导航栏高度
  @State navigationBarHeight: number = 0;
  // 导航栏可见性
  @State navigationBarVisible: boolean =  true;

  // 路由控制器
  // @Provide routerController: RouterController = new RouterController();
  @Link taroWebController: TaroWebController;

  // 用户自定义的注入对象
  injectObj: InjectObject | undefined;
  // 是否全屏显示应用
  isFullScreen: boolean = true;

  // 高阶API适配器
  private adapter: ApiAdapter | undefined;
  // 启动参数
  private launchOptions: string = '';

  capsuleOptions: MenuButtonOptions = { width: 50, height: this.navigationBarData.titleHeight, marginRight: 16 };

  onTitleReceive = (title: string)=>{
    this.navigationBarData.title = title
    // this.naviController.title = title;
    // this.naviController.canBackward =
    this.navigationBarData.canBackward = this.taroWebController.accessBackward() // this.routerController.webController.accessBackward();
  }
  onRefreshAccessedHistory = ()=>{
    this.navigationBarData.loading = false;
    // this.naviController.loading = false;
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

  @Builder
  customNavigationBar() {
    Column() {
      Row() {
        if (this.navigationBarData.canBackward) {
          Image($r('app.media.back'))
            .width(25)
            .height(25)
            .margin({ left: 26 })
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              this.taroWebController.backward();
              this.navigationBarData.loading= false;
            })
            .id('backBtn')
        }
        Text(this.navigationBarData.title)
          .fontSize(20)
          .margin({ left: this.navigationBarData.canBackward ? 0 : DEFAULT_TITLE_LEFT })
          .align(Alignment.Start)
        if (this.navigationBarData.loading) {
          LoadingProgress()
            .width(25)
            .height(25)
            .margin({ left: 5 })
            .foregroundColor(this.navigationBarData.barFrontColor)
        }
        Blank()
      }
      .width('100%')
      .height('100%')
      .alignItems(VerticalAlign.Bottom)
      .padding({ bottom: this.navigationBarData.paddingBottom })
    }
    .width('100%')
    .height('100%')
    .foregroundColor(this.navigationBarData.barFrontColor)
    .backgroundColor(this.navigationBarData.barColor)
    .animation({
      duration: this.navigationBarData.animationDuration,
      curve: this.navigationBarData.animationCurve,
      delay: 0,
      iterations: 1,
      playMode: PlayMode.Normal
    })
    .justifyContent(FlexAlign.End)
  }

  build() {
    Navigation() {
      Stack({ alignContent: Alignment.TopEnd }) {
        TaroWeb({
          src: this.currentUrl,
          currentUrl: this.currentUrl,
          apiAdapter: this.adapter,
          useBuildIn: this.useBuildIn,
          entryDomain: this.entryDomain,
          taroWebController: this.taroWebController,
          onTitleReceive: this.onTitleReceive,
          onRefreshAccessedHistory: this.onRefreshAccessedHistory
        })

        if (this.showCapsule) {
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
      }.layoutWeight(1)
    }
    .title({ builder: this.customNavigationBar(), height: this.navigationBarHeight})
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .hideTitleBar(!this.navigationBarVisible)
    .width('100%')
    .height('100%')
    .backgroundColor('white')
  }

  aboutToAppear() {
    // 加载组件时，url更新
    this.currentUrl = this.indexUrl;
    // 处理UIAbility的onCreate保存的want信息
    this.handleWantInfo(this.want);

    const context = getContext(this) as common.UIAbilityContext;
    // 使用UIAbility的context初始化对象
    AdvancedAPI.init(context);
    GlobalThis.getInstance().setContext('context', context);

    // 创建高阶API适配器，合并注入的对象
    this.adapter = new ApiAdapter();
    this.adapter.setWebController(this.taroWebController.webController)
    const nativeInject = new NativeInject(this.navigationBarData, this.capsuleOptions);
    this.adapter.mergeInjectObj(nativeInject.buildInjectObj());
    this.injectObj && this.adapter.mergeInjectObj(this.injectObj);

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
      this.navigationBarHeight = this.systemBarHeight + this.navigationBarData.titleHeight + this.navigationBarData.paddingBottom;
    })
  }

  onNavigationStateUpdated() {
    this.navigationBarVisible = this.navigationBarData.visible;
  }

  onPageStateUpdated(): void {
    // console.info(`[TaroWeb] Page event: ${this.pageState}`);
    // switch (this.pageState) {
    //   case HostPageState.PageOnShow:
    //     // 页面显示时web容器加载上次隐藏时记录的url
    //     console.log(`[TaroWeb] onPageShow currentUrl=${this.currentUrl} webController=${this.routerController.webController.getUrl()}`);
    //     try {
    //       if (this.routerController.webController.getUrl() !== this.currentUrl) {
    //         this.routerController.webController.loadUrl(this.currentUrl);
    //       }
    //     } catch (e) {
    //       console.info("[TaroWeb] load url fail:" + JSON.stringify(e));
    //     }
    //   break;
    //   case HostPageState.PageOnHide:
    //     // 页面隐藏时记录webController的当前url
    //     console.log('[TaroWeb] onPageHide getUrl:'+ this.routerController.webController.getUrl());
    //     this.currentUrl = this.routerController.webController.getUrl();
    //   break;
    //   default:
    //   break;
    // }
  }

  onWantUpdated() {
    // UIAbility的onCreate传递want信息时，组件尚未创建，不会触发该函数
    // 该监听触发不先于页面的onPageShow事件，want中可能带有改变url的信息，所以这里主动调用loadUrl
    this.handleWantInfo(this.want);
    this.taroWebController.loadUrl(this.currentUrl)
    // this.routerController.webController.loadUrl(this.currentUrl);
  }

  handleWantInfo(want: Want) {
    // want 中附带有新的目标url的信息
    wbLogger.info(CONTAINER_TAG, `want: ${JSON.stringify(want)}`);
    const params = want.parameters;
    const pagePath = params?.path ? `${params.path}${params?.query ? '?' + params.query : ''}` : '';
    this.launchOptions = JSON.stringify({
      path: params?.path || '',
      query: params?.query || '',
      appId: params?.['ohos.aafwk.param.callerBundleName'] || '',
      extraData: params?.extraData || {},
    } as LaunchOptions);

    if (pagePath) {
      wbLogger.info(CONTAINER_TAG, `pagePath: ${pagePath}`);
      this.currentUrl = `${this.indexUrl}#${pagePath}`;
    }
  }
}
