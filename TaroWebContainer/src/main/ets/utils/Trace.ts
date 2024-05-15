import hiTraceMeter from '@ohos.hiTraceMeter';

const TAG: string = 'TaroWebContainer'

class Trace {
  private isOpen = false

  constructor() {
  }

  setOpen(isOpen: boolean) {
    this.isOpen = isOpen
  }

  startTrace(traceTask: TraceTask) {
    this.isOpen && hiTraceMeter.startTrace(TAG, traceTask.valueOf())
  }

  finishTrace(traceTask: TraceTask) {
    this.isOpen && hiTraceMeter.finishTrace(TAG, traceTask.valueOf())
  }
}
// 导出模块内默认的日志对象
export const taroTrace = new Trace();

export enum TraceTask {
  onInterceptRequest = 1001,
  MiniLocalFileDataSource = 1002,
  MiniRawFileDataSource = 1003,
  nativeMethod = 1004
}
