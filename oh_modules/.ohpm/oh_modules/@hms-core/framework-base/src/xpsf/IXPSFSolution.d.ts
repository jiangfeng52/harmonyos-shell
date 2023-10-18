/*
 * Huawei Hms Core IDL auto generates the file. Please do not modify except the import part.
 *
 * HIDL file path : com\\huawei\\hms\\xpsf\\solution\\IXPSFSolution.hidl
 */

/* Please check the import part, whether the import paths are correct. Midify them, if not correct. */
import { HHeader } from './HHeader';
import { HObject } from './HObject';
import { HParcel } from './HParcel';

/**
 * 功能描述  XPSF的默认处理通道
 */
export class IXPSFSolution {
  static API_LELVEL: number;
  static CODE_START_DEFAULT_SOLUTION: number;

  header: HHeader;
  startDefaultSolution: any;

  static asInterface(hObject: HObject): IXPSFSolutionProxy;

  onTransact(code: number, dataParcel: HParcel, replyParcel: HParcel): Promise<HParcel>;
}


declare class IXPSFSolutionProxy {
  
  constructor(hObject: HObject);

  startDefaultSolution(errorCode: number): Promise<number>;
}
