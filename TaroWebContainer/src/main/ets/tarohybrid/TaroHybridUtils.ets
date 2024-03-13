import Url from '@ohos.url';
import dataPreferences from '@ohos.data.preferences';
import { GlobalThis } from '../utils/GlobalThis';
import common from '@ohos.app.ability.common';

export class TaroHybridUtils {
  static addQueryParamToHash(urlString: string, paramName: string, paramValue: string): string {
    // 解析基础URL
    const url = Url.URL.parseURL(urlString);

    // 判断hash中是否已经有查询参数，并在适当位置添加新参数
    if (url.hash.includes('?')) {
      // 如果已经有查询参数，添加一个&符号连接新的查询参数
      url.hash += `&${paramName}=${encodeURIComponent(paramValue)}`;
    } else {
      // 如果没有查询参数，添加一个?符号开始新的查询参数
      url.hash += `?${paramName}=${encodeURIComponent(paramValue)}`;
    }

    // 返回新的URL字符串
    return url.toString();
  }

  private static getPreferences(): dataPreferences.Preferences | undefined {
    let context = GlobalThis.getInstance().getContext('context') as common.UIAbilityContext
    let options: dataPreferences.Options =  { name: 'taro_hybrid' };
    return dataPreferences.getPreferencesSync(context, options);
  }

  static getSP(key: string): string | undefined{
    const preferences = TaroHybridUtils.getPreferences()
    return preferences?.getSync(key, '') + '';
  }

  static setSP(key: string, value: string) {
    const preferences = TaroHybridUtils.getPreferences()
    preferences?.putSync(key, value)
  }
}