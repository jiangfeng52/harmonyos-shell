import { webview } from '@kit.ArkWeb'

@Observed
export class PreCompileConfig {
  public localPath: string
  public options: webview.CacheOptions

  constructor(localPath: string, options: webview.CacheOptions) {
    this.localPath = localPath
    this.options = options
  }
}