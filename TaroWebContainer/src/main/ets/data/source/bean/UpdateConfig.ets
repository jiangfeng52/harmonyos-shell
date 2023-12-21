export class UpdateConfig {
  url: string
  initialVersion: string
  compareVersionFunc: (a: string, b: string) => boolean
  hasCompareVersionFunc: boolean

  constructor(url: string = '', initialVersion = '0', hasCompareVersionFunc: boolean = false,
              compareVersionFunc = (a: string, b: string) => {
                return false
              }) {
    this.url = url
    this.initialVersion = initialVersion
    this.compareVersionFunc = compareVersionFunc
    this.hasCompareVersionFunc = hasCompareVersionFunc
  }
}