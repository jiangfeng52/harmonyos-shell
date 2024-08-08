import { HostPageState, TaroHybrid, TaroHybridManager } from '@hybrid/web-container/Index';
import router from '@ohos.router';
import { SafeArea } from '../components/SafeArea';
import { logger } from '../utils/Logger';

const TAG = 'TaroHybridPage'

export interface TaroHybridRouterParams {
  indexHtmlPath: string,
  taroPath: string
}
export const RouterToTaroHybrid = (params: TaroHybridRouterParams) => {
  const result = TaroHybridManager.loadUrl(params.indexHtmlPath, params.taroPath);
  if (result) {
    logger.debug(TAG, 'navigateToTaryHybrid wait 300ms')
    // 容器复用成功，等待loadUrl，不然会出现先看到上一个页面
    setTimeout(()=>{
      router.pushUrl({
        url: 'pages/TaroHybridPage',
        params: params
      }, router.RouterMode.Standard)
    }, 300)
  } else {
    logger.debug(TAG, 'navigateToTaryHybrid immediately')
    router.pushUrl({
      url: 'pages/TaroHybridPage',
      params: params
    }, router.RouterMode.Standard)
  }
}



@Entry
@Component
struct TaroHybridPage {
  @State pageState: HostPageState = HostPageState.PageInit;
  private indexHtmlPath: string = (router.getParams() as TaroHybridRouterParams).indexHtmlPath
  private taroPath: string = (router.getParams() as TaroHybridRouterParams).taroPath

  getDetails(value: LoadCommittedDetails) {
    console.log('LoadCommittedDetails:', JSON.stringify(value))
  }

  aboutToAppear(): void {
    TaroHybridManager.setCustomUserAgent('')
    TaroHybridManager.initLoadCommittedDetails(this.indexHtmlPath,(value: LoadCommittedDetails): void => this.getDetails(value))
  }

  onPageShow(): void {
    this.pageState = HostPageState.PageOnShow
  }
  onPageHide(): void {
    this.pageState = HostPageState.PageOnHide
  }
  onBackPress(): boolean | void {
    const instance = TaroHybridManager.getCoreInstance(this.indexHtmlPath)
    if (!instance) {
      return false;
    }
    return TaroHybridManager.onBack(
      instance.builderData.indexHtmlPath,
      instance.builderData.taroPath)
  }

  build() {
    Stack({alignContent: Alignment.TopStart}){
      SafeArea(){
        TaroHybrid({
          indexHtmlPath: this.indexHtmlPath,
          taroPath: this.taroPath,
          pageState: this.pageState
        })
      }
    }
  }
}