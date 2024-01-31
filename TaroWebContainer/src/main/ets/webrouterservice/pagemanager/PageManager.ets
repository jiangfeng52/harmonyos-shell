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

  removeUrl(url: string) {
    if (this.urlList.has(url)) {
      this.urlList.remove(url);
    }
  }

  gerCurrentUrl(): string {
    let CurrentUrl = ''
    this.urlList.forEach((value: string, index?: number) => {
      wbLogger.info(TAG, `getWebInstanceIds`);
      CurrentUrl = value;
    });
    return CurrentUrl;
  }
}