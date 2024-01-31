import { wbLogger } from '../../utils/Logger'
import { BuilderData } from '../common/entity/BuilderData'
import { BusinessError } from '@kit.BasicServicesKit'
import { GlobalRouter } from '../globalrouter/GlobalRouter'

const TAG: string = 'zhou WebBuilder'

@Builder
export function WebBuilder(builderData: BuilderData) {
  Column() {
    Web({ src: builderData.url, controller: builderData.controller })
      .fileAccess(true)
      .domStorageAccess(true)
      .mixedMode(MixedMode.All)
      .databaseAccess(true)
      .geolocationAccess(true)
      .javaScriptAccess(true)
      .javaScriptProxy({
        object: builderData.apiAdapter.getAdapterProxy(),
        name: 'as',
        methodList: builderData.apiAdapter.getMethodList() || [],
        controller: builderData.controller,
      })
      .onConsole((event) => {
        wbLogger.info(TAG, `${event?.message.getMessage()}`)
        return false
      })
      .zoomAccess(false)
      .horizontalScrollBarAccess(false)
      .onPageBegin(() => {
        try {
          builderData.controller.onActive();
          builderData.controller.runJavaScript(
            builderData.apiAdapter.getRunJavaScript(),
            (error, result) => {
              if (error) {
                wbLogger.error(TAG, `Run JavaScript error: ${JSON.stringify(error)}`)
                return;
              }
              if (result) {
                wbLogger.info(TAG, `The asFinish() return value is: ${result}`)
              }
            });
        } catch (error) {
          wbLogger.error(TAG, `runJavaScript error: ${(error as BusinessError).message}`);
        }
      })
      .onInterceptRequest((event) => { // 当web组件加载url之前触发该回调，用于拦截url并返回响应数据。
        wbLogger.info(TAG, `onInterceptRequest`)
        const request = event?.request;
        if (!request) {
          return null;
        }
        // return builderData.controller.interceptRequest(request);
        return null;
      })
      .onSslErrorEventReceive((event) => { // 通知用户加载资源时发生SSL错误
        wbLogger.info(TAG, `onSslErrorEventReceive:${event.error}`)
        event.handler.handleConfirm() // 通知Web组件继续使用SSL证书
        return true
      })
      .onLoadIntercept((event) => {
        wbLogger.info(TAG, `onLoadIntercept`)
        if (event) {
          return GlobalRouter.getInstance().router(event.data)
        }
        return false;
      })
      .onControllerAttached(() => {
        wbLogger.info(TAG, `onControllerAttached`)
        builderData.controller.runJavaScript(
          builderData.apiAdapter.getRunJavaScript(),
          (error, result) => {
            if (error) {
              return;
            }
            if (result) {
              wbLogger.info(TAG, `onControllerAttached The asFinish() return value is: ${result}`)
            }
          }
        );
      })
  }
}