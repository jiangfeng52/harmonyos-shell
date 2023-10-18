/*
 * Huawei Hms Core IDL auto generates the file. Please do not modify except the import part.
 *
 * HIDL file path : com\\huawei\\hms\\js-base\\JSBCompat.hidl
 */

/* Please check the import part, whether the import paths are correct. Midify them, if not correct. */
import { HHeader, HObject, HParcel } from '../xpsf';

declare class JSBCompatProxy  {

  constructor(hObject: HObject);

  sendRequest(message: string): Promise<string>;
}

export class JSBCompat {
  static Proxy: typeof JSBCompatProxy;

  header: HHeader;

  sendRequest: (message: string) => string | Promise<string>;

  static asInterface(hObject: HObject): JSBCompatProxy;

  onTransact(code: number, dataParcel: HParcel, replyParcel: HParcel, flag: number): Promise<HParcel>;
}

