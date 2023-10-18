import { Aaid } from "../../../types";
import { Preferences } from "@hw-agconnect/base-ohos";
import agconnect from "@hw-agconnect/api-ohos";

const STORAGE_AAID_FILE: string = "ohos_agconnect_aaid_file";
const STORAGE_AAID_KEY: string = "ohos_agconnect_aaid_key";

export class AaidImpl implements Aaid {
  private aaid: string = '';

  constructor() {
  }

  async getAaid(): Promise<string> {
    if (this.aaid != "") {
      return this.aaid;
    }

    let context = agconnect.instance().getContext();
    let storageAaid = await Preferences.get(context, STORAGE_AAID_FILE, STORAGE_AAID_KEY);
    if (storageAaid != '') {
      this.aaid = storageAaid;
      return Promise.resolve(this.aaid);
    }

    this.aaid = this.getRandomString();
    await Preferences.put(context, STORAGE_AAID_FILE, STORAGE_AAID_KEY, this.aaid);
    return Promise.resolve(this.aaid);
  }

  // 随机字符串生成算法，可生成指定长度的随机字符串，并可以指定字符范围
  private getRandomString(): string {
    let scope = '0123456789abcdef';
    let maxLength = scope.length;
    let resultStr = 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx';

    return resultStr.replace(/x/g, () => {
      return scope.charAt(Math.floor(Math.random() * maxLength));
    })
  }
}