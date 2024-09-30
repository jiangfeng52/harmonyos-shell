export interface LocalMiniInfo {
  /**
   * 业务名称：例如Sample的rawfile下的spa下有一个main@100000目录，这里的main就是业务名称
   */
  businessName: string

  /**
   * rawfile里的小程序资源版本信息
   */
  rawVersionInfo: VersionInfo

  /**
   * 磁盘里的小程序资源版本信息
   */
  diskVersionInfo?: VersionInfo
}

export interface VersionInfo {
  /**
   * 版本号
   */
  version: number

  /**
   * 文件路径
   */
  filePath: string
}