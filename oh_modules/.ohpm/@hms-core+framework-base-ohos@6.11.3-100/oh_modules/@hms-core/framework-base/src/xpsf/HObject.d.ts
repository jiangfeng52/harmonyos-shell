import { HBaseAdapter } from "./HBaseAdapter";
import { HParcel } from "./HParcel";

/**
 * 代表远程对象
 */
export class HObject {
  // 远程对象唯一标识ID
  mId: string;

  // 远程对象的通信来源
  mAdapter: HBaseAdapter;

  // OHOS
  mRemoteStub: any;

  // 引用计数
  refCount: number;

  /**
   * 远端对象获取到数据时触发
   * @param code 传输状态码
   * @param dataParcel 传输数据
   * @param replyParcel 返回数据
   * @param flag 标识
   * @returns 返回数据
   */
  onTransact(code: number, dataParcel: HParcel, replyParcel: HParcel, flag: number): Promise<HParcel>;

  /**
   * 释放资源
   */
  release(): void;
}
