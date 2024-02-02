import { RouteNode } from '../common/entity/RouteNode';
import web_webview from '@ohos.web.webview'
import { ApiAdapter } from '../../inject_adapter/ApiAdapter';
import { WebNode } from '../webmanager/WebNode';

export class RouterStorage {
  private static instance: RouterStorage;
  private routeNodes: Array<RouteNode> = [];
  private controller: web_webview.WebviewController | undefined = undefined;
  private adapter: ApiAdapter | undefined = undefined;
  private webNode: WebNode | null = null;

  public static getInstance(): RouterStorage {
    if (!RouterStorage.instance) {
      RouterStorage.instance = new RouterStorage();
    }
    return RouterStorage.instance;
  }

  setController(controller: web_webview.WebviewController): void {
    this.controller = controller;
  }

  getController(): web_webview.WebviewController | undefined{
    return this.controller;
  }

  setWebNode(webNode: WebNode): void {
    this.webNode = webNode;
  }

  getWebNode(): WebNode | null{
    return this.webNode;
  }

  setAdapter(adapter: ApiAdapter): void {
    this.adapter = adapter;
  }

  getAdapter(): ApiAdapter | undefined{
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