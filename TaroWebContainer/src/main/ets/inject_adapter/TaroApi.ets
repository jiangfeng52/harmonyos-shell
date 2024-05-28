
export interface CallbackResult {
  errMsg: string
}

export interface SuccessCallbackResult<T> {
  key: string
  data: T
  errMsg: string
}