import { ArrayList } from '@kit.ArkTS';
import { wbLogger } from '../../utils/Logger';

const TAG: string = 'zhou PageManager'

export class PageManager {
  private static instance: PageManager;
  urlList: ArrayList<string> = new ArrayList();

  public static getInstance(): PageManager {
    if (!PageManager.instance) {
      PageManager.instance = new PageManager();
    }
    return PageManager.instance;
  }

  addUrl(url: string) {
    this.urlList.add(url);
  }

  removeCurrentUrl() {
    let len = this.urlList.length;
    this.urlList.removeByIndex(len - 1);
  }

  getUrlListSize(): number {
    return this.urlList.length;
  }

  getCurrentUrl(): string {
    let CurrentUrl = '';
    this.urlList.forEach((value: string, index?: number) => {
      wbLogger.info(TAG, `gerCurrentUrl() value=` + value);
      CurrentUrl = value;
    });
    return CurrentUrl;
  }

  getCurrentUrl2(): string {
    let len = this.urlList.length;
    let CurrentUrl2 = '';
    if (len > 1) {
      CurrentUrl2 = this.urlList[len - 2];
    }
    return CurrentUrl2;
  }
}