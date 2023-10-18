/**
 * 帐号授权登录结果封装类
 */
export interface AccountAuthResult<T = string> {
    /**
     * 错误码
     */
    errCode: number;
    /**
     * 错误描述
     */
    errMsg: string;
    /**
     * 帐号授权信息
     */
    data?: T;
    /**
     * 预留的扩展字段
     */
    extra?: string;
}
