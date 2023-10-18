import dataPreferences from '@ohos.data.preferences';
import { HGlobalVariableManager, HError, ErrorCode } from '@hms-core/framework-base';
import { HMSLogger } from "./HMSLogger";

// 默认配置文件名
const HMS_DEFAULT_PREFERENCES_NAME = 'HMS_DEFAULT_PREFERENCES_NAME';

/**
 * HMS配置类，支持set(添加/修改)、get(获取)、delete(删除)、has(判断是否存在)、clean(清空)
 * 构造时需传入context，传入的context不同获取的配置也是同一套。
 * 
 * `set`、`delete`、`clean`方法做了IO节流优化。数据写入到内存后不会立马同步到磁盘中，这样可以在多次操作场景下节省IO操作。
 * 如果需要立马同步可以执行`synchronize`方法。
 */
export class OHOSPreferences {

  // 鸿蒙sdk配置管理对象
  private preferences: any;

  // 文件名
  private name: string;

  // 节流用计时器
  private timer: any;

  constructor(name: string) {
    if (!name) {
      this.name = HMS_DEFAULT_PREFERENCES_NAME
    } else {
      this.name = name;
    }
  }

  private getPreferences(): Promise<any> {
    return new Promise((resolve, reject) => {
      if (this.preferences) {
        resolve(this.preferences);
      }
      const context = HGlobalVariableManager.get('hmscoreFramework', 'connectAbilityContext');
      if (context) {
        try {
          dataPreferences.getPreferences(context, this.name)
          .then(resolve, reject)
          .catch((err) => {
            HMSLogger.error(HMSLogger.DEFAULT_TAG, "Failed to get preferences. code = " + err.code + ", message = " + err.message);
            reject(new HError(ErrorCode.ADAPTER_UNINITIALIZED, 'Failed to get preferences.'));
          });
        } catch(err) {
          HMSLogger.error(HMSLogger.DEFAULT_TAG, "Failed to get preferences. code = " + err.code + ", message = " + err.message);
          reject(new HError(ErrorCode.ADAPTER_UNINITIALIZED, 'Failed to get preferences.'));
        }
        return
      }
      reject(new HError(ErrorCode.ADAPTER_UNINITIALIZED, 'OHOSPreferences.getPreferences context is null.'));
    });
  }

  /**
   * 获取配置
   * @param key 键
   * @param defValue 数据不存在时返回的默认值
   * @returns 获取到的数据，如果不存在则返回传入的`defValue`
   */
  async get(key: string, defValue: string | number | boolean): Promise<string | number | boolean> {
    const preferences = await this.getPreferences();
    return await preferences.get(key, defValue);
  }

  /**
   * 设置配置
   * @param key 键
   * @param value 要设置的值
   */
  async set(key: string, value: string | number | boolean): Promise<void> {
    const preferences = await this.getPreferences();
    await preferences.put(key, value);
    this.throttleSynchronize();
  }

  /**
   * 判断是否存在该键的配置
   * @param key 键
   * @returns true-存在；false-不存在
   */
  async has(key: string): Promise<boolean> {
    const preferences = await this.getPreferences();
    return await preferences.has(key);
  }

  /**
   * 删除配置
   * @param key 键
   */
  async delete(key: string): Promise<void> {
    const preferences = await this.getPreferences();
    await preferences.delete(key);
    this.throttleSynchronize();
  }

  /**
   * 清空所有配置
   */
  async clear(): Promise<void> {
    const preferences = await this.getPreferences();
    await preferences.clear();
    this.throttleSynchronize();
  }

  /**
   * 强制同步
   */
  async synchronize() {
    const preferences = await this.getPreferences();
    await preferences.flush();
  }

  private throttleSynchronize() {
    /**
     * 节流内存数据同步至磁盘，减少IO操作。
     * 延时100ms执行同步，在这100ms内再次调用将不会做任何操作
     */
    if (this.timer) {
      return;
    }
    this.timer = setTimeout(() => {
      this.timer = undefined;
      this.synchronize();
    }, 100);
  }
}