import versionCompare from '../bean/CompareVersion'
export class UpdateConfig {
  private static instance : UpdateConfig
  private url: string = ''
  private initialVersion: string = '0'
  private compareVersionFunc: (a: string, b: string) => boolean = versionCompare



  private constructor() {
  }
  public static getInstance(): UpdateConfig {
    if (!UpdateConfig.instance) {
      UpdateConfig.instance = new UpdateConfig();
    }
    return UpdateConfig.instance;
  }
  getLocalVersion(): string{
    return this.initialVersion
  }
  getUrl(): string{
    return this.url
  }
  getCompareVersionFunc(): (a: string, b: string) => boolean{
    return this.compareVersionFunc
  }
  setUpdateConfig(getUrlFunc: (version: string)=>string, initialVersion: string, compareVersionFunc = versionCompare): void {
      this.url = getUrlFunc(initialVersion)
      this.initialVersion = initialVersion
      this.compareVersionFunc = compareVersionFunc
  }
}