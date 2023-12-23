import dataSharePredicates from '@ohos.data.dataSharePredicates';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import { GlobalThis } from './GlobalThis';
import common from '@ohos.app.ability.common';
import { wbLogger } from './Logger';
import {
  ChooseImageOptions,
  ChooseImageResults,
  CompressImageParams,
  CompressImageResults,
  ImageFile
} from '../interfaces/InjectObject';
import { FileUtils } from './FileUtils';
import fs from '@ohos.file.fs'
import image from '@ohos.multimedia.image'
import bundleManager from '@ohos.bundle.bundleManager';

const MEDIA_UTIL = 'MediaUtil';

export enum PHOTO_TYPE {
  IMAGE,
  VIDEO,
  IMAGE_VIDEO,
}

export async function getPhotoAssetList(): Promise<Array<photoAccessHelper.PhotoAsset>> {
  let context = GlobalThis.getInstance().getContext('context') as common.UIAbilityContext;
  let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
  let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
  let fetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [],
    predicates: predicates
  };
  try {
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> = await phAccessHelper.getAssets(fetchOptions);
    if (fetchResult !== undefined) {
      let photoAsset: Array<photoAccessHelper.PhotoAsset> = await fetchResult.getAllObjects();
      if (photoAsset !== undefined) {
        wbLogger.info(MEDIA_UTIL, 'photoAsset.length :' + photoAsset.length);
      }
      return photoAsset;
    }
  } catch (err) {
    wbLogger.error(MEDIA_UTIL, `getPhotoAssetList failed. Cause: ${JSON.stringify(err)}`);
    return [];
  }
  return [];
}

export function getPhotoVideoUris(assetArr: Array<photoAccessHelper.PhotoAsset>, type: PHOTO_TYPE) {
  let uris: string[] = [];
  let index: number = 0;
  for (let i = 0; i < assetArr.length; i++) {
    // photoType为1表示IMAGE，为2表示VIDEO
    if (assetArr[i].photoType.valueOf() === 2 && type === PHOTO_TYPE.IMAGE) {
      continue;
    }
    if (assetArr[i].photoType.valueOf() === 1 && type === PHOTO_TYPE.VIDEO) {
      continue;
    }
    uris[index++] = assetArr[i].uri;
  }
  return uris;
}

export async function getCameraUris(): Promise<string[]> {
  let uris: string[] = [];
  const context = GlobalThis.getInstance().getContext('context') as common.UIAbilityContext;
  // 单独指定使用相机
  const info = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT)
  const data = await context.startAbilityForResult({
    action: 'ohos.want.action.imageCapture',
    parameters: {
      uri: 'capture',
      callBundleName: info.name,
    },
  })
  if (data.resultCode === 0) {
    if (data.want != undefined && data.want.parameters != undefined && data.want.parameters['resourceUri'] != undefined) {
      uris = [data.want.parameters['resourceUri'].toString()];
    }
  } else {
    wbLogger.error(MEDIA_UTIL, `Failed to pull up camera app.`);
  }
  return uris;
}

export async function compressImage(params: CompressImageParams): Promise<CompressImageResults> {
  let options: CompressImageResults = {};
  const src = params.src;
  let quality = params.quality || 80;
  if (quality && typeof (quality) !== 'number') {
    return options;
  }
  if (quality > 100 || quality < 0) {
    quality = 80;
  }
  try {
    let fd = 0;
    if (FileUtils.isSandboxPath(src)) {
      if (!fs.accessSync(src)) {
        wbLogger.error(MEDIA_UTIL, `compressImage fail, src can not access.`);
        return options;
      }
      const file = fs.openSync(src, fs.OpenMode.READ_ONLY);
      if (!file) {
        wbLogger.error(MEDIA_UTIL, `compressImage fail, src can not open.`)
        return options;
      }
      fd = file.fd;
    } else if (FileUtils.isFileUri(src)) {
      fd = FileUtils.getFdFromUriOrSandBoxPath(src);
    }
    // 压缩
    // const imageSourceApi: image.ImageSource = image.createImageSource(fd);
    // const imagePackerApi: image.ImagePacker = image.createImagePacker();
    // let packOpts: image.PackingOption = { format: 'image/jpeg', quality };
    // const arrayBuf = await imagePackerApi.packing(imageSourceApi, packOpts);

    // const color: ArrayBuffer = new ArrayBuffer(96);
    // let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: 4, width: 6 } }
    // let pixeMap: image.PixelMap = await image.createPixelMap(color, opts);
    // const imagePackerApi: image.ImagePacker = image.createImagePacker();
    // let packOpts: image.PackingOption = { format: 'image/jpeg', quality };
    // const arrayBuf = await imagePackerApi.packing(pixeMap, packOpts);
    const arrayBuf = await getArrayBuffer(20, fd, params.compressHeight, params.compressedWidth);

    const context = GlobalThis.getInstance().getContext('context');
    if (context === undefined) {
      return options;
    }
    const currentTime = new Date().getTime();
    const jpgName = 'IMAGE_' + currentTime;
    const tmpPath = context.tempDir + '/' + currentTime + '/' + jpgName + '.jpg'
    let size = 0;
    try {
      await fs.mkdir(context.tempDir + '/' + currentTime)
      fs.openSync(tmpPath, fs.OpenMode.CREATE)
      const fileOpen = fs.openSync(tmpPath, fs.OpenMode.READ_WRITE)
      fs.writeSync(fileOpen.fd, arrayBuf)
      // 获取临时文件的大小
      const stat = FileUtils.getFileStatFromUri(tmpPath);
      fs.closeSync(fileOpen);
      return { tempFilePath: tmpPath, tempFileSize: stat.size, tempFileName: jpgName };
    } catch (error) {
      wbLogger.error(MEDIA_UTIL, `compressImage----file deal error:`, error)
    }
  } catch (error) {
    wbLogger.error(MEDIA_UTIL, `compressImage----pack error:`, error)
  }
  return options;
}

async function getArrayBuffer(quality: number, fd: number, height?: number, width?: number) {
  if (height !== undefined || width !== undefined) {
    let heightSize: number = height || width || 0;
    let widthSize: number = width || height || 0;
    const color: ArrayBuffer = new ArrayBuffer(heightSize * widthSize * 4);
    let opts: image.InitializationOptions = {
      editable: true,
      pixelFormat: 3,
      size: { height: heightSize, width: widthSize }
    }
    let pixeMap: image.PixelMap = await image.createPixelMap(color, opts);
    const imagePackerApi: image.ImagePacker = image.createImagePacker();
    let packOpts: image.PackingOption = { format: 'image/jpeg', quality };
    const arrayBuf = await imagePackerApi.packing(pixeMap, packOpts);
    return arrayBuf;
  } else {
    const imageSourceApi: image.ImageSource = image.createImageSource(fd);
    const imagePackerApi: image.ImagePacker = image.createImagePacker();
    let packOpts: image.PackingOption = { format: 'image/jpeg', quality };
    const arrayBuf = await imagePackerApi.packing(imageSourceApi, packOpts);
    return arrayBuf;
  }
}

export async function getChooseImageRet(uris: string[], params: ChooseImageOptions): Promise<ChooseImageResults> {
  const tempFilePaths: string[] = []
  const tempFiles: ImageFile[] = []
  for (let i = 0; i < uris.length; i++) {
    if (uris[i] === undefined) {
      continue;
    }
    let compress: CompressImageResults = {}
    if (params.sizeType && params.sizeType.length === 1 && params.sizeType.includes('compressed')) {
      compress = await compressImage({ src: uris[i] })
      if (compress === undefined || compress.tempFilePath === undefined || compress.tempFileSize === undefined || compress.tempFileName === undefined) {
        continue;
      }
      tempFilePaths.push(compress.tempFilePath)
      tempFiles.push({
        path: compress.tempFilePath,
        size: compress.tempFileSize,
        name: compress.tempFileName,
        type: compress.tempFilePath.split('.')[1],
      })
    } else {
      const stat = FileUtils.getFileStatFromUri(uris[i])
      const length = uris[i].split('/').length - 1
      const imageNameType = uris[i].split('/')[length]
      tempFilePaths.push(uris[i])
      tempFiles.push({
        path: uris[i],
        size: stat.size,
        name: imageNameType.split('.')[0],
        type: imageNameType.split('.')[1],
      })
    }
  }
  return { tempFilePaths, tempFiles }
}




