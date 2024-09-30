export interface NetworkMiniInfo {
  /**
   * 业务名称：例如Sample的rawfile下的spa下有一个main@100000目录，这里的main就是业务名称
   */
  businessName: string

  /**
   * 版本号
   */
  version: number

  /**
   * 资源下载地址
   */
  downloadUrl : string
}