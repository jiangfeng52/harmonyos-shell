import { taroLogger } from '../../../../utils/Logger';
import { AbilityConstant } from '@kit.AbilityKit';

enum TaroMemoryLevel {
  MEMORY_LEVEL_MODERATE = 5, // 内存占用适中
  MEMORY_LEVEL_LOW = 10,     // 内存占用低
  MEMORY_LEVEL_CRITICAL = 15 // 内存占用高
}

class MemoryManager {
  private listeners: Set<Function> = new Set();

  /**
   * 注册监听器
   *
   * @param callback 监听器函数
   */
  registerListener(callback: Function): void {
    this.listeners.add(callback);
  }

  /**
   * 取消监听器
   *
   * @param callback 要取消的监听器函数，如果不提供则取消所有监听器
   */
  unRegisterListener(callback?: Function): void {
    if (!callback) {
      this.listeners.clear();
    } else if (this.listeners.has(callback)) {
      this.listeners.delete(callback);
    } else {
      taroLogger.warn('MemoryManager', 'The listening function that needs to be closed does not exist.');
    }
  }

  /**
   * 触发监听器
   *
   * @param level 内存告警级别
   */
  triggerListener(level: AbilityConstant.MemoryLevel) {
    for (const listener of this.listeners) {
      try {
        if (level === AbilityConstant.MemoryLevel.MEMORY_LEVEL_MODERATE) {
          listener(TaroMemoryLevel.MEMORY_LEVEL_MODERATE);
        } else if (level === AbilityConstant.MemoryLevel.MEMORY_LEVEL_LOW) {
          listener(TaroMemoryLevel.MEMORY_LEVEL_LOW)
        } else {
          listener(TaroMemoryLevel.MEMORY_LEVEL_CRITICAL)
        }
      } catch (error) {
        taroLogger.error('MemoryManager', 'An error occurred while executing a listener function.', error);
      }
    }
  }
}

export const memoryManager = new MemoryManager();