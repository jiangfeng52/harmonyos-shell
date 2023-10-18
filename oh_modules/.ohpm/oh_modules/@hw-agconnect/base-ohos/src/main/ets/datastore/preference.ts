// @ts-ignore
import data_preferences from '@ohos.data.preferences'
import { ICrypto } from '../crypto/ICrypto';

export class Preferences {
  private static TAG: string = "Preferences";
  static async get(context: any, fileName: string, key: string, crypto?: ICrypto): Promise<string> {
    let preferences = await data_preferences.getPreferences(context, fileName);
    let value = await preferences.get(key, '');
    if (crypto) {
      value = await crypto.decrypt(value as string);
    }
    return Promise.resolve(value as string);
  }

  static async put(context: any, fileName: string, key: string, value: string, crypto?: ICrypto): Promise<void> {
    let preferences = await data_preferences.getPreferences(context, fileName);
    if (crypto) {
      value = await crypto.encrypt(value);
    }
    await preferences.put(key, value);
    await preferences.flush();
    return Promise.resolve();
  }

  static async delete(context: any, fileName: string, key: string): Promise<void> {
    let preferences = await data_preferences.getPreferences(context, fileName);
    await preferences.delete(key);
    await preferences.flush();
    return Promise.resolve();
  }
}
