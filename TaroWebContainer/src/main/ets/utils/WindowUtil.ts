/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import window from '@ohos.window';
import display from '@ohos.display';
import { taroLogger } from '../utils/Logger';

const WINDOW_UTIL = 'WindowUtil';

/**
 * 应用界面信息设置和获取实用函数
 */

export function setFullScreen(windowClass: window.Window) {
  windowClass.setWindowLayoutFullScreen(true, (err) => {
    if (err.code) {
      taroLogger.error(WINDOW_UTIL, `Failed to set the window layout to full-screen mode. Cause: ${JSON.stringify(err)}`);
    } else {
      taroLogger.info(WINDOW_UTIL, 'Succeeded in setting the window layout to full-screen mode.');
    }
  });
}

export function setSystemBarProperties(windowClass: window.Window, contentColor?: string) {
  const sysBarProps: window.SystemBarProperties = {
    statusBarColor: '#00FFFFFF',
    statusBarContentColor: contentColor,
  };
  windowClass.setWindowSystemBarProperties(sysBarProps, (err) => {
    if (err.code) {
      taroLogger.error(WINDOW_UTIL, `Failed to set the system bar properties. Cause: ${JSON.stringify(err)}}`);
      return;
    }
    taroLogger.info(WINDOW_UTIL, 'Succeeded in setting the system bar properties.');
  });
}

export function getWindowWidth(windowClass: window.Window) {
  try {
    const windowWidth = windowClass.getWindowProperties().windowRect.width;
    const displayInfo = display.getDefaultDisplaySync();
    return Math.round(windowWidth / displayInfo.densityPixels);
  } catch (error) {
    taroLogger.error(WINDOW_UTIL, `Failed to get window width: ${JSON.stringify(error)}`);
    return 40;
  }
}

export function getSystemBarHeight(windowClass: window.Window) {
  try {
    const systemAvoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
    const displayInfo = display.getDefaultDisplaySync()
    const avoidAreaHeight = Math.round(systemAvoidArea.topRect.height / displayInfo.densityPixels);
    return avoidAreaHeight;
  } catch (error) {
    taroLogger.error(WINDOW_UTIL, `Failed to get systemBar height: ${JSON.stringify(error)}`);
    return 40;
  }
}
