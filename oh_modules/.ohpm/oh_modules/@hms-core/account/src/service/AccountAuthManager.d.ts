import { HuaweiIdAuthParams } from "./HuaweiIdAuthParams";
import { AccountAuthResult } from "./AccountAuthResult";
import { AuthAccount } from "./AuthAccount";
/**
 * 帐号登录服务入口
 */
export declare class AccountAuthManager {
    /**
     * 前台授权登录
     *
     * @param signInOption HuaweiIdAuthParams
     * @returns 返回授权帐号信息.
     */
    static signIn(signInOption: HuaweiIdAuthParams): Promise<AccountAuthResult<AuthAccount>>;
    /**
     * 静默登录，该接口不会拉起授权页面.
     *
     * @param signInOption HuaweiIdAuthParams
     * @returns 返回授权帐号信息.
     */
    static silentSignIn(signInOption: HuaweiIdAuthParams): Promise<AccountAuthResult<AuthAccount>>;
    /**
     * 取消授权.
     *
     * @returns 返回成功与否.
     */
    static cancelAuthorization(): Promise<AccountAuthResult<AuthAccount>>;
}
