@Observed
export class VideoParams {
  width: number
  height: number
  componentId: string
  src: string
  controls?: boolean
  muted?: boolean
  loop?: boolean
  autoPlay?: boolean
  objectFit?: ImageFit
  onPlay?: (res?: string) => void
  onPause?: (res?: string) => void
  onFinish?: (res?: string) => void
  onUpdate?: (res?: number) => void
  onError?: (res?: string) => void
  onSeeked?: (res?: number) => void
  onSeeking?: (res?: number) => void

  constructor() {
    this.width = 0;
    this.height = 0;
    this.componentId = '';
    this.src = '';
  }
}