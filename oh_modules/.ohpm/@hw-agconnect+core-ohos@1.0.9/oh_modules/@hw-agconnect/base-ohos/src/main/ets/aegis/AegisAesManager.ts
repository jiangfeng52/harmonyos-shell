import { RX_HEX } from '../crypto/Constant';
import { Preferences } from '../datastore/preference';
import { AegisRandom } from './AegisRandom';
import { AegisAes } from './AegisAes';
import { AesCrypto } from '../crypto/AesCrypto';
import { ICrypto } from '../crypto/ICrypto';
import { AsyncFactory, FakeSync } from '../util/FakeSync';
import { Logger } from '../log/logger';
import common from '@ohos.app.ability.common';

/**
 * 提供统一的默认AesCrypto，防止重复迭代消耗性能
 */
export class AegisAesManager {
  private static instance: AegisAesManager = new AegisAesManager();
  private static appContext: common.Context;

  private crypto: ICrypto | undefined;

  private constructor() {
  }

  static init(context: common.Context) {
    AegisAesManager.appContext = context;
  }

  public static getInstance(): AegisAesManager {
    return this.instance;
  }

  public async getDefaultAesCrypto(): Promise<ICrypto> {
    if (!AegisAesManager.appContext) {
      throw new Error('[AegisAesManager] context is null, please Invoke the {agconnect.instance().init(context)} method to initialize the AGC SDK.');
    }

    if (!this.crypto) {
      this.crypto = await FakeSync.createWithPromise(new DefaultAesCrypto(AegisAesManager.appContext))
    }
    return this.crypto;
  }
}

const FILE_NAME: string = 'AGC_DEFAULT_AES'
const KEY_RY_HEX: string = 'RY_HEX';
const KEY_RZ_HEX: string = 'RZ_HEX';
const KEY_SL_HEX: string = 'sl_HEX';

const KEY_LENGTH: number = 32;
const SALT_LENGTH: number = 16;
const ITERATION_COUNT: number = 1000;

export class DefaultAesCrypto implements AsyncFactory<AesCrypto> {
  private context: common.Context;

  constructor(context: common.Context) {
    this.context = context;
  }

  instanceName(): string {
    return 'DefaultAesCrypto';
  }

  async create(): Promise<AesCrypto> {
    Logger.info('DefaultAesCrypto', 'create start');
    let rxHex = RX_HEX;
    let ryHex = await Preferences.get(this.context, FILE_NAME, KEY_RY_HEX);
    let rZHex = await Preferences.get(this.context, FILE_NAME, KEY_RZ_HEX);
    let slHex = await Preferences.get(this.context, FILE_NAME, KEY_SL_HEX);
    if (!isValid(ryHex, KEY_LENGTH * 2) || !isValid(rZHex, KEY_LENGTH * 2) || !isValid(slHex, SALT_LENGTH * 2)) {
      ryHex = await AegisRandom.generatedRandomHex(KEY_LENGTH);
      rZHex = await AegisRandom.generatedRandomHex(KEY_LENGTH);
      slHex = await AegisRandom.generatedRandomHex(SALT_LENGTH);
      await Preferences.put(this.context, FILE_NAME, KEY_RY_HEX, ryHex);
      await Preferences.put(this.context, FILE_NAME, KEY_RZ_HEX, rZHex);
      await Preferences.put(this.context, FILE_NAME, KEY_SL_HEX, slHex);
    }
    let aesKey = await AegisAes.buildKey(rxHex, ryHex, rZHex, slHex, ITERATION_COUNT);
    Logger.info('DefaultAesCrypto', 'create end');
    return new AesCrypto(aesKey);
  }
}

function isValid(hex: string, length: number) {
  if (hex && hex.length == length) {
    return true;
  }
  return false;
}
