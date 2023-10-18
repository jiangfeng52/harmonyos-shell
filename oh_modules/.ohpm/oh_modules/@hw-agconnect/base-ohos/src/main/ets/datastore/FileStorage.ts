//@ts-ignore
import fileio from '@ohos.fileio';
import { Logger } from '../log/logger';
import { File } from "../util/FileUtils";
import { ICrypto } from '../crypto/ICrypto';

export class FileStorage {
  static async write(context: any, path: string, fileName: string, content: string, crypto?: ICrypto): Promise<void> {
    if (content == undefined) {
      Logger.info("FileStorage", "write content is undefined");
      return Promise.resolve();
    }
    let filePath = context.filesDir + "/" + path;
    if (!await FileStorage.isExistFile(filePath)) {
      await fileio.mkdir(filePath);
      Logger.info("FileStorage", "create dir success");
    }
    let file = filePath + "/" + fileName;
    let stream = fileio.createStreamSync(file, 'w+');

    if (crypto) {
      content = await crypto.encrypt(content);
    }

    let contentLength = content.length;
    let writeNumber = stream.writeSync(content);
    if (contentLength == writeNumber) {
      Logger.info("FileStorage", "stream.writeSync success");
    }
    stream.closeSync();
    return Promise.resolve();
  }

  /**
   * 读取文件
   * 
   * @param context 
   * @param path 
   * @param fileName 
   * @returns null:文件不存在
   */
  static async read(context: any, path: string, fileName: string, crypto?: ICrypto): Promise<string | null> {
    path = context.filesDir + "/" + path + "/" + fileName;
    if (!await FileStorage.isExistFile(path)) {
      return Promise.resolve(null);
    }
    let result = await fileio.readText(path);
    if (crypto) {
      result = await crypto.decrypt(result);
    }
    return result;
  }

  static async isExistFile(filePath: string): Promise<boolean> {
    return new Promise((resolve, reject) => {
      fileio.access(filePath).then(() => {
        return resolve(true)
      }).catch(() => {
        return resolve(false)
      })
    })
  }

  static async deleteFile(context: any, fileDir:string, fileName:string):Promise<boolean>{
  let path = context.filesDir + "/" + fileDir + "/" + fileName;
    if (!await FileStorage.isExistFile(path)) {
      return Promise.resolve(false);
    }
    await fileio.unlink(path).then(()=>{
      return Promise.resolve(true);
    }).catch(()=>{
      return Promise.resolve(false);
    });
    return Promise.resolve(true);
  }

  // 打印目录下文件信息
  static list(context: any, fileDir:string):File[]{
    let filePath = context.filesDir + "/" + fileDir;
    try {
      fileio.accessSync(filePath);
    } catch(err) {
      fileio.mkdirSync(filePath)
    }
    let dir = fileio.opendirSync(filePath)
    let files:File[] = [];

    let dirent = dir.readSync()
    while (dirent) {
      if(dirent.isFile()){
        let stat = fileio.statSync(filePath+'/'+dirent.name)
        files.push(new File(dirent.name, stat.ctime))
      }
      dirent = dir.readSync()
    }
    return files;
  }
}