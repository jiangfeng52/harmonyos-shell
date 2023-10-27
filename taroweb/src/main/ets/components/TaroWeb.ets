import webView from '@ohos.web.webview'
import uri from '@ohos.uri'
import common from '@ohos.app.ability.common'
import { Adapter } from '../adapter/adapter'
import { switchInternalToHapSandBox } from '../adapter/util'
import { NativeObj, MenuButtonOptions, ErrorMsg, PermissionInfo } from '../adapter/interface'
import Prompt from '@system.prompt'
import { NavigationBar } from './NavigationBar'
import { BusinessError } from '@ohos.base'
import File from '@ohos.file.fs';
import { as } from '@ohos/advanced-api'
import Want from '@ohos.app.ability.Want'
import {
  getBundleUsedPermission,
  getBundleWxScopeList,
  openPermissionsInSystemSettings
} from '../utils/PermissionMapScopeUtil'
import { RawUtils } from '../utils/RawUtils'

@Component
export struct TaroWeb {
  @Prop entryDomain: string;
  @Prop useBuildIn: boolean;
  @Prop launchOptions: string;
  // @Prop systemBarHeight: number;
  @Prop windowWidth: number;
  @Prop permissionInfos: Array<PermissionInfo>;

  @State textInput: string = '';
  @State textInputVisible: boolean = false;
  @State webResult: string = ''
  @State onClickId: string = 'onClickId'
  @State navigationBarTitle: string = '';
  @State navTitleHeight: number = 32;
  @State canBackward: boolean = false;
  @State navBarColor: string = '#FFFFFF';
  @State navBarFrontColor: string = '#000000';
  @State navAnimationDuration: number = 0;
  @State navAnimationCurve: number = Curve.Linear;
  @State navLoading: boolean = false;
  @State navVisible: boolean = true;
  // private webUrlSuffix: string = ':10086/#/pages/index/index';
  fileAccess: boolean = true;
  controller: webView.WebviewController = new webView.WebviewController();
  textInputController: TextInputController = new TextInputController();
  ua: string = 'mozilla/5.0 (linux; android 10; harmonyos; els-an00; hmscore 6.10.4.302) applewebkit/537.36 (khtml, like gecko) chrome/99.0.4844.88 huaweibrowser/13.0.6.302 mobile safari/537.36'
  bundleMap: Map<string, string> = new Map();
  isRegister: boolean = false;
  paddingBottom: number = 8;
  nativeObj: NativeObj = {
    setNavigationBarColor: (options) => {
      console.info(`[ADSAPI] setNavigationBarColor`)
      this.navBarColor = options.backgroundColor ?? this.navBarColor;
      this.navBarFrontColor = options.frontColor ?? this.navBarFrontColor;
      if (options.animation) {
        this.navAnimationDuration = options.animation.duration ?? 0;
        const timingFuncMap = new Map([
          ['linear', Curve.Linear],
          ['easeIn', Curve.EaseIn],
          ['easeOut', Curve.EaseOut],
          ['easeInOut', Curve.EaseInOut],
        ])
        if (options.timingFunc && timingFuncMap.has(options.timingFunc)) {
          this.navAnimationCurve = Number(timingFuncMap.get(options.timingFunc) ?? Curve.Linear);
        }
      }
    },
    showNavigationBarLoading: () => {
      this.navLoading = true;
    },
    hideNavigationBarLoading: () => {
      this.navLoading = false;
    },
    getMenuButtonBoundingClientRect: () => {
      const menuButton: MenuButtonOptions = { width: 0, height: this.navTitleHeight, marginRight: 16 };
      return {
        left: this.windowWidth - menuButton.marginRight - menuButton.width,
        right: this.windowWidth - menuButton.marginRight,
        top: 0,
        bottom: menuButton.height,
        width: menuButton.width,
        height: menuButton.height,
      }
    },
    navigateToMiniProgram: (options) => {
      // options.path 格式:
      // - EntryAbility:///pages/api/framework/index?paramA=good
      // - /pages/api/framework/index?paramA=good
      return new Promise((resolve, reject) => {
        console.log('[ADSAPI] navigateToMiniProgram options:', JSON.stringify(options));
        const entryAbility = 'EntryAbility';
        let abilityName = entryAbility;
        let path = '';
        let query = '';
        if (options.path) {
          const targetUri: string = options.path.startsWith('/') ? `${entryAbility}://${options.path}` : options.path;
          const uriInfo = new uri.URI(targetUri);
          abilityName = uriInfo.scheme;
          path = uriInfo.path;
          query = uriInfo.query;
        }
        const wantInfo: Want = {
          deviceId: '',
          bundleName: options.appId,
          abilityName,
          parameters: {
            extraData: options.extraData || {},
            path,
            query,
          },
        };
        console.log('[ADSAPI] navigateToMiniProgram', JSON.stringify(wantInfo));
        try {
          const context = getContext(this) as common.UIAbilityContext;
          context.startAbility(wantInfo).then(() => {
            resolve({ errMsg: '' });
          }).catch(() => {
            reject({ errMsg: 'invalid appid or path scheme' } as ErrorMsg);
          })
        } catch (paramError) {
          console.log('[ADSAPI] navigateToMiniProgram failed:' + JSON.stringify(paramError));
          reject({
            errMsg: `code: ${(paramError as BusinessError).code}, message ${(paramError as BusinessError).message}`
          } as ErrorMsg
          );
        }
      })
    },
    setNavigationStyle: (style) => {
      this.navVisible = style !== 'custom';
    },
    openSetting: (options) => {
      const apiName: string = 'openSetting';
      // 接口返回
      return new Promise(async (resolve, reject) => {
        try {
          const bundleScope = await getBundleWxScopeList(this.permissionInfos);
          const bundleUsedScope = getBundleUsedPermission(bundleScope.allScope, bundleScope.bundleScope);
          // 打开应用的权限列表
          openPermissionsInSystemSettings();
          return resolve({ authSetting: bundleUsedScope.allScope, errMsg: `${apiName}:ok` });
        } catch (paramError) {
          return reject(
            {
              errMsg: `${apiName}:fail error code: ${(paramError as BusinessError).code} ${(paramError as BusinessError).message}`
            } as ErrorMsg
          );
        }
      })
    },
    getSetting: (options) => {
      const apiName: string = 'getSetting';
      // 接口返回
      return new Promise(async (resolve, reject) => {
        try {
          const bundleScope = await getBundleWxScopeList(this.permissionInfos);
          const bundleUsedScope = getBundleUsedPermission(bundleScope.allScope, bundleScope.bundleScope);
          return resolve({ authSetting: bundleUsedScope.allScope, errMsg: `${apiName}:ok` });
        } catch (paramError) {
          return reject(
            {
              errMsg: `${apiName}:fail error code: ${(paramError as BusinessError).code} ${(paramError as BusinessError).message}`
            } as ErrorMsg
          );
        }
      })
    }
  };
  adapter: Adapter = new Adapter(this.controller, this.nativeObj);
  adapterProxy: Object = this.adapter.getAdapterProxy(as);

  entryUrl(): string{
    return `${this.entryDomain}index.html`
  }

  // 生命周期方法，返回
  onBackPress() {
    try {
      if (this.controller.accessBackward()) { // 当前页面是否可以后退，即当前页面是否有返回历史记录
        this.controller.backward(); // 按照历史栈，后退一个页面。
        return true
      }
    } catch (error) {
      console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
    }
    return false
  }

  aboutToAppear() {
    this.adapter.setLaunchOptions(this.launchOptions);
    this.adapter.setNavigationBarHeight(this.navTitleHeight + this.paddingBottom);
    webView.WebviewController.setWebDebuggingAccess(true);
  }

  // onPageShow() {
  //   try {
  //     if (this.controller.getUrl() !== this.url) {
  //       console.info("[ADSAPI] onPageShow load url: " + this.url);
  //       this.controller.loadUrl(this.url);
  //     }
  //   } catch (e) {
  //     console.info("[ADSAPI] load url fail");
  //   }
  // }

  // onPageHide() {
  //   this.url = this.controller.getUrl();
  // }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      Web({ src: this.entryUrl(), controller: this.controller })
        .fileAccess(this.fileAccess)// 设置是否开启应用中文件系统的访问，默认启用。rawfile路径的文件不受该属性影响而限制访问
        .domStorageAccess(true)// 设置是否开启文档对象模型存储接口权限，默认未开启。
        .mixedMode(MixedMode.All)// 设置是否允许加载HTTP和HTTPS混合内容，默认不允许。
        .databaseAccess(true)// 设置是否开启数据库存储的API权限，默认不开启。
        .geolocationAccess(true)// 设置是否开启获取地理位置权限，默认开启。
        .userAgent(this.ua)// 设置用户代理
        .javaScriptAccess(true)// 设置是否允许执行JavaScript脚本，默认允许执行。
        .javaScriptProxy({ // 注入JavaScript对象到window对象，并在window对象中调用该对象的方法。
          object: this.adapterProxy,
          name: "as",
          methodList: this.adapter.getMethodList(),
          controller: this.controller
        })
        .onConsole((event) => {
          console.log('[ADSAPI] [WEB]' + event?.message.getMessage())
          return false // 通知宿主应用js console消息，返回true时，将消息打印至控制台。
        })
        .zoomAccess(false)// 设置是否支持手势进行缩放，默认允许执行缩放。
        .horizontalScrollBarAccess(false)// 设置是否显示横向滚动条，默认显示。
        .onPageBegin(e => {
          try {
            this.controller.runJavaScript(
              this.adapter.getRunJavaScript(),
              (error, result) => {
                if (error) {
                  console.info(`[ADSAPI] run JavaScript error: ` + JSON.stringify(error))
                  return;
                }
                if (result) {
                  this.webResult = result
                  console.info(`[ADSAPI] The asFinish() return value is: ${result}`)
                }
              });
          } catch (error) {
            console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
          }
        })
        .onInterceptRequest((event) => { // 当web组件加载url之前触发该回调，用于拦截url并返回响应数据。
          const url = event?.request.getRequestUrl()
          if (url && url.startsWith('internal:')) {
            const responseWeb = new WebResourceResponse();
            const path: string = switchInternalToHapSandBox(url);
            if (File.accessSync(path)) {
              const file: File.File = File.openSync(path, File.OpenMode.READ_ONLY);
              const fd: number = file.fd;
              responseWeb.setResponseData(fd);
              responseWeb.setResponseCode(200);
              responseWeb.setReasonMessage('OK');
              responseWeb.setResponseIsReady(true)
              console.info(`[ADSAPI] responseWeb`)
            }
            else {
              console.info(`[ADSAPI] This file is not exist`)
            }
            return responseWeb
          }
          else if( this.useBuildIn && url && url.startsWith(this.entryDomain)) {
            const path: string|undefined = url?.replace(this.entryDomain,'');
            if (!path || !RawUtils.rawfileExist(path)) {
              return null;
            }

            return RawUtils.getRawfileOnResponseWeb(path)
          }
          return null
        })
        .onSslErrorEventReceive((event) => { // 通知用户加载资源时发生SSL错误
          console.info(`[ADSAPI] onSslErrorEventReceive:${event.error}`)
          event.handler.handleConfirm() // 通知Web组件继续使用SSL证书
          return true
        })
        .onTitleReceive((event) => {
          if (event) {
            this.navigationBarTitle = event.title;
          }
          this.canBackward = this.controller.accessBackward();
        })

        NavigationBar({
          navVisible: this.navVisible,
          title: this.navigationBarTitle,
          canBackward: this.canBackward,
          navLoading: this.navLoading,
        }).id(this.onClickId)
    }.layoutWeight(1)
  }
}