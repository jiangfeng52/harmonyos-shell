import { RouteNode } from '../common/entity/RouteNode';
import { webview } from '@kit.ArkWeb'
import web_webview from '@ohos.web.webview'
import { ApiAdapter } from '../../inject_adapter/ApiAdapter';

export class RouterStorage {
  private static instance: RouterStorage;
  private routeNodes: Array<RouteNode> = [];
  private controller: web_webview.WebviewController = new web_webview.WebviewController();
  private adapter: ApiAdapter = new ApiAdapter();

  public static getInstance(): RouterStorage {
    if (!RouterStorage.instance) {
      RouterStorage.instance = new RouterStorage();
    }
    return RouterStorage.instance;
  }

  setController(controller: web_webview.WebviewController): void {
    this.controller = controller;
  }

  getController(): web_webview.WebviewController {
    return this.controller;
  }

  setAdapter(adapter: ApiAdapter): void {
    this.adapter = adapter;
  }

  getAdapter(): ApiAdapter {
    return this.adapter;
  }

  getCurrentNodeUrl(): string {
    const length: number = RouterStorage.instance.routeNodes.length;
    if (length === 0) {
      return '';
    }
    return this.routeNodes[length - 1].url;
  }
}