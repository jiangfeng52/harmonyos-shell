import { HGlobalVariableManager } from '@hms-core/framework-base';
import { ISafetyChecker } from './ISafetyChecker';
import { QuickAppAdapter } from './QuickAppAdapter'
import { OHOSAbilityManager } from './../OHOSAbilityManager';

export class QuickAppClient {

    /***
     * 快引擎使用
     * 快引擎调用了该接口不需要再调用HMSClient的attachXX
     * 如果要调用HMSClient的attachXX，必须要在该接口之后调用
     */
    static init(context: any,  checker: ISafetyChecker): void {
        HGlobalVariableManager.set('hmscoreFramework', 'connectAbilityContext', context);
        HGlobalVariableManager.set('hmscoreFramework', 'xpsfJsTrigger', QuickAppAdapter.type);
        if (HGlobalVariableManager.get('hmscoreFramework', 'xpsfJsAdapter') === undefined) {
            HGlobalVariableManager.set('hmscoreFramework', 'xpsfJsAdapter', new QuickAppAdapter('OHOS Quick App Base Adapter', checker));
            HGlobalVariableManager.set('hmscoreFramework', 'abilityManager',
                new OHOSAbilityManager('OHOS AbilityManager'));
        }
    }

    /***
     * 设置快应用的AppId
     */
    static setSubId(subId: string) {
        HGlobalVariableManager.set('hmscoreFramework', 'subAppId', subId);
    }

}