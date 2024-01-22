export class LocalVersionInfo {
  localVersion: string
  path: string

  constructor(localVersion: string = '-1', path: string = '') {
    this.localVersion = localVersion
    this.path = path
  }
}