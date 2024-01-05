export class MiniConfig {
  hasUpdate: boolean
  miniVersion: number
  miniDownloadUrl: string

  constructor(hasUpdate: boolean = false, miniVersion: number = -1, miniDownloadUrl: string = '') {
    this.hasUpdate = hasUpdate;
    this.miniVersion = miniVersion
    this.miniDownloadUrl = miniDownloadUrl;
  }
}