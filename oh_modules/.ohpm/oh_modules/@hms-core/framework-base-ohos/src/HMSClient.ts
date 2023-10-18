import UIAbility from '@ohos.app.ability.UIAbility';
import { OHOSAdapter } from './OHOSAdapter';
import { OHOSAbilityManager } from './OHOSAbilityManager';
import { HGlobalVariableManager } from '@hms-core/framework-base';
import { HMSLogger } from './HMSLogger';
import common from '@ohos.app.ability.common';

export class HMSClient {

    /**
     * 连接CP当前Ability上下文，在需要使用HMS Core能力前，需要确保已调用该接口。
     * @param {Context} Context 传入Ability实例的Context。
     */
    static attachAbilityContext(abilityContext: common.Context): void {
        HMSLogger.info(HMSLogger.DEFAULT_TAG, 'HMSClient attachAbilityContext.');
        HGlobalVariableManager.set('hmscoreFramework', 'connectAbilityContext', abilityContext);
        
        HGlobalVariableManager.set('hmscoreFramework', 'xpsfJsTrigger', OHOSAdapter.type);
        if (HGlobalVariableManager.get('hmscoreFramework', 'xpsfJsAdapter') === undefined) {
            HGlobalVariableManager.set('hmscoreFramework', 'xpsfJsAdapter', new OHOSAdapter('OHOS Base Adapter'));
            HGlobalVariableManager.set('hmscoreFramework', 'abilityManager',
                new OHOSAbilityManager('OHOS AbilityManager'));
        }
    }

    /**
     * 分离CP指定的Ability上下文，在不在需要使用HMS Core能力后，需要调用该接口。
     * @param {Context} Context 传入Ability实例的Context。
     */
    static detachAbilityContext(abilityContext: common.Context): void {
        if (HGlobalVariableManager.get('hmscoreFramework', 'connectAbilityContext') === abilityContext) {
            HGlobalVariableManager.set('hmscoreFramework', 'connectAbilityContext', undefined);
        } else {
            HMSLogger.warn(HMSLogger.DEFAULT_TAG, 'HMSClient detachAbilityContext fail.');
        }
    }

    /**
     * 连接UIAbility
     * @param uiAbility UIAbility
     */
    static attachAbility(uiAbility: UIAbility): void {
        HMSLogger.info(HMSLogger.DEFAULT_TAG, 'HMSClient attachAbility.');
        this.attachAbilityContext(uiAbility.context);
        HGlobalVariableManager.set('hmscoreFramework', 'calleeAbility', uiAbility);
    }

    /**
     * 分离UIAbility
     * @param uiAbility UIAbility
     */
    static detachAbility(uiAbility: UIAbility): void {
        if (HGlobalVariableManager.get('hmscoreFramework', 'calleeAbility') === uiAbility) {
            this.detachAbilityContext(uiAbility.context);
            HGlobalVariableManager.set('hmscoreFramework', 'calleeAbility', undefined);
        } else {
            HMSLogger.warn(HMSLogger.DEFAULT_TAG, 'HMSClient detachAbility fail.');
        }
    }
}