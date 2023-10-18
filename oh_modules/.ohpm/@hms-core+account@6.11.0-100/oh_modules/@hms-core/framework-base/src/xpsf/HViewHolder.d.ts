import { HObject } from './HObject';

/**
 * 创建视图类
 */
export class HViewHolder {

  /**
   * 创建视图
   * @param containerId 容器ID
   * @param objId 远端对象ID
   * @returns Promise 创建成功返回远端对象
   */
  static createView(containerId: string, objId: string): HObject;

  static initalPropsOf(element: object): { x: number, y: number, width: number, height: number };
}
