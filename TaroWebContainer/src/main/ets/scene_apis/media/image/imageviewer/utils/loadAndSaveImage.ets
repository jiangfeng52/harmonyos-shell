import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { taroLogger } from '../../../../../utils/Logger';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { common } from '@kit.AbilityKit';
import ResponseCode from '@ohos.net.http';
import fs from '@ohos.file.fs';
import { promptAction } from '@kit.ArkUI';

export function loadAndSaveImage(url: string, context: common.UIAbilityContext) {
  http.createHttp().request(url, {
    method: http.RequestMethod.GET,
    expectDataType: http.HttpDataType.ARRAY_BUFFER
  }, async (error: BusinessError, data: http.HttpResponse) => {
    if (error) {
      taroLogger.error('imageViewer', `http reqeust failed with. Code: ${error.code}, message: ${error.message}`);
    } else {
      if (ResponseCode.ResponseCode.OK === data.responseCode) {
        let imageBuffer: ArrayBuffer = data.result as ArrayBuffer;
        try {
          // 获取相册路径
          let helper = photoAccessHelper.getPhotoAccessHelper(context);
          let uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg')
          let file = await fs.open(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
          // 写入文件
          await fs.write(file.fd, imageBuffer);
          // 关闭文件
          await fs.close(file.fd);
          promptAction.showToast({ message: '已保存至相册' });
        } catch (error) {
          taroLogger.error('imageViewer', `error is ${JSON.stringify(error)}`)
        }
      } else {
        taroLogger.error('imageViewer', `error occurred when image downloaded!`)
      }
    }
  })
}