/**
 * HMS配置类，支持set(添加/修改)、get(获取)、delete(删除)、has(判断是否存在)、clean(清空)
 * 构造时需传入context，传入的context不同获取的配置也是同一套。
 * `set`、`delete`、`clean`方法做了IO节流优化。数据写入到内存后不会立马同步到磁盘中，这样可以在多次操作场景下节省IO操作。
 * 如果需要立马同步可以执行`synchronize`方法。
 */
export class HPreferencesManager {
  
  /**
   * 构造函数，传入配置文件名，不传则使用默认值。
   * note: 由于可能存在多个模块同时使用HPreferencesManager，
   * 为了避免文件重名建议给文件名增加模块唯一前缀来避免文件重复。
   * @param name 配置文件名
   */
  constructor(name: string);

  /**
   * 获取配置
   * @param key 键
   * @param defValue 数据不存在是返回的默认值
   * @returns 获取到的数据，如果不存在则返回传入的`defValue`
   */
  get(key: string, defValue: string | number | boolean): Promise<string | number | boolean>;

  /**
   * 设置配置
   * @param key 键
   * @param value 要设置的值
   */
  set(key: string, value: string | number | boolean): Promise<void>;

  /**
   * 判断是否存在该键的配置
   * @param key 键
   * @returns true-存在；false-不存在
   */
  has(key: string): Promise<boolean>;

  /**
   * 删除配置
   * @param key 键
   */
  delete(key: string): Promise<void>;

  /**
   * 清空所有配置
   */
  clear(): Promise<void>;

  /**
   * 强制同步
   */
  synchronize(): Promise<void>;
}
