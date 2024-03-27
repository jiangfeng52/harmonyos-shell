import versionCompare from '../bean/CompareVersion'
import { LocalVersionInfo } from './LocalVersionInfo'
import HashMap from '@ohos.util.HashMap'
export class UpdateConfig {
  private static instance: UpdateConfig
  private urlFunc = (version: string) => {
    return ''
  }
  private initialVersion: string = '0'
  private compareVersionFunc: (a: string, b: string) => boolean = versionCompare
  private minisInfo:HashMap<string,LocalVersionInfo> = new HashMap<string,LocalVersionInfo>()
  private constructor() {
  }

  public static getInstance(): UpdateConfig {
    if (!UpdateConfig.instance) {
      UpdateConfig.instance = new UpdateConfig();
    }
    return UpdateConfig.instance;
  }

  getInitialVersion(): string {
    return this.initialVersion
  }

  getUrl(version: string): string {
    return this.urlFunc(version)
  }

  getCompareVersionFunc(): (a: string, b: string) => boolean {
    return this.compareVersionFunc
  }

  setup(initialVersion: string, getUrlFunc: (version: string) => string, compareVersionFunc = versionCompare): void {
    this.urlFunc = getUrlFunc
    this.initialVersion = initialVersion
    this.compareVersionFunc = compareVersionFunc
  }

  setOrReplaceMiniInfo(name:string,versionInfo:LocalVersionInfo){
    if (name&&versionInfo) {
      if (this.minisInfo.hasKey(name)) {
        this.minisInfo.replace(name, versionInfo);
      }else{
        this.minisInfo.set(name,versionInfo)
      }
    }
  }

  getMiniInfo(name:string): LocalVersionInfo | null{
    return this.minisInfo.get(name)
  }

}