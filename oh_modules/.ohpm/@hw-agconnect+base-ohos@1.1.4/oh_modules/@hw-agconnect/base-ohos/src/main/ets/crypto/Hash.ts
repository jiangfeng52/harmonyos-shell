import { Logger } from '../log/logger';
import { stringToUint8Array, uint8ArrayTohexString } from './Unit8ArrayUtil';
import cryptoFramework from '@ohos.security.cryptoFramework';

const TAG: string = "AesCrypto";
const CHUNK = 100 * 1024;
const ERROR_CODE = 1105002;

export class Hash {
  /**
   * @deprecated
   */
  static md5(str: string): string {
    return "";
  }

  /**
   * @deprecated
   */
  static sha256(data: Uint8Array) {
    return "";
  }
}

export async function sha256(input: Uint8Array | string) {
  return digest('SHA256', input);
}

export async function digest(algName, input: Uint8Array | string) {
  if (!input) {
    return Promise.reject({ code: ERROR_CODE, message: 'digest error, input is empty' });
  }
  let unit8Array;
  if (typeof input === 'string') {
    unit8Array = stringToUint8Array(input);
  } else {
    unit8Array = input;
  }

  let md: cryptoFramework.Md;
  try {
    md = cryptoFramework.createMd(algName);
  } catch (error) {
    Logger.error(TAG, `create md error, code: ${error?.code}, message: ${error?.message}`);
    return Promise.reject({
      code: ERROR_CODE,
      message: `create md error, code: ${error?.code}, message: ${error?.message}`
    });
  }
  let start = 0;
  let left = unit8Array.length;
  try {
    while (left > 0) {
      let buf = unit8Array.slice(start, start + Math.min(CHUNK, left));
      start = start + CHUNK;
      left = left - CHUNK;
      await md.update({ data: buf });
    }
    let digest = await md.digest();
    if (digest && digest.data) {
      return uint8ArrayTohexString(digest.data);
    }
    Logger.error(TAG, 'digest or digest.data is empty');
    return Promise.reject({ code: ERROR_CODE, message: 'digest or digest.data is empty' });
  } catch (error) {
    return Promise.reject({
      code: ERROR_CODE,
      message: `digest md error, code: ${error?.code}, message: ${error?.message}`
    });
  }
}