import dataSharePredicates from '@ohos.data.dataSharePredicates';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import cameraPicker from '@ohos.multimedia.cameraPicker';
import { GlobalThis } from './GlobalThis';
import common from '@ohos.app.ability.common';
import { wbLogger } from './Logger';
import { FileUtils } from './FileUtils';
import fs from '@ohos.file.fs'
import image from '@ohos.multimedia.image'
import bundleManager from '@ohos.bundle.bundleManager';
import { CompressorResponseCode, CompressQuality, VideoCompressor } from '@ohos/videocompressor';
import { IMediaData, MediaFile, ChooseAlbumResult, ChooseMediaResults, MediaItemData, chooseAlbumOptions } from '../interfaces/Media'
import { requestPermission } from '../utils/PermissionMapScopeUtil';
import { Permissions } from '@ohos.abilityAccessCtrl';
import { ChooseMediaOptions } from '../interfaces/InjectObject';
import { switchHapSandBoxToInternal } from './InternalPath';
import camera from '@ohos.multimedia.camera';
import { BusinessError } from '@ohos.base';

const MEDIA_UTIL = 'MediaUtil';

export enum PHOTO_TYPE {
  IMAGE,
  VIDEO,
  IMAGE_VIDEO,
}

export interface CompressResult {
  tempFilePath?: string;
  tempFileSize?: number;
  tempFileName?: string;
}

export interface CompressImageParams {
  src: string;
  quality?: number;
  compressedWidth?: number;
  compressHeight?: number;
}


export async function getPhotoAssetList(): Promise<Array<photoAccessHelper.PhotoAsset>> {
  let context = GlobalThis.getInstance().getContext('context') as common.UIAbilityContext;
  let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
  let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
  let fetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [
      photoAccessHelper.PhotoKeys.URI,
      photoAccessHelper.PhotoKeys.PHOTO_TYPE,
      photoAccessHelper.PhotoKeys.SIZE,
      photoAccessHelper.PhotoKeys.DURATION,
      photoAccessHelper.PhotoKeys.WIDTH,
      photoAccessHelper.PhotoKeys.HEIGHT,
      photoAccessHelper.PhotoKeys.TITLE,
    ],
    predicates: predicates
  };
  try {
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> = await phAccessHelper.getAssets(fetchOptions);
    if (fetchResult !== undefined) {
      let photoAsset: Array<photoAccessHelper.PhotoAsset> = await fetchResult.getAllObjects();
      if (photoAsset !== undefined) {
        wbLogger.info(MEDIA_UTIL, 'photoAsset.length :' + photoAsset.length);
      }
      return photoAsset.reverse();
    }
  } catch (err) {
    wbLogger.error(MEDIA_UTIL, `getPhotoAssetList failed. Cause: ${JSON.stringify(err)}`);
    return [];
  }
  return [];
}

export async function getAssetByUri(uri: string): Promise<photoAccessHelper.PhotoAsset | undefined> {
  const context = getContext();
  let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
  let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
  predicates.equalTo(photoAccessHelper.PhotoKeys.URI, uri)
  let fetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [
      photoAccessHelper.PhotoKeys.URI,
      photoAccessHelper.PhotoKeys.PHOTO_TYPE,
      photoAccessHelper.PhotoKeys.SIZE,
      photoAccessHelper.PhotoKeys.DURATION,
      photoAccessHelper.PhotoKeys.WIDTH,
      photoAccessHelper.PhotoKeys.HEIGHT,
      photoAccessHelper.PhotoKeys.TITLE,
    ],
    predicates: predicates
  };
  try {
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> = await phAccessHelper.getAssets(fetchOptions);
    if (fetchResult) {
      return await fetchResult.getFirstObject()
    }
  } catch (err) {
    wbLogger.error(MEDIA_UTIL, `getPhotoAssetList failed. Cause: ${JSON.stringify(err)}`);
  }
  return undefined
}

export function filterPhotoVideo(assetArr: photoAccessHelper.PhotoAsset[], type: PHOTO_TYPE): photoAccessHelper.PhotoAsset[] {
  let photoAsset: photoAccessHelper.PhotoAsset[] = [];
  let index: number = 0;
  for (let i = 0; i < assetArr.length; i++) {
    // photoType为1表示IMAGE，为2表示VIDEO
    if (assetArr[i].photoType.valueOf() === 2 && type === PHOTO_TYPE.IMAGE) {
      continue;
    }
    if (assetArr[i].photoType.valueOf() === 1 && type === PHOTO_TYPE.VIDEO) {
      continue;
    }
    photoAsset[index++] = assetArr[i];
  }
  return photoAsset;
}

export async function getCameraUris(captureType: PHOTO_TYPE, maxDuration: number, cameraPos?: string): Promise<string[]> {
  captureType ||= PHOTO_TYPE.IMAGE
  let uris: string[] = [];
  const context = GlobalThis.getInstance().getContext('context') as common.UIAbilityContext;
  // 单独指定使用相机
  const info = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
  const pickerProfile: cameraPicker.PickerProfile = {
    cameraPosition: cameraPos === 'front' ? camera.CameraPosition.CAMERA_POSITION_FRONT : camera.CameraPosition.CAMERA_POSITION_BACK,
    videoDuration: maxDuration,
  }
  let mediaTypes: cameraPicker.PickerMediaType[] = []
  if (captureType === PHOTO_TYPE.IMAGE_VIDEO) {
    mediaTypes.push(cameraPicker.PickerMediaType.VIDEO, cameraPicker.PickerMediaType.PHOTO);
  } else if (captureType === PHOTO_TYPE.IMAGE) {
    mediaTypes.push(cameraPicker.PickerMediaType.PHOTO);
  } else if (captureType === PHOTO_TYPE.VIDEO) {
    mediaTypes.push(cameraPicker.PickerMediaType.VIDEO);
  }
  try {
    const pickerResult: cameraPicker.PickerResult = await cameraPicker.pick(context, mediaTypes, pickerProfile);
    if (pickerResult.resultUri) {
      uris = [pickerResult.resultUri];
    }
  } catch (error) {
    const err = error as BusinessError;
    wbLogger.error(MEDIA_UTIL, `Failed camera capture: ${err.message}`);
  }
  return uris;
}

export async function compressImage(params: CompressImageParams): Promise<CompressResult> {
  let options: CompressResult = {};
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
    const supportTypes: string[] = ['jpg', 'png', 'webp'];
    const fileName = src.split('/').pop() || '';
    // 无后缀的src以jpg处理
    const originSrcSuffix = fileName.indexOf('.') >= 0 ? (src.toLowerCase().split('.').pop() || 'jpg') : 'jpg';
    const context = getContext();
    if (supportTypes.includes(originSrcSuffix)) {
      // 压缩
      const arrayBuf = await getArrayBuffer(20, fd, originSrcSuffix, params.compressHeight, params.compressedWidth);
      const newFileName = `IMAGE_${Date.now()}`;
      const tmpPath = `${context.tempDir}/${newFileName}.${originSrcSuffix}`;
      try {
        fs.openSync(tmpPath, fs.OpenMode.CREATE)
        const fileOpen = fs.openSync(tmpPath, fs.OpenMode.READ_WRITE)
        fs.writeSync(fileOpen.fd, arrayBuf)
        // 获取临时文件的大小
        const stat = FileUtils.getFileStatFromUri(tmpPath);
        fs.closeSync(fileOpen);
        return {
          tempFilePath: switchHapSandBoxToInternal(tmpPath),
          tempFileSize: stat.size,
          tempFileName: newFileName
        };
      } catch (error) {
        wbLogger.error(MEDIA_UTIL, `compressImage----file deal error:`, error)
      }
    } else {
      const newFileName = `IMAGE_${Date.now()}`;
      const originTempPath = `${context.tempDir}/${newFileName}.${originSrcSuffix}`;
      const asset = await getAssetByUri(src);
      await asset?.getReadOnlyFd().then((fd) => {
        fs.copyFileSync(fd, originTempPath);
        asset?.close(fd);
      })
      const stat = FileUtils.getFileStatFromUri(originTempPath);
      return {
        tempFilePath: switchHapSandBoxToInternal(originTempPath),
        tempFileSize: stat.size,
        tempFileName: newFileName,
      };
    }
  } catch (error) {
    wbLogger.error(MEDIA_UTIL, `compressImage----pack error:`, error)
  }
  return options;
}

async function getArrayBuffer(quality: number, fd: number, suffix: string, height?: number, width?: number) {
  suffix = ['jpeg', 'jpg'].includes(suffix) ? 'jpeg' : suffix;
  if (height !== undefined || width !== undefined) {
    let heightSize: number = height || width || 0;
    let widthSize: number = width || height || 0;
    const color: ArrayBuffer = new ArrayBuffer(heightSize * widthSize * 4);
    let opts: image.InitializationOptions = {
      editable: true,
      pixelFormat: 3,
      size: { height: heightSize, width: widthSize }
    }
    const pixelMap: image.PixelMap = await image.createPixelMap(color, opts);
    const imagePackerApi: image.ImagePacker = image.createImagePacker();
    let packOpts: image.PackingOption = { format: `image/${suffix}`, quality };
    const arrayBuf = await imagePackerApi.packing(pixelMap, packOpts);
    return arrayBuf;
  } else {
    const imageSourceApi: image.ImageSource = image.createImageSource(fd);
    const imagePackerApi: image.ImagePacker = image.createImagePacker();
    const packOpts: image.PackingOption = { format: `image/${suffix}`, quality };
    if (suffix !== 'png') {
      return (await imagePackerApi.packing(imageSourceApi, packOpts));
    } else {
      const imageInfo = await imageSourceApi.getImageInfo();
      const pixelMap = await imageSourceApi.createPixelMap({
        desiredSize: {
          width: imageInfo.size.width / 2,
          height: imageInfo.size.height / 2,
        }
      });
      return (await imagePackerApi.packing(pixelMap, packOpts));
    }
  }
}

export async function compressVideo(src: string): Promise<CompressResult> {
  try {
    let videoCompressor: VideoCompressor = new VideoCompressor();
    const context = GlobalThis.getInstance().getContext('context');
    const data = await videoCompressor.compressVideo(context, src, CompressQuality.COMPRESS_QUALITY_HIGH);
    if (data.code == CompressorResponseCode.SUCCESS) {
      const stat = FileUtils.getFileStatFromUri(data.outputPath);
      const length = data.outputPath.split('/').length - 1;
      const name = data.outputPath.split('/')[length]
      return {
        tempFilePath: switchHapSandBoxToInternal(data.outputPath),
        tempFileSize: stat.size,
        tempFileName: name.split('.')[0]
      };
    } else {
      wbLogger.error(MEDIA_UTIL, `videoCompressor error:`, data.message);
    }
  } catch (err) {
    wbLogger.error(MEDIA_UTIL, `videoCompressor error:`, err.message);
  }
  return {};
}

export async function getChooseMediaRet(mediaList: IMediaData[], useOriginal: boolean): Promise<ChooseMediaResults> {
  const resTypes: Set<string> = new Set();
  const tempFilePaths: string[] = []
  const tempFiles: MediaFile[] = []
  for (const media of mediaList) {
    resTypes.add(media.type)
    if (useOriginal) {
      let thumbPath: string | undefined = '';
      if (media.type === 'video') {
        const asset = await getAssetByUri(media.originPath)
        if (asset) {
          thumbPath = await generateThumbnailFile(asset)
        }
      }
      // 复制相册原图/原视频到应用沙箱临时路径
      const context = getContext();
      const originTempPath = `${context.tempDir}/${Date.now()}_${media.originPath.split('/').splice(-1, 1).toString()}`;
      const asset = await getAssetByUri(media.originPath);
      await asset?.getReadOnlyFd().then((fd) => {
        fs.copyFileSync(fd, originTempPath);
        asset?.close(fd);
      })
      const internalTempPath = switchHapSandBoxToInternal(originTempPath);
      const resMediaInfo: MediaFile = {
        tempFilePath: internalTempPath,
        size: media.originSize,
        fileType: media.type,
        duration: media.type === 'video' ? Math.floor((media.duration || 0) / 1000) : undefined,
        width: media.type === 'video' ? media.width : undefined,
        height: media.type === 'video' ? media.height : undefined,
        thumbTempFilePath: media.type === 'video' ? thumbPath : undefined,
      }
      tempFiles.push(resMediaInfo)
      tempFilePaths.push(internalTempPath)
    } else {
      if (media.type === 'image') {
        const compress: CompressResult = await compressImage({ src: media.originPath })
        if (compress === undefined || compress.tempFilePath === undefined || compress.tempFileSize === undefined || compress.tempFileName === undefined) {
          continue;
        }
        tempFilePaths.push(compress.tempFilePath)
        tempFiles.push({
          tempFilePath: compress.tempFilePath,
          size: compress.tempFileSize,
          fileType: 'image',
        })
      } else {
        const compress: CompressResult = await compressVideo(media.originPath)
        if (compress === undefined || compress.tempFilePath === undefined || compress.tempFileSize === undefined || compress.tempFileName === undefined) {
          continue;
        }
        tempFilePaths.push(compress.tempFilePath)
        let thumbPath: string | undefined = '';
        if (media.type === 'video') {
          const asset = await getAssetByUri(media.originPath)
          if (asset) {
            thumbPath = await generateThumbnailFile(asset)
          }
        }
        tempFiles.push({
          tempFilePath: compress.tempFilePath,
          size: compress.tempFileSize,
          fileType: 'video',
          duration: Math.floor((media.duration || 0) / 1000),
          width: media.width,
          height: media.height,
          thumbTempFilePath: thumbPath,
        })
      }
    }
  }
  const resType: string = resTypes.size === 2 ? 'mix' : (resTypes.size === 1 ? Array.from(resTypes)[0] : '')
  const retData: ChooseMediaResults = {
    tempFilePaths: tempFilePaths,
    tempFiles: tempFiles,
    type: resType,
  }
  return retData
}

export async function generateThumbnailFile(asset: photoAccessHelper.PhotoAsset): Promise<string> {
  try {
    const thumbnail = await asset.getThumbnail({ height: 768, width: 768 });
    const imagePacker = image.createImagePacker();
    const buffer = await imagePacker.packing(thumbnail, {
      format: 'image/jpeg',
      quality: 100,
    });
    const context = getContext();
    const sandboxThumbPath = `${context.tempDir}/${Date.now()}.jpg`;
    const file = fs.openSync(sandboxThumbPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.writeSync(file.fd, buffer);
    fs.closeSync(file.fd);
    return switchHapSandBoxToInternal(sandboxThumbPath);
  } catch (err) {
    wbLogger.info(MEDIA_UTIL, 'generateThumbnailFile failed');
    return '';
  }
}

export async function getVideoThumbnail(asset: photoAccessHelper.PhotoAsset): Promise<PixelMap> {
  return await asset.getThumbnail({ height: 768, width: 768 })
}

type ChooseAlbumCallback = (options: chooseAlbumOptions, mediaItems: MediaItemData[], previewOneImage?: boolean) => Promise<ChooseAlbumResult>

export async function selectMediaAssets(options: ChooseMediaOptions, chooseAlbumCallback: ChooseAlbumCallback) {
  const apiName = options.apiName;
  try {
    if (options.count && typeof (options.count) !== 'number') {
      options.fail({ errMsg: `${apiName}:fail parameter count:Expected Number with value NaN` })
      return;
    }
    if (options.count === undefined || options.count < 1) {
      options.count = 9
    }
    // mediaType无值时默认设定为['image', 'video']
    options.mediaType ||= ['image', 'video']
    options.mediaType = Array.from(new Set(options.mediaType))

    // 如果mediaType的项多于2项或者包含mix, 则拉起的摄像头允许拍照和录像
    const photoType = (options.mediaType.length >= 2 || (options.mediaType || []).includes('mix')) ?
    PHOTO_TYPE.IMAGE_VIDEO : (options.mediaType[0] === 'image' ? PHOTO_TYPE.IMAGE : PHOTO_TYPE.VIDEO)

    if (options.sourceType === 'camera') {
      let chosenUris: string[] = [];
      let maxDuration = options.maxDuration || 10;
      maxDuration = maxDuration > 60 ? 60 : maxDuration;
      maxDuration = maxDuration < 3 ? 3 : maxDuration;
      chosenUris = await getCameraUris(photoType, maxDuration, options.camera);
      if (chosenUris.length === 0) {
        options.fail({ errMsg: `${apiName}:fail to pull up camera app` })
        return
      }
      const captureUrl = chosenUris[0]
      const asset = await getAssetByUri(captureUrl)
      const assetType = asset?.photoType === photoAccessHelper.PhotoType.IMAGE ? 'image' : 'video';
      const mediaList: IMediaData[] = [
        {
          originPath: captureUrl,
          type: assetType,
          originSize: Number(asset && asset.get(photoAccessHelper.PhotoKeys.SIZE) || 0), //asset获取SIZE得到undefined时设置为0
          duration: assetType === 'video' ? Number(asset && asset.get(photoAccessHelper.PhotoKeys.DURATION) || 0) : 0,
          width: assetType === 'video' ? Number(asset && asset.get(photoAccessHelper.PhotoKeys.WIDTH) || 0) : 0,
          height: assetType === 'video' ? Number(asset && asset.get(photoAccessHelper.PhotoKeys.HEIGHT) || 0) : 0,
        }
      ]
      options.sizeType ||= ['original', 'compressed'];
      options.sizeType = Array.from(new Set(options.sizeType));
      let useOriginal = (options.sizeType.length === 2) || (options.sizeType[0] === 'original');

      // chooseImage在设置sizeType=['original', 'compressed']时，拍照的场景下弹出原图设置界面
      if (apiName === 'chooseImage' && options.sizeType.length === 2 && assetType === 'image') {
        const mediaItemData = new MediaItemData(mediaList[0]);
        mediaItemData.isSelected = true;
        try {
          const chooseInfo = await chooseAlbumCallback({
            count: 1,
            sizeType: ['original', 'compressed'],
            mediaType: ['image'],
          }, [mediaItemData], true);
          useOriginal = chooseInfo.isOriginal;
        } catch (err) {
          options.fail({ errMsg: 'cancel' });
          return;
        }
      }
      const ret = await getChooseMediaRet(mediaList, useOriginal);
      options.success({
        tempFilePaths: ret.tempFilePaths,
        tempFiles: ret.tempFiles,
        type: ret.type,
        errMsg: `${apiName}:ok`
      })
    } else {
      // 申请读取图库图片的权限
      const permissionsParams: Permissions[] = ['ohos.permission.READ_IMAGEVIDEO']
      const permissionsResults = await requestPermission(permissionsParams);
      for (let i = 0; i < permissionsResults.length; i++) {
        if (permissionsResults[i] !== 0) {
          options.fail({ errMsg: `${apiName}:permission fail` })
          return
        }
      }
      // 获取图库的数量
      const list = await getPhotoAssetList();
      const filteredMedia = filterPhotoVideo(list, photoType);
      if (!filteredMedia) {
        options.fail({ errMsg: `${apiName}:get uri fail` })
        return
      }

      // 打开图库组件进行选择
      const mediaItemList: MediaItemData[] = []
      for (const asset of filteredMedia) {
        let duration: number = 0;
        if (asset.photoType === photoAccessHelper.PhotoType.VIDEO) {
          duration = Number(asset.get(photoAccessHelper.PhotoKeys.DURATION));
        }
        const mediaData: IMediaData = {
          originPath: asset.uri,
          type: asset.photoType === photoAccessHelper.PhotoType.IMAGE ? 'image' : 'video',
          duration: duration,
          originSize: Number(asset.get(photoAccessHelper.PhotoKeys.SIZE)),
          height: Number(asset.get(photoAccessHelper.PhotoKeys.HEIGHT)),
          width: Number(asset.get(photoAccessHelper.PhotoKeys.WIDTH)),
        }
        mediaItemList.push(new MediaItemData(mediaData))
      }

      try {
        const chooseInfo = await chooseAlbumCallback({
          count: options.count || 9,
          sizeType: options.sizeType || ['original', 'compressed'],
          mediaType: options.mediaType,
        }, mediaItemList)
        const ret = await getChooseMediaRet(chooseInfo.tempFiles, chooseInfo.isOriginal)
        options.success({
          tempFilePaths: ret.tempFilePaths,
          tempFiles: ret.tempFiles,
          type: ret.type,
        })
      } catch (err) {
        options.fail({ errMsg: 'cancel' })
        return;
      }
    }
  } catch (err) {
    options.fail({ errMsg: `${err}` })
  }
}

export function getThumbnailPixelMap(originPath: string): Promise<PixelMap> {
  return new Promise<PixelMap>((resolve, reject) => {
    const context = getContext();
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(photoAccessHelper.PhotoKeys.URI, originPath)
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates: predicates
    };
    phAccessHelper.getAssets(fetchOptions).then((res) => {
      if (res) {
        res.getFirstObject().then((asset) => {
          asset?.getThumbnail({ height: 768, width: 768 }).then((res) => {
            resolve(res)
          }).catch(() => {
            reject(new Error('fail get thumbnail for video'));
          })
        }).catch(() => {
          reject(new Error('fail get asset for video'));
        })
      }
    }).catch(() => {
      reject(new Error('fail get assets'));
    })
  })
}