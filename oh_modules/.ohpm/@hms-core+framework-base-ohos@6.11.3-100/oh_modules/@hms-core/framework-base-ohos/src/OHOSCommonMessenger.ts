import { HGlobalVariableManager } from '@hms-core/framework-base';
import { HMSLogger } from './HMSLogger';

/**
 * 消息通知数据模型
 */
class OHOSMessengerSequenceable {
  text: string = '';

  constructor(str: string) {
    this.text = str;
  }

  marshalling(messageParcel): boolean {
      messageParcel.writeString(this.text);
      return true;
  }

  unmarshalling(messageParcel): boolean {
      this.text = messageParcel.readString();
      return true;
  }
}

export class OHOSCommonMessenger {
  static on(method: string, callback: (data: string) => string | void) {
    HMSLogger.info(HMSLogger.DEFAULT_TAG, `on ${method}`);

    const ability = HGlobalVariableManager.get('hmscoreFramework', 'calleeAbility');
    if (ability) {
      try {
        ability.callee.on(method, (data) => {
          const receivedData = new OHOSMessengerSequenceable('');
          data.readParcelable(receivedData);
          const result = callback(receivedData.text) || '';
          HMSLogger.info(HMSLogger.DEFAULT_TAG, `${method} return result: ${result}`);
          return new OHOSMessengerSequenceable(result);
        });
      } catch (error) {
        HMSLogger.error(HMSLogger.DEFAULT_TAG, `${method} on failed with error: ${error}`)
      }
    } else {
      HMSLogger.error(HMSLogger.DEFAULT_TAG, 'No ability attached, please call HMSClient.attachAbility');
    }
  }
  
  static off(method: string) {
    HMSLogger.info(HMSLogger.DEFAULT_TAG, `off ${method}`);
    const ability = HGlobalVariableManager.get('hmscoreFramework', 'calleeAbility');
    if (ability) {
      try {
        ability.callee.off(method);
      } catch (error) {
        HMSLogger.error(HMSLogger.DEFAULT_TAG, `${method} off failed with error: ${error}`)
      }  
    } else {
      HMSLogger.error(HMSLogger.DEFAULT_TAG, 'No ability attached, please call HMSClient.attachAbility');
    }
  }
}