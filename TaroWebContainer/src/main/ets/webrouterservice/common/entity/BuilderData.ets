import { TaroWebController } from '../../../components/TaroWeb';
import { ApiAdapter } from '../../../inject_adapter/ApiAdapter';

export class BuilderData {
  webUrl: string;
  taroWebController: TaroWebController;
  webId: number;
  apiAdapter: ApiAdapter;

  constructor(webUrl: string, taroWebController: TaroWebController, webId: number,  apiAdapter: ApiAdapter) {
    this.webUrl = webUrl;
    this.taroWebController = taroWebController;
    this. webId = webId;
    this.apiAdapter = apiAdapter;
  }
}