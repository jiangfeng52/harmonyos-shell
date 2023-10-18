import { HBaseAdapter } from './HBaseAdapter';
import { HHeader } from './HHeader';
import { HObject } from './HObject';
import { HUnknownObject } from './HUnknownObject';

/**
 * 序列化读写对象
 */
export class HParcel {

  mAdapter: HBaseAdapter;

  getHObjectsNum(): number;

  getHObjectIds(): string[];

  setHObjectIds(hObjectIds: string[]):void;

  /**
   * 转化成Base64
   * @returns Base64字符串
   */
  toBase64(): string;

  /**
   * 根据base64返回HParcel
   * @param base64String base64值
   */
  fromBase64(base64String: string): HParcel;

  getWriterBuffer(): Uint8Array;

  setWriterBuffer(buffer: Int8Array | Uint8Array | number[]): HParcel;

  getReaderBuffer(): Uint8Array;

  setReaderBuffer(buffer: Int8Array | Uint8Array | number[]): HParcel;


  /**
   * 如果流中还有数据，读取流中的下一个字段标头，
   * 如果我们看到有效的字段标头，则返回true，如果读完了整个流，则返回false。
   * 如果遇到不推荐使用的START_GROUP/END_GROUP字段，则引发错误。
   * @returns 如果流还有更多字段返回true，否则返回false。
   */
  nextField(): boolean;

  /**
   * 跳过当前数据。
   */
  skipField(): void;

  /**
   * @returns 当前标记是否在链尾。用于循环中的结束条件。
   */
  isEndGroup(): boolean;

  /**
   * @returns 缓冲区中下一个字段的字段编号，如果没有下一个字段，则为-1。
   */
  getFieldNumber(): number;


  /**
   * @returns 读Header信息
   */
  readHeader(): HHeader;

  /**
   * 读消息
   * @param readParcel 读取成功回调，回调参数为HParcel
   */
  readHParcelable(readParcel: (data: HParcel) => void): void;

  /**
   * @returns 读字符串
   */
  readString(): string;

  /**
   * @returns 读字节流
   */
  readBytes(): Uint8Array;

  /**
   * @returns 读取布尔型
   */
  readBool(): boolean;

  /**
   * @returns 读取整型
   */
  readInt(): number;

  /**
   * @returns 读取长整型
   */
  readInt64(): number;

  /**
   * @returns 读浮点
   */
  readFloat(): number;

  /**
   * @returns 读双精度浮点
   */
  readDouble(): number;

  /**
   * @returns 读HObject
   */
  readHObject(): HObject;

  /**
   * @returns 读取未知类型对象
   */
  readHUnknownObject(): HUnknownObject;

  /**
   * 写消息头
   * @param header 需要写入的Header
   */
  writeHeader(header: HHeader): void;

  /**
   * 写任意类型
   * @param field 字段编号
   * @param value 值
   * @param type 值类型, boolean, string, int, long, float, double, hparcelable, hobject, hunknownobject
   */
  writeAny(field: number, value: boolean | string | number | HParcel | HObject | HUnknownObject, type: string): void;

  /**
   * 写布尔类型
   * @param field 字段编号
   * @param boolValue 值
   */
  writeBool(field: number, boolValue: boolean): void;

  /**
   * 写浮点型
   * @param field 字段编号
   * @param floatValue 值
   */
  writeFloat(field: number, floatValue: number): void;

  /**
   * 写双精度浮点型
   * @param field 字段编号
   * @param doubleValue 值
   */
  writeDouble(field: number, doubleValue: number): void;

  /**
   * 写整型
   * @param field 字段编号
   * @param intValue 值
   */
  writeInt(field: number, intValue: number): void;

  /**
   * 写长整型
   * @param field 字段编号
   * @param longValue 值
   */
  writeInt64(field: number, longValue: number): void;

  /**
   * 写字符串值
   * @param field 字段编号
   * @param stringValue 值
   */
  writeString(field: number, stringValue: string): void;

  /**
   * 写字节流
   * @param field 字段编号
   * @param buffer 字节流
   */
  writeBytes(field: number, buffer: Uint8Array): void;

  /**
   * 写任意类型
   * @param field 字段编号
   * @param repeatedValue 值
   * @param type 值类型, boolean, string, int, long, float, double, hparcelable
   */
  writeRepeatAny(field: number, repeatedValue: boolean[] | string[] | HParcel[], type: string): void;

  /**
   * 写布尔类型集合
   * @param field 字段编号
   * @param repeatedValue 值
   */
  writeRepeatBool(field: number, repeatedValue: boolean[]): void;

  /**
   * 写浮点型集合
   * @param field 字段编号
   * @param repeatedValue 值
   */
  writeRepeatFloat(field: number, repeatedValue: number[]): void;

  /**
   * 写双精度浮点型集合
   * @param field 字段编号
   * @param repeatedValue 值
   */
  writeRepeatDouble(field: number, repeatedValue: number[]): void;

  /**
   * 写整型集合
   * @param field 字段编号
   * @param repeatedValue 值
   */
  writeRepeatInt32(field: number, repeatedValue: number[]): void;

  /**
   * 写长整型集合
   * @param field 字段编号
   * @param repeatedValue 值
   */
  writeRepeatInt64(field: number, repeatedValue: number[]): void;

  /**
   * 写字符串集合
   * @param field 字段编号
   * @param repeatedValue 值
   */
  writeRepeatString(field: number, repeatedValue: string[]): void;

  /**
   * 写序列化对象
   * @param field 字段编号
   * @param parcelable 序列化对象
   */
  writeHParcelable(field: number, parcelable: HParcel): void;

  /**
   * 写序列化对象集合
   * @param field  字段编号
   * @param repeatedValue 值
   */
  writeRepeatHParcelable(field: number, repeatedValue: HParcel[]): void;

  /**
   * write HOBject
   * @param field 字段编号
   * @param hObject hObject which can be invoke by remote
   */
  writeHObject(field: number, hObject: HObject): void;

  /**
   * write HUnknownObject
   * @param field 字段编号
   * @param hUnknownObject hUnknownObject which can be invoke by remote
   */
  writeHUnknownObject(field: number, hUnknownObject: HUnknownObject): void;
}
