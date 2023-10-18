/**
 * 帐号日志工具类
 */
export default class Logger {
    static printSecurityLog: boolean;
    /**
     * print info level log
     *
     * @param {string} log - Log needs to be printed
     */
    static info(...args: any[]): void;
    /**
     * print debug level log
     *
     * @param {string} log - Log needs to be printed
     */
    static debug(...args: any[]): void;
    /**
     * print error level log
     *
     * @param {string} log - Log needs to be printed
     */
    static error(...args: any[]): void;
    static security(...args: any[]): void;
}
