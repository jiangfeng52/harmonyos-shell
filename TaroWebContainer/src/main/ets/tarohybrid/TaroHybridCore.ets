import common from '@ohos.app.ability.common';
import { TaroWebController } from '../components/TaroWeb';
import { TaroWebContainer } from '../components/TaroWebContainer';
import { InjectObject } from '../interfaces/InjectObject';
import { GlobalThis } from '../utils/GlobalThis';
import { TaroHybridManager } from './TaroHybridManager';
import { TaroHybridUtils } from './TaroHybridUtils';
import { taroLogger } from '../utils/Logger';
import { FileUtils } from '../utils/FileUtils';
import { http } from '@kit.NetworkKit';
import { DebugTaroWebContainer } from './DebugTaroWebContainer';
import { taroStorage } from '../inject_adapter/TaroStorage';

export interface TaroHybridCoreBuilderData {
  domain: string
  indexHtmlPath: string
  taroPath: string
  taroWebController: TaroWebController
  forceDarkAccess: boolean
}

@Builder
export function TaroHybridCoreBuilder(builderData: TaroHybridCoreBuilderData) {
  TaroHybridCore({
    domain: builderData.domain,
    indexHtmlPath: builderData.indexHtmlPath,
    taroPath: builderData.taroPath,
    forceDarkAccess: builderData.forceDarkAccess
  })
}
const HTTP_TIMEOUT = 3000;

@Component
struct TaroHybridCore {
  @Prop indexHtmlPath: string;
  @Prop taroPath: string;
  @Prop domain: string;
  // 是否强制反色适配深色模式
  @Prop forceDarkAccess: boolean;
  @State taroWebController: TaroWebController = TaroHybridManager.getCoreInstance(this.indexHtmlPath)?.builderData.taroWebController ?? new TaroWebController()
  @State isDebug: boolean = (GlobalThis.getInstance().getContext('context') as common.UIAbilityContext).applicationInfo.debug
  private useCache: boolean = true
  @State devDomain: string = '';
  @State devUseCache: boolean = false;
  private isRoot: boolean = TaroHybridManager.isRootContainer(this.indexHtmlPath)

  private navigationBarBackPressed: (taroWebController: TaroWebController)=>void = (taroWebController: TaroWebController)=>{
    const hasHandled = TaroHybridManager.onBack(this.indexHtmlPath, this.taroPath)
    if(!hasHandled) {
      TaroHybridManager.nativeBack()
    }
  }

  aboutToAppear(): void {
    if(this.isDebug) {
      this.devDomain = TaroHybridUtils.getSP(`${this.indexHtmlPath}_devdomain`, '') as string
      this.devUseCache = TaroHybridUtils.getSP(`${this.indexHtmlPath}_useCache`, this.useCache) as boolean
    }
    taroStorage.pageToAppear(this.indexHtmlPath)
  }

  aboutToDisappear(): void {
    taroStorage.pageToDisappear(this.indexHtmlPath)
  }

  webUrl(){
    let webUrl = `${this.domain}${this.indexHtmlPath}#${this.taroPath}`
    return TaroHybridUtils.addQueryParamToHash(webUrl, 'tarofrom', 'native')
  }

  private hookInterceptorWithoutCache = (request: WebResourceRequest) =>  {

    if(!this.isDebug){
      return null
    }

    const url = request.getRequestUrl();
    taroLogger.debug("CrossOrigin","拦截器收到的request: %{public}s", url);

    if ( url.search(this.domain) != -1 ) {
      let actualRequestUrl = url.replace(this.domain,this.devDomain)
      //去掉Fragment部分
      actualRequestUrl = actualRequestUrl.split('#')[0]

      let responseWeb = new WebResourceResponse();
      responseWeb.setResponseHeader(request.getRequestHeader())
      responseWeb.setResponseIsReady(false)
      FileUtils.getFileResponseFromUrl(actualRequestUrl,HTTP_TIMEOUT,http.HttpDataType.ARRAY_BUFFER).then(ret => {
        taroLogger.debug("CrossOrigin", 'download result : %{public}s ,code:%{public}s', actualRequestUrl,`${ret.responseCode}`)
        responseWeb.setResponseCode(ret.responseCode);
        responseWeb.setReasonMessage(ret.result === http.ResponseCode.OK ? 'OK' : 'http.get resource failed');
        if (ret.result instanceof ArrayBuffer) {
          responseWeb.setResponseData(ret.result);
        }
        responseWeb.setResponseEncoding('utf-8')
        responseWeb.setResponseMimeType(FileUtils.getMimetype(actualRequestUrl))
        responseWeb.setResponseIsReady(true)
        return responseWeb
      }).catch((err: Error) => {
        taroLogger.debug("CrossOrigin", 'download error: %{public}s , err is %{public}s', actualRequestUrl, err.message)
        responseWeb.setResponseCode(0);
        responseWeb.setReasonMessage(err.message);
        responseWeb.setResponseIsReady(true)
        return responseWeb
      });

      return responseWeb
    }

    return null;
  }

  @Builder
  taroWebLayout(){
    TaroWebContainer({
      indexHtmlPath: this.indexHtmlPath,
      webUrl: this.webUrl(),
      webUrlPrefix: `${this.domain}/`,
      // want: this.want, // want信息
      taroWebController: this.taroWebController,
      useCache: this.isDebug ? this.devUseCache : this.useCache,
      isFullScreen: false, // 是否全屏显示
      showCapsule: false,
      onNavigationBarBackPressed: this.navigationBarBackPressed,
      hookInterceptorWithoutCache:this.hookInterceptorWithoutCache,
      isRoot: this.isRoot,
      forceDarkAccess: this.forceDarkAccess
    })
      .width('100%')
      .height('100%')
  }

  @Builder
  debugFrameLayout(){
      DebugTaroWebContainer({
        devDomain: this.devDomain,
        indexHtmlPath: this.indexHtmlPath,
        taroPath: this.taroPath,
        useCache: this.devUseCache,
        taroWebBuilderParam: ():void=>{this.taroWebLayout()},
        refresh: (domain: string, indexHtmlPath: string, taroPath: string, useCache: boolean)=>{
          this.devUseCache = useCache
          this.devDomain = domain
          setTimeout(() => {
            this.taroWebController.webController.refresh()
          }, 50)
        }
      })
  }

  build() {
    Column(){
      if (this.isDebug) {
        this.debugFrameLayout()
      } else {
        this.taroWebLayout()
      }
    }
  }
}