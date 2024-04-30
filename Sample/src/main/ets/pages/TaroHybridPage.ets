import { HostPageState, TaroHybrid, TaroHybridManager } from '@hybrid/web-container/Index';
import router from '@ohos.router';
import { SafeArea } from '../components/SafeArea';

export interface TaroHybridRouterParams {
  indexHtmlPath: string,
  taroPath: string
}
export const RouterToTaroHybrid = (params: TaroHybridRouterParams) => {
  TaroHybridManager.loadUrl(params.indexHtmlPath, params.taroPath);

  setTimeout(()=>{
    router.pushUrl({
      url: 'pages/TaroHybridPage',
      params: params
    }, router.RouterMode.Standard)
  }, 200)
}



@Entry
@Component
struct TaroHybridPage {
  @State pageState: HostPageState = HostPageState.PageInit;
  private indexHtmlPath: string = (router.getParams() as TaroHybridRouterParams).indexHtmlPath
  private taroPath: string = (router.getParams() as TaroHybridRouterParams).taroPath

  aboutToAppear(): void {

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
      instance.builderData.taroWebController,
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