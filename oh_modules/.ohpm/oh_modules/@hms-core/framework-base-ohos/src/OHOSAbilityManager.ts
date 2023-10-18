import { HServiceManager, PageInfo, HError, ErrorCode } from '@hms-core/framework-base';
import { OHOSAppInfo } from './OHOSAppInfo';
import { HGlobalVariableManager } from '@hms-core/framework-base';
import { HMSLogger } from './HMSLogger';

/**
 * 功能描述  页面管理服务
 *
 * @author x00521202
 * @since 2022/4/14
 */

export class OHOSAbilityManager {

    name: string;

    constructor(name: string) {
        HMSLogger.info(HMSLogger.DEFAULT_TAG, 'OHOSAbilityManager constructor');
        this.name = name;
    }

    startAbilityForResult(pageInfo: PageInfo, pageContext?: any, options?: any): Promise<any> {
        return new Promise((success, fail) => {
            if (!HServiceManager.mSupprotAdapters['ohos.base']) {
                HServiceManager.init()
            }
            let context;
            if (pageContext == undefined) {
                HMSLogger.info(HMSLogger.DEFAULT_TAG, 'OHOSAbilityManager get pageContext from CP');
                context = HGlobalVariableManager.get('hmscoreFramework', 'connectAbilityContext');
            } else {
                HMSLogger.info(HMSLogger.DEFAULT_TAG, 'OHOSAbilityManager get pageContext from current page');
                context = pageContext;
            }
            HServiceManager.mSupprotAdapters['ohos.base']().createHeader({}).then((header) => {
                let startAbilityParameter
                if(pageInfo.packageName == "") {
                    HMSLogger.info(HMSLogger.DEFAULT_TAG, 'OHOSAbilityManager no correct abilityInfo,bundleName is empty');
                    fail(new HError(ErrorCode.ARGUMENTS_INVALID, "no correct abilityInfo"))
                    return;
                }

                startAbilityParameter = {
                    bundleName: pageInfo.packageName,
                    abilityName: pageInfo.pageName,
                    action: pageInfo.action,
                    parameters: {
                        "hms_clientId": header['appid'],
                        "hms_subClientId": header['subAppId'],
                        "hms_extra": pageInfo.extra
                    }
                };

                if (context?.abilityInfo != undefined) {
                    HMSLogger.info(HMSLogger.DEFAULT_TAG, `OHOSAbilityManager startAbilityForResult AbilityContext ${context?.abilityInfo?.name}`);
                } else if (context?.extensionAbilityInfo != undefined) {
                    HMSLogger.info(HMSLogger.DEFAULT_TAG, `OHOSAbilityManager startAbilityForResult ServiceExtensionContext ${context?.extensionAbilityInfo?.name}`);
                }
                try {
                    context.startAbilityForResult(startAbilityParameter, options).then(abilityResult => {
                        const code = abilityResult.resultCode;
                        HMSLogger.info(HMSLogger.DEFAULT_TAG, 'OHOSAbilityManager startAbility result code = ' + code);
                        if (code != 10001) {
                            success(abilityResult)
                        } else {
                            fail(new HError(abilityResult.resultCode, abilityResult.want.parameters.reason))
                        }
                    }).catch(error => {
                        HMSLogger.error(HMSLogger.DEFAULT_TAG, `OHOSAbilityManager startAbilityForResult failed with unKnow error: ${JSON.stringify(error, Object.getOwnPropertyNames(error))}`);
                        fail(new HError(ErrorCode.INTERNAL_ERROR, "unKnow reason"))
                    });
                } catch (error) {
                    HMSLogger.error(HMSLogger.DEFAULT_TAG, `start ability for result expection: ${JSON.stringify(error, Object.getOwnPropertyNames(error))}`);
                    fail(new HError(ErrorCode.INTERNAL_ERROR, "unKnow reason"))
                  }
            })
        })

    }
}