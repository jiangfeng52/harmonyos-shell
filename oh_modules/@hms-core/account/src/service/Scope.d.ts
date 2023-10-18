/**
 * 描述一个OAuth 2.0的请求授权，对用户安全有影响，当请求授权时，会产生一个授权对话框
 */
export interface Scope {
    /**
     * 华为帐号业务授权域scope
     */
    scopeUri: string;
}
