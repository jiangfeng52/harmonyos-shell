import { AGCInstance, AGConnectServicesConfig } from '../../../types'
import { DEFAULT_CATEGORY } from '@hw-agconnect/api-ohos'
import { ServiceRepository } from '@hw-agconnect/api-ohos'
import { AGCError, AGCErrorCode } from "./AGCError";
import { AegisAesManager, Logger } from '@hw-agconnect/base-ohos';
import { ServicesConfigImpl } from './ServicesConfigImpl';
import common from '@ohos.app.ability.common';

const TAG: string = "AGCInstanceImpl";

class AGCInstanceImpl implements AGCInstance {
  repo: ServiceRepository;
  identifier: string;

  private _servicesConfig!: AGConnectServicesConfig;
  private _appContext: any = null;

  constructor(repo: ServiceRepository, identifier?: string) {
    this.repo = repo;
    this.identifier = identifier ? identifier : DEFAULT_CATEGORY;
    Logger.info('AGCInstanceImpl', 'constructor name:' + identifier);
  }

  init(applicationContext: common.Context, config?: any): AGCInstance {
    this._appContext = applicationContext;
    AegisAesManager.init(applicationContext);
    this._servicesConfig = new ServicesConfigImpl(applicationContext, config);
    return this;
  }

  async getConfig(): Promise<AGConnectServicesConfig> {
    this.checkSDKInited();
    if ((this._servicesConfig as ServicesConfigImpl).isInited()) {
      return Promise.resolve(this._servicesConfig);
    }
    await (this._servicesConfig as ServicesConfigImpl).getConfigFromResources();
    return Promise.resolve(this._servicesConfig);
  }

  getContext() {
    this.checkSDKInited();
    return this._appContext;
  }

  name(): string {
    return this.identifier;
  }

  async getRoutePolicy(): Promise<number> {
    return (await this.getConfig()).getRoutePolicy();
  }

  setRoutePolicy(routePolicy: number) {
    this.checkSDKInited();
    this._servicesConfig.setRoutePolicy(routePolicy);
  }

  async getApiKey(): Promise<string> {
    return (await this.getConfig()).getApiKey();
  }

  setApiKey(apiKey: string): void {
    this.checkSDKInited();
    this._servicesConfig.setApiKey(apiKey);
  }

  async getClientSecret(): Promise<string> {
    return (await this.getConfig()).getClientSecret();
  }

  setClientSecret(clientSecret: string): void {
    this.checkSDKInited();
    this._servicesConfig.setClientSecret(clientSecret);
  }

  getService<T>(name: string): T | null {
    return this.repo.getService(name, this, this.identifier);
  }

  async getGwUrl(): Promise<string> {
    return (await this.getConfig() as ServicesConfigImpl).getGwUrl(await this.getRoutePolicy());
  }

  async getGwBackUrl(): Promise<string> {
    return (await this.getConfig() as ServicesConfigImpl).getGwBackUrl(await this.getRoutePolicy());
  }

  private checkSDKInited(): void {
    if (this._appContext == null) {
      throw new AGCError(AGCErrorCode.AGC_INIT_ERROR,
        "AGCInstance not inited. call agconnect.instance().init() to init the agconnect sdk.");
    }
  }
}

export { AGCInstanceImpl }

