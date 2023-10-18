import { Logger } from "@hw-agconnect/base-ohos";
import { AGConnectServicesConfig } from "../../../types";
import { AGCRoutePolicy } from "../../../index";
import { AGCError, AGCErrorCode } from "./AGCError";
import { replace } from "./ConfigFileParser";
import { DecryptExclamationMark } from "./DecryptExclamationMark";

const JSON_FILE_NAME = "agconnect-services.json";
const TAG = "ServicesConfigImpl";

export class ServicesConfigImpl implements AGConnectServicesConfig {
  agcgw: any;
  agcgw_all?: any;
  client: any;
  service: any;
  oauth_client?: any;
  app_info?: any;
  region?: string | undefined;
  configuration_version?: string | undefined;
  [string: string]: any;

  private configInited = false;

  private config: any;
  private appContext: any = null;

  private routePolicy: number = AGCRoutePolicy.UNKNOWN;
  private clientSecret: string = '';
  private apiKey: string = '';

  private decryptMark: DecryptExclamationMark | undefined;

  constructor(context: any, config?: any) {
    this.appContext = context;
    if (config) {
      this.config = config;
      this.replaceConfig();
    }
  }

  async getString(path: string): Promise<string> {
    let value = this.getValueFromPath(path);
    if (DecryptExclamationMark.isMatch(value)) {
      if (!this.decryptMark) {
        this.decryptMark = new DecryptExclamationMark(this.config['code']['code1'],
          this.config['code']['code2'], this.config['code']['code3'], this.config['code']['code4']);
      }
      let decrypt = await this.decryptMark.decrypt(value);
      if (decrypt) {
        return decrypt;
      }
    }
    return value;
  }

  isInited(): boolean {
    return this.configInited;
  }

  private getValueFromPath(path: string) {
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    if (path.endsWith("/")) {
      path = path.substring(0, path.length - 1);
    }

    let array = path.split('/');
    let value = this.config;
    for (let key in array) {
      value = value[array[key]];
    }
    return value;
  }

  async getClientSecret(): Promise<string> {
    if (this.clientSecret) {
      return this.clientSecret;
    }
    this.clientSecret = await this.getString('/client/client_secret');
    return this.clientSecret;
  }

  setClientSecret(clientSecret: string) {
    this.clientSecret = clientSecret;
  }

  async getApiKey(): Promise<string> {
    if (this.apiKey) {
      return this.apiKey;
    }
    this.apiKey = await this.getString('/client/api_key');
    return this.apiKey;
  }

  setApiKey(apiKey: string) {
    this.apiKey = apiKey;
  }

  getRoutePolicy(): number {
    if (this.routePolicy != AGCRoutePolicy.UNKNOWN) {
      return this.routePolicy;
    }
    let region = this.config.region;
    switch (region) {
      case "CN":
        this.routePolicy = AGCRoutePolicy.CHINA;
        break;
      case "GE":
        this.routePolicy = AGCRoutePolicy.GERMANY;
        break;
      case "RU":
        this.routePolicy = AGCRoutePolicy.RUSSIA;
        break;
      case "SG":
        this.routePolicy = AGCRoutePolicy.SINGAPORE;
        break;
      default:
        this.routePolicy = AGCRoutePolicy.UNKNOWN;
        break;
    }
    return this.routePolicy;
  }

  setRoutePolicy(routePolicy: number): void {
    this.routePolicy = routePolicy;
  }

  async getConfigFromResources(): Promise<void> {
    let value = await this.appContext.resourceManager.getRawFile(JSON_FILE_NAME);
    let json = "";
    for (var i = 0; i < value.length; i++) {
      json += String.fromCharCode(value[i]);
    }
    this.config = JSON.parse(json);
    if (this.config != null) {
      Logger.info(TAG, "get config from raw file success.");
      this.replaceConfig();
      return Promise.resolve();
    }
    return Promise.reject(new AGCError(AGCErrorCode.AGC_INIT_ERROR, "read config from rawfile error"));
  }

  getGwUrl(routePolicy: number): string {
    if (!this.config.agcgw_all && !this.config.agcgw) {
      throw new AGCError(AGCErrorCode.AGC_JSON_FILE_ERROR, "agconnect-services.json do not contain 'agcgw_all' & 'agcgw' ");
    }

    let url;
    switch (routePolicy) {
      case AGCRoutePolicy.CHINA:
        url = this.config.agcgw_all.CN;
        break;
      case AGCRoutePolicy.GERMANY:
        url = this.config.agcgw_all.DE;
        break;
      case AGCRoutePolicy.RUSSIA:
        url = this.config.agcgw_all.RU;
        break;
      case AGCRoutePolicy.SINGAPORE:
        url = this.config.agcgw_all.SG;
        break;
      default:
        url = this.config.agcgw.url;
        break;
    }
    return this.addHttpToUrl(url);
  }

  getGwBackUrl(routePolicy: number): string {
    if (!this.config.agcgw_all && !this.config.agcgw) {
      throw new AGCError(AGCErrorCode.AGC_JSON_FILE_ERROR, "agconnect-services.json do not contain 'agcgw_all' & 'agcgw' ");
    }

    let url;
    switch (routePolicy) {
      case AGCRoutePolicy.CHINA:
        url = this.config.agcgw_all.CN_back;
        break;
      case AGCRoutePolicy.GERMANY:
        url = this.config.agcgw_all.DE_back;
        break;
      case AGCRoutePolicy.RUSSIA:
        url = this.config.agcgw_all.RU_back;
        break;
      case AGCRoutePolicy.SINGAPORE:
        url = this.config.agcgw_all.SG_back;
        break;
      default:
        url = this.config.agcgw.backurl;
        break;
    }
    return this.addHttpToUrl(url);
  }

  private addHttpToUrl(url: string) {
    const HTTP_HEADER = 'https://';
    return (url && !url.startsWith(HTTP_HEADER)) ? HTTP_HEADER + url : url;
  }

  private replaceConfig(): void {
    let packageName = this.appContext.applicationInfo?.name;
    this.config = replace(packageName, this.config);
    this.initProperties();
    this.configInited = true;
  }

  private initProperties() {
    for (let key in this.config) {
      this[key] = this.config[key];
    }
  }

}