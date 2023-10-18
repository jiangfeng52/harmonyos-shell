import http from '@ohos.net.http';

export class Http {
  static sendRequest(url: string, method: Method, data: HttpData, option?: HttpOptions): Promise<HttpResponse> {
    let connectTimeout = option?.connectTimeout ? option?.connectTimeout : 60000;
    let readTimeout = option?.readTimeout ? option?.readTimeout : 60000;
    let httpRequest = http.createHttp();
    let ohosOptions = {
      method: method as http.RequestMethod,
      header: data?.header,
      extraData: data?.body,
      connectTimeout: connectTimeout,
      readTimeout: readTimeout,
    };
    return new Promise((resolve, reject) => {
      httpRequest.request(url, ohosOptions).then(data => {
        resolve(data);
      }).catch(err => {
        httpRequest.destroy();
        reject(err);
      })
    });
  }
}

export type Method = 'GET' | 'POST' | 'PUT' | 'DELETE';

export interface HttpData {
  header?: Object,
  body?: Object,
}

export interface HttpOptions {
  readTimeout?: number;
  connectTimeout?: number;
}

export interface HttpResponse {
  result?: any,
  responseCode: number,
  header: Object
}


