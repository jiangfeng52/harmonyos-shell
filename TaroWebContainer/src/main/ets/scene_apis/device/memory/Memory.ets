import { memoryManager } from './memorymanager/MemoryManager';

/**
 * 注册内存不足告警事件监听。
 *
 * @param callback
 */
export function onMemoryWarning(callback: Function): void {
  memoryManager.registerListener(callback);
}

/**
 * 取消注册内存不足告警事件监听，若入参是function，则取消对应监听；若无入参则取消所有监听。
 *
 * @param callback
 */
export function offMemoryWarning(callback?: Function): void {
  memoryManager.unRegisterListener(callback);
}