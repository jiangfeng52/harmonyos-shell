import { as } from '../../utils/advancedapi.min';

export class NativeUploadFile{
  static async createUploadFile(UploadFileMap: Map<number, ESObject>, instanceId: number, option: ESObject): Promise<ESObject> {
    const uploadFile: ESObject = await as.uploadFile(option);
    UploadFileMap.set(instanceId, uploadFile);
  }
}