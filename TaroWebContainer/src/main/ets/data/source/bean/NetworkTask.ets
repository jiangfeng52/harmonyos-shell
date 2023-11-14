

export enum NetworkTaskStaus {
  ACTIVE, // 请求中...
  READY, // 请求成功...
  FAILED // 请求失败...
}

export class NetworkTask<T> {
  data: T | null;
  taskStatus: NetworkTaskStaus;

  constructor(data: T | null, taskStatus: NetworkTaskStaus) {
    this.data = data;
    this.taskStatus = taskStatus;
  }
}