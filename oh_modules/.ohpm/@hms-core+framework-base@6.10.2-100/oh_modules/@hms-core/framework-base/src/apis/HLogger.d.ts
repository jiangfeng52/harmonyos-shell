/**
 * 日志打印
 */
export class HLogger {

  /**
   * 打印DEBUG级别的日志。
   * @param tag 指定日志标识，可以为任意字符串，建议用于标识调用所在的类或者业务行为。
   * @param format 格式字符串，用于日志的格式化输出。
   * @param args 需要打印的数据
   */
  static debug(tag: string, format: string, ...args: any[]): void;

  /**
   * 打印INFO级别的日志。
   * @param tag 指定日志标识，可以为任意字符串，建议用于标识调用所在的类或者业务行为。
   * @param format 格式字符串，用于日志的格式化输出。
   * @param args 需要打印的数据
   */
  static info(tag: string, format: string, ...args: any[]): void;

  /**
   * 打印WARN级别的日志。
   * @param tag 指定日志标识，可以为任意字符串，建议用于标识调用所在的类或者业务行为。
   * @param format 格式字符串，用于日志的格式化输出。
   * @param args 需要打印的数据
   */
  static warn(tag: string, format: string, ...args: any[]): void;

  /**
   * 打印ERROR级别的日志。
   * @param tag 指定日志标识，可以为任意字符串，建议用于标识调用所在的类或者业务行为。
   * @param format 格式字符串，用于日志的格式化输出。
   * @param args 需要打印的数据
   */
  static error(tag: string, format: string, ...args: any[]): void;
}