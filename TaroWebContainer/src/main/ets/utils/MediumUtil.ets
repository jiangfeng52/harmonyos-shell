import dataSharePredicates from '@ohos.data.dataSharePredicates';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import common from '@ohos.app.ability.common';
import { GlobalThis } from './GlobalThis';
import { IMediaData, MediaItemData } from '../interfaces/Media'
import { PHOTO_TYPE, getCameraUris, getAssetByUri, getChooseMediaRet } from './MediaUtil'
import { ChooseMediumOptions } from '../interfaces/InjectObject';

interface chooseCameraBack {
  options: ChooseMediumOptions;
  isFail: boolean;
}

function coverMediumType(options?: string[]) {
  if (options === undefined) {
    return photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE
  }
  if (options.includes('image') && options.includes('video')) {
    return photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE
  }
  if (!options.includes('image') && options.includes('video')) {
    return photoAccessHelper.PhotoViewMIMETypes.VIDEO_TYPE
  }
  if (options.includes('image') && !options.includes('video')) {
    return photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
  }
  return photoAccessHelper.PhotoViewMIMETypes.IMAGE_VIDEO_TYPE
}

export async function selectMediumAssets(options: ChooseMediumOptions) {
  const apiName = options.apiName;
  try {
    if (options.count && typeof (options.count) !== 'number') {
      options.fail({ errMsg: `${apiName}:fail parameter count:Expected Number with value NaN` });
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

    let isFail = false;
    if (options.sourceType === 'camera') {
      const chooseCameraBack = await chooseCamera(options, photoType, apiName, isFail)
      isFail = chooseCameraBack.isFail
      options = chooseCameraBack.options
      if (isFail) {
        return;
      }
    } else {
      const chooseMediaBack = await chooseMedium(options, apiName, isFail);
      isFail = chooseMediaBack.isFail;
      options = chooseMediaBack.options;
      if (isFail) {
        return;
      }
    }
  } catch (err) {
    options.fail({ errMsg: `${err}` })
  }
}

async function chooseCamera(options: ChooseMediumOptions, photoType: PHOTO_TYPE, apiName: string, isFail: boolean): Promise<chooseCameraBack> {
  let chosenUris: string[] = [];
  let maxDuration = options.maxDuration || 10;
  maxDuration = maxDuration > 60 ? 60 : maxDuration;
  maxDuration = maxDuration < 3 ? 3 : maxDuration;
  chosenUris = await getCameraUris(photoType, maxDuration, options.camera);
  if (chosenUris.length === 0) {
    options.fail({ errMsg: `${apiName}:fail to pull up camera app` })
    isFail = true
    return { options, isFail };
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

  const ret = await getChooseMediaRet(mediaList, useOriginal);
  options.success({
    tempFilePaths: ret.tempFilePaths,
    tempFiles: ret.tempFiles,
    type: ret.type,
    errMsg: `${apiName}:ok`
  })
  return { options, isFail };
}

async function chooseMedium(options: ChooseMediumOptions, apiName: string, isFail: boolean): Promise<chooseCameraBack> {
  // 打开图库选择视频或图片
  let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
  PhotoSelectOptions.MIMEType = coverMediumType(options.mediaType);
  PhotoSelectOptions.maxSelectNumber = options.count;
  PhotoSelectOptions.isPhotoTakingSupported = Boolean(options.takingSupported);
  PhotoSelectOptions.isEditSupported = Boolean(options.editSupported);
  PhotoSelectOptions.isSearchSupported = Boolean(options.searchSupported);
  let photoPicker = new photoAccessHelper.PhotoViewPicker();
  let PhotoSelectResult: photoAccessHelper.PhotoSelectResult = await photoPicker.select(PhotoSelectOptions)
  if (PhotoSelectResult.photoUris.length === 0) {
    options.fail({ errMsg: `${apiName}:get uri fail` })
    isFail = true
    return { options, isFail }
  }

  //获取资源信息
  const context = GlobalThis.getInstance().getContext('context') as common.UIAbilityContext;
  let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
  const mediaItemList: MediaItemData[] = []
  for (const uri of PhotoSelectResult.photoUris) {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo('uri', uri);
    let fetchOption: photoAccessHelper.FetchOptions = {
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
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> = await phAccessHelper.getAssets(fetchOption);
    let assertCount: number = await fetchResult.getCount();
    if (assertCount > 0) {
      let asset: photoAccessHelper.PhotoAsset = await fetchResult.getFirstObject();
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
  }

  try {
    let useOriginal = PhotoSelectResult.isOriginalPhoto;
    const ret = await getChooseMediaRet(mediaItemList, useOriginal)
    options.success({
      tempFilePaths: ret.tempFilePaths,
      tempFiles: ret.tempFiles,
      type: ret.type,
    })
  } catch (err) {
    options.fail({ errMsg: 'cancel' })
    isFail = true
    return { options, isFail };
  }
  return { options, isFail };
}
