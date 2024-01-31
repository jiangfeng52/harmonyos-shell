import { ApiAdapter } from '../../../inject_adapter/ApiAdapter';

export class BuilderData {
  url: string;
  controller: WebviewController;
  webId: number;
  apiAdapter: ApiAdapter;

  constructor(url: string, controller: WebviewController, webId: number,  apiAdapter: ApiAdapter) {
    this.url = url;
    this.controller = controller;
    this. webId = webId;
    this.apiAdapter = apiAdapter;
  }
}