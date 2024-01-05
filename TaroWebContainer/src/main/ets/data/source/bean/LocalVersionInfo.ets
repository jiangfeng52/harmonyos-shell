export class LocalVersionInfo {
  localVersion: string
  path: string

  constructor(localVersion: string = '', path: string = '') {
    this.localVersion = localVersion
    this.path = path
  }
}