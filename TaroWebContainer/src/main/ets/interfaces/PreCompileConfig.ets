import { webview } from '@kit.ArkWeb'

@Observed
export class PreCompileConfig {
  /**
   * 本地文件的path
   */
  public localPath: string
  /**
   * 缓存配置
   */
  public options: webview.CacheOptions
  /**
   * 是否已预编译了
   */
  public hadPreCompiled: boolean

  constructor(localPath: string, options: webview.CacheOptions, hadPreCompiled: boolean) {
    this.localPath = localPath
    this.options = options
    this.hadPreCompiled = hadPreCompiled
  }
}