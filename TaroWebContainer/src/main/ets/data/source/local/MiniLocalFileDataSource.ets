import zlib from '@ohos.zlib'
import { BusinessError } from '@ohos.base'
import { wbLogger } from '../../../utils/Logger'
import fs from '@ohos.file.fs'
import { LocalVersionInfo } from '../bean/LocalVersionInfo'
import { UpdateConfig } from '../bean/UpdateConfig'
import versionCompare from '../bean/CompareVersion'

export class MiniLocalFileDataSource {


  constructor() {
  }

  getLastMiniVersion(context: Context, updateConfig: UpdateConfig): LocalVersionInfo {
    let miniPath = `${context.filesDir}/update`
    let localVersionInfo = new LocalVersionInfo()
    if (!fs.accessSync(miniPath) || !fs.statSync(miniPath).isDirectory()) {
      return localVersionInfo
    }
    let filenames = fs.listFileSync(miniPath, { recursion: false, listNum: 0 })
    if (filenames.length > 0) {
      filenames.sort((a, b) => {
        let compareResult = false
        if (updateConfig.hasCompareVersionFunc){
          console.debug("getLastMiniVersion", "external algorithm sorting")
          compareResult = updateConfig.compareVersionFunc(a, b)
        }else{
          compareResult = versionCompare(a, b)
        }
        if (compareResult) {
          //正序排列
          return 1
        }
        return -1
      })
      if (filenames.length === 3){
        //保证在下载前只有两个版本
        MiniLocalFileDataSource.delTempFile(`${miniPath}/${filenames[0]}`)
      }
      localVersionInfo.localVersion = filenames[filenames.length-1]
      localVersionInfo.path = `${miniPath}/${filenames[filenames.length-1]}`
      return localVersionInfo
    }
    return localVersionInfo
  }

  static delTempFile(tempPath: string) {
    if (!fs.accessSync(tempPath)) {
      return
    }
    fs.unlinkSync(tempPath)
  }

  getLocalPath(context: Context, version: number): string {
    let miniPath = `${context.filesDir}/update`

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
          MiniLocalFileDataSource.delTempFile(filePath)
          resolve(errData == null ? savePath : '')
        })
      } catch (errData) {
        let code = (errData as BusinessError).code;
        let message = (errData as BusinessError).message;
        wbLogger.debug("UpdateManager", '%{public}s decompressFile failed. code is %{public}d, message is %{public}s', filePath, code, message)
        MiniLocalFileDataSource.delTempFile(filePath)
        resolve('')
      }
    })
  }
}