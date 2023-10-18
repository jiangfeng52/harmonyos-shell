import { Scope } from "./Scope";
/**
 * 登录的帐号信息，包含ID、显示名称、头像URI、权限、idToken等信息
 */
export interface AuthAccount {
    /**
     * ID token
     */
    readonly idToken?: string;
    /**
     * 服务器授权码.
     */
    readonly serverAuthCode?: string;
    /**
     * 帐号信息中已经授权的Scope.
     */
    readonly authorizedScopes?: Scope[];
    /**
     * 帐号昵称.
     */
    readonly displayName?: string;
    /**
     * 帐号头像uri
     */
    readonly avatarUri?: string;
    /**
     * 邮箱.
     */
    readonly email?: string;
    /**
     * 性别
     */
    readonly gender?: number;
    /**
     * 年龄段
     */
    readonly ageRange?: string;
    /**
     * 用户ID，帐号的唯一标识，全平台唯一.
     */
    readonly uid?: string;
    /**
     * 同一个用户，不同应用，openId值不同
     */
    readonly openId?: string;
    /**
     * 同一个用户，同一个开发者帐号下管理的不同应用，unionId相同.
     */
    readonly unionId?: string;
    /**
     * 扩展信息
     */
    readonly extraInfo?: string;
}
