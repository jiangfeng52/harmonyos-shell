import { RouteNode } from '../common/entity/RouteNode';
import { ApiAdapter } from '../../inject_adapter/ApiAdapter';
import { WebNode } from '../webmanager/WebNode';
import { TaroWebController } from '../../components/TaroWeb';

export class RouterStorage {
  private static instance: RouterStorage;
  private routeNodes: Array<RouteNode> = [];
  private systemBarHeight: number = 0;
  private controller: TaroWebController = new TaroWebController();
  private adapter: ApiAdapter= new ApiAdapter();
  private webNode: WebNode | null = null;

  public static getInstance(): RouterStorage {
    if (!RouterStorage.instance) {
      RouterStorage.instance = new RouterStorage();
    }
    return RouterStorage.instance;
  }

  setSystemBarHeight(systemBarHeight: number): void {
    this.systemBarHeight = systemBarHeight;
  }

  getSystemBarHeight():number {
    return this.systemBarHeight;
  }

  setController(controller: TaroWebController): void {
    this.controller = controller;
  }

  getController(): TaroWebController{
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

  getAdapter(): ApiAdapter{
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