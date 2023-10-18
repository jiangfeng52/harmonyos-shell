import { OHOSAdapter } from './../OHOSAdapter';
import { ISafetyChecker } from './ISafetyChecker'
import { HHeader, HError, ErrorCode, HGlobalVariableManager } from '@hms-core/framework-base'

export class QuickAppAdapter extends OHOSAdapter {
    private subAppIdChecker : ISafetyChecker;
    private subAppId: string = undefined;

    constructor(name: string, checker: ISafetyChecker) {
        super(name);
        this.subAppIdChecker = checker;
    }

    async getSubAppId() {
        const newSubAppId = HGlobalVariableManager.get('hmscoreFramework', 'subAppId');
        if (this.subAppId === newSubAppId) {
            return this.subAppId;
        }

        if (newSubAppId) {
            if (!this.subAppIdChecker) {
                throw new HError(ErrorCode.SUBAPP_CHECKER_NOT_EXIST, "sub app id exist, but checker is null");
            }
            try {
                await this.subAppIdChecker(newSubAppId, []);
                this.subAppId = newSubAppId; // 检验成功赋值subAppId
            } catch(error) {
                throw new HError(ErrorCode.SUBAPP_AUTH_ERROR, "check sub app id fail :" + JSON.stringify(error));
            }
        }
        return this.subAppId;
    }

    async createHeader(param: any): Promise<HHeader> {
        let iId: string = param?.iId;
        if (iId == undefined) {
            iId = "";
        }

        const header = await super.createHeader({iId});
        header.subAppId = await this.getSubAppId();
        return header;
    }
}