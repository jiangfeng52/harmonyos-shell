import versionCompare from '../bean/CompareVersion'

export class UpdateConfig {
  private static instance: UpdateConfig
  private urlFunc = (version: string) => {
    return ''
  }
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
}