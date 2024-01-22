@Observed
export class MediaItemData {
  public originPath: string;
  public type: string;
  public originSize: number = 0;
  public duration: number = 0;
  public width: number = 0;
  public height: number = 0;
  public isSelected: boolean = false;
  public thumbnail: PixelMap|undefined = undefined;

  constructor(data: IMediaData) {
    this.originPath = data.originPath;
    this.type = data.type;
    this.duration = data.duration || 0;
    this.originSize = data.originSize || 0;
    this.width = data.width || 0;
    this.height = data.height || 0;
  }
}

export interface IMediaData {
  originPath: string;
  type: string;
  originSize: number;
  duration?: number;
  width?: number;
  height?: number;
}

export interface MediaFile {
  tempFilePath: string;
  size: number;
  fileType: string;
  duration?: number;
  height?: number;
  width?: number;
  thumbTempFilePath?: string;
}

export interface AlbumBackward {
  accessBackward: () => boolean;
   backward: () => void;
}

export interface ChooseAlbumResult {
  tempFiles: IMediaData[];
  isOriginal: boolean;
}

export interface ChooseMediaResults {
  tempFilePaths: string[];
  tempFiles: MediaFile[];
  type: string;
}

export interface chooseAlbumOptions {
  count: number;
  mediaType: string[];
  sizeType: string[];
}
