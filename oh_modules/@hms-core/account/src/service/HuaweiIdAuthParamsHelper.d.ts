import { Scope } from "./Scope";
import { HuaweiIdAuthParams } from "./HuaweiIdAuthParams";
/**
 * HuaweiIdAuthParams对象的构造类
 */
export declare class HuaweiIdAuthParamsHelper {
    private scopes;
    private permissions;
    constructor(needOpenId?: boolean, needProfile?: boolean);
    /**
     * 请求用户授权应用获取Authorization Code
     *
     * @returns HuaweiIdAuthParamsHelper
     */
    setAuthorizationCode(): HuaweiIdAuthParamsHelper;
    /**
     * 配置授权ID Token，请求用户授权应用获取ID Token。
     *
     * @returns HuaweiIdAuthParamsHelper
     */
    setIdToken(): HuaweiIdAuthParamsHelper;
    /**
   * 请求帐号用户授权应用获取User ID
   *
   * @returns HuaweiIdAuthParamsHelper
   */
    setUid(): HuaweiIdAuthParamsHelper;
    /**
     * 请求用户授权应用获取帐号信息，如昵称和头像等.
     *
     * @returns HuaweiIdAuthParamsHelper
     */
    setProfile(): HuaweiIdAuthParamsHelper;
    /**
     * 请求用户授权应用获取unionId和openId.
     *
     * @returns HuaweiIdAuthParamsHelper
     */
    setId(): HuaweiIdAuthParamsHelper;
    /**
     * 请求用户授权应用获取Email地址.
     *
     * @returns HuaweiIdAuthParamsHelper
     */
    setEmail(): HuaweiIdAuthParamsHelper;
    /**
     * 请求用户授权获取年龄段.
     *
     * @returns HuaweiIdAuthParamsHelper
     */
    setAgeRange(): HuaweiIdAuthParamsHelper;
    /**
     * 授权配置中增加指定的Scope，请求用户授予scope指定的权限。
     *
     * @param scopes 授权Scope
     * @returns HuaweiIdAuthParamsHelper
     */
    setScopes(scopes: Set<Scope>): HuaweiIdAuthParamsHelper;
    /**
     * 构建授权登录请求参数 HuaweiIdAuthParams
     *
     * @returns HuaweiIdAuthParams
     */
    build(): HuaweiIdAuthParams;
}
