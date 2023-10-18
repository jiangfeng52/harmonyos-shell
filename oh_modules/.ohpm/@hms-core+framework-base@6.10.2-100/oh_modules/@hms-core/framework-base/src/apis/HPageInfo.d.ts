/*
 * Huawei Hms Core IDL auto generates the file. Please do not modify except the import part.
 *
 * HIDL file path : com\\huawei\\hms\\kit2\\api\\HPageInfo.hidl
 */

/* Please check the import part, whether the import paths are correct. Midify them, if not correct. */
import { HParcel, HObject } from '../xpsf';

/**
 * 功能描述  hparcelable
 *
 * interface 关键字代表 => 远程调用接口
 *
 * 接口方法表示 => 返回值 方法名称(参数序号: 类型 名称 ...) = 方法序号;
 */
export class HPageInfo {

  packageName: string;
  pageName: string;
  action: string;
  extra: string;

  static creatorFromHParcel(dataParcel: HParcel): HPageInfo

  writeToParcel(hParcel: HParcel): void

  registerHObject(hObject: HObject): Promise<any>
}

/**
 * 
 * @deprecated since 请使用HPageInfo，从6.7.0-108开始弃用
 */
export class PageInfo {

  packageName: string;
  pageName: string;
  action: string;
  extra: string;

  static creatorFromHParcel(dataParcel: HParcel): PageInfo

  writeToParcel(hParcel: HParcel): void

  registerHObject(hObject: HObject): Promise<any>
}