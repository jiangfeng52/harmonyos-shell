import { AgcCrypto } from '@hw-agconnect/crypto-ohos'
import { hexToBytes, bytesToHex } from "../crypto/Hex"
import { getKey } from '../crypto/Keys'
import { FrameworkCrypto } from './FrameworkCrypto';

export class AegisAes {
  public static async buildKey(rxHex: string, ryHex: string, rzHex: string, slHex: string, iterationCount: number): Promise<string> {
    let password = getKey(hexToBytes(rxHex), hexToBytes(ryHex), hexToBytes(rzHex));
    let key = AgcCrypto.ohGenPbkdf2(bytesToHex(password), slHex, iterationCount);
    return Promise.resolve(key);
  }

  public static async decryptWithIv(workKey: string, ivHex: string, cipher: string) {
    let result = await FrameworkCrypto.ohGenAesCbcDecryptWithIv(cipher, workKey, ivHex);
    if (result == undefined || result == '') {
      return cipher;
    }
    return result;
  }

  public static async encryptWithIv(workKey: string, ivHex: string, cipher: string) {
    let result = await FrameworkCrypto.ohGenAesCbcEncryptWithIv(cipher, workKey, ivHex);
    return result ? result : cipher;
  }

}

