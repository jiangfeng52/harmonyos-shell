import i18n from '@ohos.i18n';
import { Logger } from '../log/logger'

export class LocaleUtil {
  /**
   * 返回国家码 :CN
   * @returns
   */
  static getCountry(): string {
    // 返回 zh-Hans-CN
//    try {
//      let locale = i18n.System.getSystemLocale().split("-");
//      if (locale && locale.length >= 3) {
//        return locale[2];
//      }
//    } catch (error) {
//      Logger.error("LocaleUtil", `call System.getSystemLocale failed, error code: ${error.code}, message: ${error.message}.`)
//    }
    return 'CN';
  }

  /**
   * 返回语言 :zh
   * @returns
   */
  static getLanguage(): string {
//    try {
//      let locale = i18n.System.getSystemLocale().split("-");
//      if (locale && locale.length >= 3) {
//        return locale[0];
//      }
//    } catch (error) {
//      Logger.error("LocaleUtil", `call System.getSystemLocale failed, error code: ${error.code}, message: ${error.message}.`)
//    }
    return 'zh';
  }

  /**
   * 返回语言 :Hans
   * @returns
   */
  static getScript(): string {
//    try {
//      let locale = i18n.System.getSystemLocale().split("-");
//      if (locale && locale.length >= 3) {
//        return locale[1];
//      }
//    } catch (error) {
//      Logger.error("LocaleUtil", `call System.getSystemLocale failed, error code: ${error.code}, message: ${error.message}.`)
//    }
    return 'Hans';
  }
}