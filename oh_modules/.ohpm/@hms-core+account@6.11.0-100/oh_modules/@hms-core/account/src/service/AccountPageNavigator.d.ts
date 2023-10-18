import { AccountAuthResult } from "./AccountAuthResult";
export declare class AccountPageNavigator {
    /**
     * 跳转到帐号中心页面.
     *
     * @returns 返回请求是否成功.
     */
    static startAccountCenter(): Promise<AccountAuthResult>;
}
