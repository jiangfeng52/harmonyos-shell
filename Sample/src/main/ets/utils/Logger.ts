import hilog from '@ohos.hilog';

const TAG: string = 'WebContainerSample'

class Logger {
  private domain: number = 0x0001;
  private commonTag: string;

  private loggable = true

  constructor(commonTag: string, domain: number = 0x0001) {
    this.commonTag = commonTag;
    this.domain = domain;
  }

  setLoggable(loggable: boolean) {
    this.loggable = loggable
  }

  static log(...args: any[]): void {
    console.log(`[${TAG}]`, ...args);
  }

  debug(tag: string, format: string, ...args: any[]): void {
    this.loggable && hilog.debug(this.domain, this.commonTag, `[${tag}] ${format}`, args);
  }

  info(tag: string, format: string, ...args: any[]): void {
    this.loggable && hilog.info(this.domain, this.commonTag, `[${tag}] ${format}`, args);
  }

  warn(tag: string, format: string, ...args: any[]): void {
    this.loggable && hilog.warn(this.domain, this.commonTag, `[${tag}] ${format}`, args);
  }

  error(tag: string, format: string, ...args: any[]): void {
    this.loggable && hilog.error(this.domain, this.commonTag, `[${tag}] ${format}`, args);
  }

  fatal(tag: string, format: string, ...args: any[]): void {
    this.loggable && hilog.fatal(this.domain, this.commonTag, `[${tag}] ${format}`, args);
  }
}
// 导出模块内默认的日志对象
export const logger = new Logger(TAG);
