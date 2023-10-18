export class AGCError extends Error {
  code: number;
  message: string;

  constructor(code: number, message: string) {
    super();
    this.code = code;
    this.message = message;
    (this as any).__proto__ = AGCError.prototype;
  }
}

export class AGCErrorCode {
  static readonly AGC_INIT_ERROR: number = 10000;
  static readonly AGC_JSON_FILE_ERROR: number = 10001;
  static readonly AGC_HTTP_ERROR: number = 10002;
}