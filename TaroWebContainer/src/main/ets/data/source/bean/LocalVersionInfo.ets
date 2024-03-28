export class LocalVersionInfo {
  localVersion: string
  diskCachePath: string
  biz: string
  rawCachePath : string

  constructor(localVersion: string = '-1',biz : string='',diskCachePath: string = '',rawCachePath : string='') {
    this.localVersion = localVersion
    this.diskCachePath = diskCachePath
    this.biz = biz
    this.rawCachePath = rawCachePath
  }
}