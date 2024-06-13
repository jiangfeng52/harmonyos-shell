import deviceInfo from '@ohos.deviceInfo';
import window from '@ohos.window';
import display from '@ohos.display';

export class WindowConstants {
  static readonly WINDOW_UTIL: string = 'windowUtil';
  static readonly WINDOW_STATE_BAR_HEIGHT: string = 'topRectHeight'
  static readonly WINDOW_BOTTOM_BAR_HEIGHT: string = 'bottomRectHeight'

  static readonly DEVICE_PC: string = '2in1';
  static readonly DEVICE_PAD: string = 'tablet'
}

@Observed
export class WindowUtil {
  private windowStage?: window.WindowStage;
  private mainWindowClass?: window.Window;

  static getInstance(): WindowUtil | undefined {
    if (!AppStorage.get<WindowUtil>(WindowConstants.WINDOW_UTIL)) {
      AppStorage.setOrCreate(WindowConstants.WINDOW_UTIL, new WindowUtil());
    } else {
      // Logger.info(`AppStorage does not have windowUtil`);
    }
    return AppStorage.get<WindowUtil>(WindowConstants.WINDOW_UTIL);
  }

  setWindowStage(windowStage: window.WindowStage): WindowUtil {
    this.windowStage = windowStage;
    return this;
  }

  setMainWindowPortrait(): WindowUtil {
    if (this.windowStage === undefined) {
      // Logger.error(`WindowStage is undefined`);
      return this;
    }
    // 获取应用主窗口
    this.windowStage.getMainWindow((err, windowClass: window.Window) => {
      this.mainWindowClass = windowClass;
      if (err.code) {
        // Logger.error(`Failed to obtain the main window. Code:${err.code}, message:${err.message}`);
        return;
      }

      if (deviceInfo.deviceType === WindowConstants.DEVICE_PC) {
        // PC mate60为(387, 836)
        // let screenHeight = display.getDefaultDisplaySync().height;
        // this.mainWindowClass.resize(387, px2vp(screenHeight))
        // this.mainWindowClass.resize(387, 836)
        this.mainWindowClass.setPreferredOrientation(window.Orientation.AUTO_ROTATION);
      } else if (deviceInfo.deviceType === WindowConstants.DEVICE_PAD) {
        // Pad
        this.mainWindowClass.setPreferredOrientation(window.Orientation.AUTO_ROTATION);
      } else {
        // 手机设备
        this.mainWindowClass.setPreferredOrientation(window.Orientation.PORTRAIT);
        this.mainWindowClass.setWindowLayoutFullScreen(true);
      }

      // 获取导航区域的高度
      let avoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      let bottomRectHeight = avoidArea.bottomRect.height; // 获取到导航条区域的高度

      // 获取状态栏的高度
      const systemAvoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      const topRectHeight = systemAvoidArea.topRect.height
      // const displayInfo = display.getDefaultDisplaySync()
      // const avoidAreaHeight = Math.round(systemAvoidArea.topRect.height / displayInfo.densityPixels);
      // return avoidAreaHeight;

      AppStorage.setOrCreate(WindowConstants.WINDOW_STATE_BAR_HEIGHT, `${topRectHeight}px`);
      AppStorage.setOrCreate(WindowConstants.WINDOW_BOTTOM_BAR_HEIGHT, `${bottomRectHeight}px`);
    });

    return this;
  }

  setMainWindowLandscape(): void {
    if (this.mainWindowClass === undefined) {
      // Logger.error(`MainWindowClass is undefined`);
      return;
    }
    // Setting landscape display.
    this.mainWindowClass.setPreferredOrientation(window.Orientation.AUTO_ROTATION_LANDSCAPE);
  }

  setFullScreenBack(): void {
    if (this.mainWindowClass === undefined) {
      // Logger.error(`MainWindowClass is undefined`);
      return;
    }
    this.mainWindowClass.setPreferredOrientation(window.Orientation.PORTRAIT);
  }

  disableWindowSystemBar(): void {
    if (this.mainWindowClass === undefined) {
      // Logger.error(`MainWindowClass is undefined`);
      return;
    }
    // Set the status bar and navigation bar to be invisible in full-screen mode.
    this.mainWindowClass.setWindowSystemBarEnable([]);
  }

  enableWindowSystemBar(): void {
    if (this.mainWindowClass === undefined) {
      // Logger.error(`MainWindowClass is undefined`);
      return;
    }
    this.mainWindowClass.setWindowSystemBarEnable(['status', 'navigation']);
  }

  setFullScreen(): void {
    if (this.mainWindowClass === undefined) {
      // Logger.error(`MainWindowClass is undefined`);
      return;
    }
    // Set full-screen display.
    this.mainWindowClass.setWindowLayoutFullScreen(true, (err) => {
      if (err.code) {
        // Logger.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
        return;
      }
      // Logger.info('Succeeded in setting the window layout to full-screen mode.');
    });
  }

  getMainWindow(): window.Window | undefined {
    return this.mainWindowClass;
  }
}