import { as } from './advancedapi.min';

export class NativeUploadFile{
  static createUploadFile(UploadFileMap: Map<number, ESObject>, instanceId: number): ESObject {
    const uploadFile: ESObject = as.uploadFile();
    UploadFileMap.set(instanceId, uploadFile);
  }
}