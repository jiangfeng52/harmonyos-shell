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

import File from '@ohos.file.fs';
import { BusinessError } from '@ohos.base';
import { ApiAdapter } from '../inject_adapter/ApiAdapter';
import { switchInternalToHapSandBox } from '../utils/InternalPath';
import { MiniLocalFileDataSource } from '../data/source/local/MiniLocalFileDataSource';
import { MiniRawFileDataSource } from '../data/source/local/MiniRawFileDataSource';
import webview from '@ohos.web.webview';
import { taroLogger } from '../utils/Logger';
import { LocalUpdateManagerInstance } from '../update/LocalUpdateManager';
import { AlbumBackward } from '../interfaces/Media'
import webView from '@ohos.web.webview';
import { Channel, MethodChannel } from '../inject_adapter/Channel';
import { sameLayerManager } from '../utils/SameLayerManager';
import { NativeVideoBuilder } from './SameLayer/NativeComponents/Video/Video';
import { NativeMapBuilder } from './SameLayer/NativeComponents/Map/Map';
import { callMapContextFunction, createMapContext } from '../utils/MapManager';
import { NativeCacheManager } from '../inject_adapter/NativeCacheManager';
import { taroTrace, TraceTask } from '../utils/Trace';
import { registerSceneApis } from '../scene_apis/Index';
import { TaroHybridManager } from '../tarohybrid/TaroHybridManager';
import { StorageApi } from '../inject_adapter/native_api/StorageApi';
import { NativeApi } from '../inject_adapter/native_api/NativeApi';

const TARO_WEB_TAG = 'TaroWeb';

export type InterceptRequestHandler = (request: WebResourceRequest) => WebResourceResponse | null;

@Observed
export class TaroWebController {
  public webController: webview.WebviewController;
  public hasBindedTaroWeb: boolean;
  public callbacks: InterceptRequestHandler[];
  public albumBackward?: AlbumBackward;
  public nativeCacheManager: NativeCacheManager

  constructor() {
    this.webController = new webview.WebviewController();
    this.nativeCacheManager = new NativeCacheManager()
    this.hasBindedTaroWeb = false;
    this.callbacks = [];
  }

  getNativeCacheManager(){
    return this.nativeCacheManager
  }

  loadUrl(url: string | Resource, headers?: Array<webview.WebHeader>) {
    if (!this.hasBindedTaroWeb) {
      return;
    }
    try {
      this.webController.loadUrl(url);
      this.webController.accessBackward();
    } catch(err) {
      const error: BusinessError = err as BusinessError;
      taroLogger.error(TARO_WEB_TAG, `fail loadUrl, error code: ${error.code}`);
    }
  }

  setAlbumBackward(albumBackward: AlbumBackward) {
    this.albumBackward = albumBackward;
  }

  accessBackward(): boolean {
    if (this.albumBackward?.accessBackward()) {
      return this.albumBackward.accessBackward()
    }
    if (!this.hasBindedTaroWeb) {
      return false;
    }
    return this.webController.accessBackward();
  }

  backward() {
    if (this.albumBackward && this.albumBackward.accessBackward()) {
      this.albumBackward.backward();
      return;
    }
    if (!this.hasBindedTaroWeb) {
      return;
    }
    this.webController.backward();
  }

  addRequestHandler(callback: InterceptRequestHandler) {
    this.callbacks.push(callback);
  }

  interceptRequest(request: WebResourceRequest): WebResourceResponse | null {
    for (const callback of this.callbacks) {
      const response = callback(request);
      if (response) {
        return response;
      }
    }
    return null;
  }
}

/**
 * TaroWeb，定制化Web组件
 */
@Component
export struct TaroWeb {
  onTitleReceive?: (title: string) => void;
  hookInterceptorWithoutCache?: (request: WebResourceRequest) => WebResourceResponse | null;
  onRefreshAccessedHistory?: () => void;
  @Prop indexHtmlPath: string;
  @Prop webUrl: string;
  @Prop webUrlPrefix: string;
  @Prop useCache: boolean;
  // 是否强制反色适配深色模式
  @Prop forceDarkAccess: boolean;
  @State componentIdArr: Array<string> = []
  @ObjectLink taroWebController: TaroWebController;
  apiAdapter: ApiAdapter = new ApiAdapter();
  scriptProxy: Object | undefined = undefined;
  enableWebDebug: boolean = true;
  @Link channel: Channel
  @Link methodChannel: MethodChannel
  private nativeAPI: NativeApi | undefined = undefined
  @Prop userAgent: string | undefined = undefined
  getLoadCommittedDetails: Function = (value: LoadCommittedDetails): void => {}

  aboutToAppear() {
    webView.WebviewController.setWebDebuggingAccess(this.enableWebDebug);
    this.taroWebController.hasBindedTaroWeb = true
    this.taroWebController.addRequestHandler(this.handleInternalResource);
    this.taroWebController.addRequestHandler(this.useLocalCacheResource);

    this.nativeAPI = new NativeApi(this.indexHtmlPath, this.taroWebController)
    this.methodChannel.registerMethods('NativeApi', this.nativeAPI.nativeObj)
    // 注册场景化API
    registerSceneApis(this.methodChannel)

    if (!sameLayerManager.isAlreadyRegistered('hos-map')) {
      sameLayerManager.registerNativeComponentBuilders('hos-map', NativeMapBuilder);
    }

    if (!sameLayerManager.isAlreadyRegistered('hos-video')) {
      sameLayerManager.registerNativeComponentBuilders('hos-video', NativeVideoBuilder);
    }
    this.nativeAPI?.onWebViewAboutToAppear()
  }

  aboutToDisappear() {
    this.taroWebController.hasBindedTaroWeb = false
    this.nativeAPI?.onWebViewAboutToDisappear()
  }

  handleInternalResource: InterceptRequestHandler = (request) => {
    const url = request.getRequestUrl();
    if (url && url.startsWith('internal:')) {
      const responseWeb = new WebResourceResponse();
      const path: string = switchInternalToHapSandBox(url);
      if (File.accessSync(path)) {
        const file: File.File = File.openSync(path, File.OpenMode.READ_ONLY);
        const fd: number = file.fd;
        responseWeb.setResponseData(fd);
        responseWeb.setResponseCode(200);
        responseWeb.setReasonMessage('OK');
        responseWeb.setResponseIsReady(true);
        taroLogger.info(TARO_WEB_TAG, 'responseWeb for internal resources');
      }
      else {
        taroLogger.info(TARO_WEB_TAG, 'file resource is not exist');
      }
      return responseWeb;
    }
    return null;
  }

  useLocalCacheResource: InterceptRequestHandler = (request) => {
    //如果不使用缓存，则使用
    if(!this.useCache && this.hookInterceptorWithoutCache != null){
      return this.hookInterceptorWithoutCache(request)
    }

    const url = request.getRequestUrl();
    if (url
      && this.useCache
      && this.webUrlPrefix
      && url.startsWith(this.webUrlPrefix)) {
      // 优先使用本地缓存
      // 再使用RawFile缓存
      // 没有则返回空数据，不能让其走网络，因为webUrlPrefix域名为假域名，与微信小程序的机制一样，需要走真实不一样的全路径

      // const path: string | undefined = url?.replace(this.webUrlPrefix, '');
      let path: string = url.replace(this.webUrlPrefix, '');
      path = path.split('#')[0]
      taroLogger.debug('TaroWeb', 'intercepter path=%{public}s', path)
      let biz = MiniRawFileDataSource.getBizByPath(path) //获取业务标识
      const lastVerInfo = LocalUpdateManagerInstance.getLastVersionInfo(biz)
      // 优先走本地缓存，本地缓存不存在，走rawfile
      if (lastVerInfo?.diskCachePath
        && path
        && MiniLocalFileDataSource.fileExist(lastVerInfo?.diskCachePath, path)) {
        taroLogger.debug('TaroWeb', 'useLocalCacheResource path=%{public}s', path)
        return MiniLocalFileDataSource.getFileOnResponseWeb(lastVerInfo?.localVersion, lastVerInfo?.diskCachePath, path)
      }
      // 兜底走rawfile
      if (lastVerInfo?.rawCachePath) { // 走App内置的Raw缓存
        let rawPath = MiniRawFileDataSource.rawfileExist(lastVerInfo.rawCachePath, path)
        if (!path || rawPath.trim() === '') {
          return null;
        }
        taroLogger.debug('TaroWeb', 'useRawCacheResource path=%{public}s', rawPath)
        return MiniRawFileDataSource.getRawfileOnResponseWeb(lastVerInfo?.localVersion, rawPath)
      }

      // 没有则返回空数据，不能让其走网络，因为webUrlPrefix域名为假域名，与微信小程序的机制一样，需要走真实不一样的全路径
      const emptyResponse = new WebResourceResponse();
      emptyResponse.setResponseMimeType("application/octet-stream")
      emptyResponse.setResponseEncoding('utf-8')
      emptyResponse.setResponseData(new Uint8Array());
      emptyResponse.setResponseIsReady(true)
      emptyResponse.setResponseCode(200);
      emptyResponse.setReasonMessage('OK');
      return emptyResponse
    }
    return null;
  }

  build() {
    Stack() {
      ForEach(this.componentIdArr, (componentId: string) => {
        NodeContainer(sameLayerManager.getNodeController(componentId))
      }, (componentId: string) => componentId)
      Web({ src: this.webUrl, controller: this.taroWebController.webController })
        .enableNativeEmbedMode(true)
        .onNavigationEntryCommitted((details) => {
          try {
            this.getLoadCommittedDetails(details)
            if (TaroHybridManager.getDetails(this.indexHtmlPath)) {
              TaroHybridManager.setLoadCommittedDetails(this.indexHtmlPath, details)
            }
          } catch (error) {
            taroLogger.error(TARO_WEB_TAG, `onNavigationEntryCommitted error: ${(error as BusinessError).message}`)
          }
        })
        .onNativeEmbedLifecycleChange((embed) => {
          sameLayerManager.handleNativeEmbedLifecycleChange(embed, () => {
            this.componentIdArr.push(embed.info?.id!)
          }, () => {
            this.componentIdArr.splice(this.componentIdArr.indexOf(embed.info?.id!), 1)
          })
        })
        .onNativeEmbedGestureEvent((touch) => {
          sameLayerManager.handleNativeEmbedGestureEvent(touch, this.componentIdArr)
        })
        .fileAccess(true)
        .domStorageAccess(true)
        .mixedMode(MixedMode.All)
        .databaseAccess(true)
        .geolocationAccess(false)
        .javaScriptAccess(true)
        .javaScriptProxy({
          object: {
            nativeMethod: (channelType: string, objectJson: string) => {
              taroLogger.debug('nativeApi', `channelType ${channelType} objectJson(${objectJson})`)
              taroTrace.startTrace(TraceTask.nativeMethod)
              const obj = this.channel.call(channelType, objectJson) as object
              taroTrace.finishTrace(TraceTask.nativeMethod)
              return obj
            },
            callMapContextFunction: callMapContextFunction,
            createMapContext: createMapContext,
          },
          name: 'JSBridge',
          methodList: ['nativeMethod', 'callMapContextFunction', 'createMapContext'],
          controller: this.taroWebController.webController,
        })
        .onConsole((event) => {
          taroLogger.debug(TARO_WEB_TAG, `${event?.message.getMessage()}`)
          return false
        })
        .zoomAccess(false)
        .horizontalScrollBarAccess(false)
        .onPageBegin(() => {
          try {
            this.taroWebController.webController.runJavaScript(
              this.apiAdapter.getRunJavaScript(),
              (error, result) => {
                if (error) {
                  taroLogger.error(TARO_WEB_TAG, `Run JavaScript error: ${JSON.stringify(error)}`)
                  return;
                }
                if (result) {
                  taroLogger.info(TARO_WEB_TAG, `The asFinish() return value is: ${result}`)
                }
              });
          } catch (error) {
            taroLogger.error(TARO_WEB_TAG, `runJavaScript error: ${(error as BusinessError).message}`);
          }
        })
        .onInterceptRequest((event) => { // 当web组件加载url之前触发该回调，用于拦截url并返回响应数据。
          const request = event?.request;
          if (!request) {
            return null;
          }
          taroTrace.startTrace(TraceTask.onInterceptRequest)
          const response = this.taroWebController.interceptRequest(request);
          taroTrace.finishTrace(TraceTask.onInterceptRequest)
          return response
        })
        .onPageEnd(()=>{
          // 端上预渲染的缓存逻辑，暂未完全调通
          // const url = this.taroWebController.webController.getUrl()
          // taroLogger.debug('liuyang111', `onPageEnd url is ${url}`)
          // this.taroWebController.webController.runJavaScript(
          //   "javascript:document.documentElement.outerHTML;",
          //   (error, result)=>{
          //     try {
          //       let path: string = url.replace(this.webUrlPrefix, '');
          //       path = path.split('#')[0]
          //       let biz = MiniRawFileDataSource.getBizByPath(path) //获取业务标识
          //       const lastVerInfo = LocalUpdateManagerInstance.getLastVersionInfo(biz)
          //       taroLogger.debug('liuyang111', `html path=${path}, biz=${biz}, lastVerInfo=${JSON.stringify(lastVerInfo)}`)
          //       const html = result.substring(1, result.length - 1) // JSON字符串返回的是带引号的字符串，需要去除
          //         // 将转义序列替换为实际字符
          //         .replaceAll("\\u003C", "<")
          //         .replaceAll("\\u003E", ">")
          //         .replaceAll("\\u0026", "&")
          //         .replaceAll("\\u0027", "'")
          //         .replaceAll("\\u0022", "\"")
          //         .replaceAll("\\/", "/")
          //         .replaceAll("\\\"", "\"")
          //         .replaceAll("\\n", "\n")
          //         .replaceAll("\\t", "\t")
          //           // 去除Java中的转义字符
          //         .replaceAll("\\\\", "\\");
          //       MiniLocalFileDataSource.replaceFileContents(lastVerInfo?.diskCachePath, path, html)
          //       taroLogger.debug('liuyang111', `success`)
          //     } catch (err) {
          //       taroLogger.debug('liuyang111', `err ${err}`)
          //     }
          //   })
        })
        // .onSslErrorEventReceive((event) => { // 通知用户加载资源时发生SSL错误
        //   taroLogger.info(TARO_WEB_TAG, `onSslErrorEventReceive:${event.error}`)
        //   event.handler.handleConfirm() // 通知Web组件继续使用SSL证书
        //   return true
        // })
        .onTitleReceive((event) => {
          this.onTitleReceive && this.onTitleReceive(event?.title ?? '')
        })
        .onRefreshAccessedHistory(() => {
          this.onRefreshAccessedHistory && this.onRefreshAccessedHistory();
        })
        .darkMode(WebDarkMode.Auto)
        .forceDarkAccess(this.forceDarkAccess)
        .onControllerAttached(() => {
          try {
            if (this.userAgent) {
              let customUserAgent = this.taroWebController.webController.getUserAgent() + this.userAgent
              this.taroWebController.webController.setCustomUserAgent(customUserAgent)
            } else if (TaroHybridManager.getCustomUserAgent()) {
              let customUserAgent = this.taroWebController.webController.getUserAgent() + TaroHybridManager.getCustomUserAgent()
              this.taroWebController.webController.setCustomUserAgent(customUserAgent)
            }
          } catch (error) {
            taroLogger.error(TARO_WEB_TAG, `setCustomUserAgent error: ${(error as BusinessError).message}`);
          }
        })
      // .webLite(true)  // 需要 osChannel sdk
    }
  }
}