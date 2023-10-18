import buffer from '@ohos.buffer';

/**
 * 16进制的HEX字符串转成Uint8Array
 * @param hexString hex string
 * @returns Uint8Array
 */
export function hexStringToUint8Array(hexString: string): Uint8Array {
  return Uint8Array.from(hexString.match(/.{1,2}/g).map((byte) => parseInt(byte, 16)));
}

/**
 * Uint8Array转成 hexstring
 * @param array
 * @returns
 */
export function uint8ArrayTohexString(array: Uint8Array): string {
  return buffer.from(array).toString('hex');
}

/**
 * uint8Array转普通字符串
 *
 * @param array uint8Array
 * @returns string
 */
export function uint8ArrayToString(array: Uint8Array): string {
  return buffer.from(array).toString("utf8");
}

/**
 * 普通的字符串转成字节流
 *
 * @param str
 * @returns
 */
export function stringToUint8Array(str: string): Uint8Array {
  let arr = [];
  for (let i = 0; i < str.length; ++i) {
    arr.push(str.charCodeAt(i));
  }
  return new Uint8Array(arr);
}