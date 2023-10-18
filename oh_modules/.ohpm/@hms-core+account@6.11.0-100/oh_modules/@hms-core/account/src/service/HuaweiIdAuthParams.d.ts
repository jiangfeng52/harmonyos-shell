import { Permission } from "./Permission";
import { Scope } from "./Scope";
/**
 * 登录帐号的请求参数封装类
 */
export interface HuaweiIdAuthParams {
    /**
     * 帐号登录授权请求授权域.
     */
    readonly scopeArray: Scope[];
    /**
     * 帐号授权登录请求权限类.
     */
    readonly permissionArray: Permission[];
}
