/**
 * 协议Header
 */
export class HHeader {

  // 协议版本号
  protolVersion: number;

  // appId
  appid: string;

  // 包名
  packageName: string

  // 事物ID
  transactId: string;

  // 调用状态
  status: number;

  // calling UId
  callingUid: string;

  // sub app id
  subAppId: string;

  constructor(protolVersion: number);

  /**
   * 从protobuf读书Header数据
   * @param argReader 序列化读对象，类型为jspb.BinaryReader
   */
  readMessage(argReader: any): void;

  /**
   * 把Header的数据写到argWriter中
   * @param argWriter 序列化写对象，类型为jspb.BinaryWriter
   */
  writeMessage(argWriter: any): void;
}