/**
 * 信息跟踪服务
 */
export class HTrace {

  /**
   * 开始跟踪
   * @param content 记录内容
   * @param taskId 可配可不配
   * @returns number taskId
   */
  static traceBegin(content: String, taskId?: number): number | undefined;

  /**
   * 发生错误时，跟踪记录
   * @param content 记录内容
   * @param taskId 可配可不配
   */
  static traceError(content: String, taskId?: number): void;

  /**
   * 结束跟踪
   * @param content 记录内容
   * @param taskId 可配可不配
   */
  static traceEnd(content: String, taskId?: number): void;
}