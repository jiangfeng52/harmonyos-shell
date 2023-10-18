import hilog from '@ohos.hilog';
import { HGlobalVariableManager }  from '@hms-core/framework-base';

const TAG = '[HMSCore-OHOSBase]';
// 自定义domino，数值无含义。
const domain = 0x6666;

/**
 * 日志打印，对hilog的封装
 */
export class HMSLogger {

    public static DEFAULT_TAG: string = '[HMSCore-OHOSBase]';

    static debug(tag: string, format: string, ...args: any[]): void {
        hilog.debug(domain, tag, format, args);
    }

    static info(tag: string, format: string, ...args: any[]): void {
        hilog.info(domain, tag, format, args);
    }

    static warn(tag: string, format: string, ...args: any[]): void {
        hilog.warn(domain, tag, format, args);
    }

    static error(tag: string, format: string, ...args: any[]): void {
        hilog.error(domain, tag, format, args);
    }

}

HGlobalVariableManager.set("hmscoreFramework", "HMSLogger", HMSLogger);
