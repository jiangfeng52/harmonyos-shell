import { imageViewerManager } from './imageviewer/utils/ImageViewerManager';

export interface PreviewImageOptions {
  urls: Array<string>;
  current: string;
  showmenu: boolean;
  success: Function;
  fail: Function;
}

export function previewImage(options: PreviewImageOptions): void {
  imageViewerManager.imageView(options);
}