import zlib from '@ohos.zlib'
import { BusinessError } from '@ohos.base'
import { wbLogger } from '../../../utils/Logger'
import fs from '@ohos.file.fs'

export class MiniLocalFileDataSource {


  constructor() {
  }

  getLastMiniVersion(context: Context): number {
    let miniPath = `${context.filesDir}/mini`

    if(!fs.accessSync(miniPath)) {
      return -1
    }

    return -1
  }

  getLocalPath(context: Context, version: number): string {
    let miniPath = `${context.filesDir}/mini`

    if(!fs.accessSync(miniPath) || !fs.statSync(miniPath).isDirectory()) {
      fs.mkdirSync(miniPath)
    }

    let versionPath = `${miniPath}/${version.toString()}`
    if(!fs.accessSync(versionPath) || !fs.statSync(versionPath).isDirectory()) {
      fs.mkdirSync(versionPath)
    }

    return versionPath
  }

  saveAndUnzip(context: Context, version: number, filePath: string): Promise<string>{
    return new Promise<string>((resolve: Function, reject: Function)=>{
      try {
        let options: zlib.Options = {
          level: zlib.CompressLevel.COMPRESS_LEVEL_DEFAULT_COMPRESSION,
          memLevel: zlib.MemLevel.MEM_LEVEL_DEFAULT,
          strategy: zlib.CompressStrategy.COMPRESS_STRATEGY_DEFAULT_STRATEGY
        }

        let savePath = this.getLocalPath(context, version)

        zlib.decompressFile(filePath, savePath, options, (errData) => {
          if (errData !== null) {
            wbLogger.debug("UpdateManager", '%{public}s decompressFile failed. code is %{public}d, message is %{public}s', filePath, errData.code, errData.message)
          } else {
            wbLogger.debug("UpdateManager", '%{public}s decompressFile success. decompressPath is %{public}s', filePath, savePath)
          }
          resolve(errData == null ? savePath : '')
        })
      } catch (errData) {
        let code = (errData as BusinessError).code;
        let message = (errData as BusinessError).message;
        wbLogger.debug("UpdateManager", '%{public}s decompressFile failed. code is %{public}d, message is %{public}s', filePath, code, message)
        resolve('')
      }
    })
  }
}