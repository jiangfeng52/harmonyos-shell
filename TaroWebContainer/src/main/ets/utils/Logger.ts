import hilog from '@ohos.hilog'

const TAG: string = 'WebContainer'

export enum LoggerLevel {
  LOG_DEBUG = hilog.LogLevel.DEBUG,
  LOG_INFO = hilog.LogLevel.INFO,
  LOG_WARN = hilog.LogLevel.WARN,
  LOG_ERROR = hilog.LogLevel.ERROR,
  LOG_FATAL = hilog.LogLevel.FATAL,
  LOG_OFF,
}

export class Logger {
  static logLevel: LoggerLevel = LoggerLevel.LOG_DEBUG;
  private domain: number = 0x0001;
  private commonTag: string;

  constructor(commonTag: string, domain: number = 0x0001) {
    this.commonTag = commonTag;
    this.domain = domain;
  }

  // 设置日志级别，低于此级别的打印方法将不执行打印
  static setLogLevel(logLevel: LoggerLevel): void {
      Logger.logLevel = logLevel;
  }

  static log(...args: any[]): void {
    console.log(`[${TAG}]`, ...args);
  }

  debug(tag: string, format: string, ...args: any[]): void {
    if (Logger.logLevel > LoggerLevel.LOG_DEBUG) {
      return;
    }
    hilog.debug(this.domain, this.commonTag, `[${tag}] ${format}`, args);
  }

  info(tag: string, format: string, ...args: any[]): void {
    if (Logger.logLevel > LoggerLevel.LOG_INFO) {
      return;
    }
    hilog.info(this.domain, this.commonTag, `[${tag}] ${format}`, args);
  }

  warn(tag: string, format: string, ...args: any[]): void {
    if (Logger.logLevel > LoggerLevel.LOG_WARN) {
      return;
    }
    hilog.warn(this.domain, this.commonTag, `[${tag}] ${format}`, args);
  }

  error(tag: string, format: string, ...args: any[]): void {
    if (Logger.logLevel > LoggerLevel.LOG_ERROR) {
      return;
    }
    hilog.error(this.domain, this.commonTag, `[${tag}] ${format}`, args);
  }

  fatal(tag: string, format: string, ...args: any[]): void {
    if (Logger.logLevel > LoggerLevel.LOG_FATAL) {
      return;
    }
    hilog.fatal(this.domain, this.commonTag, `[${tag}] ${format}`, args);
  }
}
// 导出模块内默认的日志对象
export const wbLogger = new Logger(TAG);
