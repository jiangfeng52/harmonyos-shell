import { 
    HBaseAdapter, HObject, HParcel, HHeader, HError, ErrorCode, 
    AvailableCode, HServiceRegistryInfo, HGlobalVariableManager 
} from '@hms-core/framework-base';
import rpc from "@ohos.rpc";
import process from '@ohos.process';
import { OHOSCallbackObject } from './OHOSCallbackObject';
import { HObjectWrapper } from './OHOSHObjectWrapper';
import { OHOSPreferences } from './OHOSPreferences';
import { OHOSAppInfo } from './OHOSAppInfo';
import { OHOSCommonMessenger } from './OHOSCommonMessenger';
import { HMSLogger } from './HMSLogger';

// 远程binder
const CONNECT_LOCAL_PARAMS = {
    bundleName: 'com.huawei.hms.hmscore',
    abilityName: 'CoreServiceAbility',
};

// 连接超时时间
const HMSCORE_CONNECT_TIMEOUT: number = 20 * 1000;

// 连接状态 - 断开
const STATUS_DISCONNECT: number = 0;
// 连接状态 - 连接中
const STATUS_CONNECTING: number = 1;
// 连接状态 - 已连接
const STATUS_CONNECTED: number = 2;
// OHOS RPC调用服务端挂掉错误码
const OHOS_ERROR_CODE_SERVICE_DIED: number = 29189;
// HMS Core定义服务端挂掉错误码
const HMS_CORE_SERVICE_PROCESS_DIED: number = 907180020;

/**
 * 连接回调对象
 */
interface ClientCallback {
    /**
     * 成功回调
     */
    resolve: (value: HObject) => void;

    /**
     * 失败回调
     */
    reject: (error: HError | Error) => void;

    /**
     * 服务信息
     */
    registryInfo: HServiceRegistryInfo, 

    /**
     * 接口id
     */
    iId: string
}

/**
 * OpenHarmony Adapter
 */
export class OHOSAdapter extends HBaseAdapter {
    
    // 传输type定义
    static type: string = 'ohos.base';

    name: string;

    // 连接状态
    private connectStatus: number = STATUS_DISCONNECT;
    // 等待队列
    private waitQueues: ClientCallback[] = [];
    // 连接对象
    private remoteObj: rpc.IRemoteObject = undefined;

    // hObject跨进程通信包装对象缓存
    private remoteObjects: Map<string, HObjectWrapper> = new Map<string, HObjectWrapper>();
    // 连接标识符
    private connectFlag: number;

    // 配置管理实例
    private preferences: OHOSPreferences;
    // app信息管理实例
    private appinfo: OHOSAppInfo;
    // 事物自增变量
    private transactCode = 0;
    // 通信协议版本
    private protocolVersion = 2;

    constructor(name: string) {
        super();
        HMSLogger.info(HMSLogger.DEFAULT_TAG, 'OHOSAdapter constructor');
        this.name = name;
    }


    /**
     * 获取远端对象
     * @param {Object} registryInfo 注册信息
     * @param {String} iId 接口ID
     * @returns {Promise} class被包装成HObject返回
     */
    hGetClassObject(registryInfo: HServiceRegistryInfo, iId: string): Promise<HObject> {
        HMSLogger.info(HMSLogger.DEFAULT_TAG, `hGetClassObject connection status = ${this.connectStatus}`);
        if (this.connectStatus === STATUS_CONNECTED) {    // 已连接
            // TODO：这里后面需要考虑CP重启、Core重启以及连接断开时的处理，增加连接监听功能。
            return this.requestService(registryInfo, iId);
        } else if (this.connectStatus === STATUS_CONNECTING) { // 连接中
            return new Promise((resolve, reject) => {
                this.waitQueues.push({ resolve, reject, registryInfo, iId});
            });
        } else { // 未连接
            this.connectStatus = STATUS_CONNECTING;
            // 连接HMS Core进程拿对应Service
            return new Promise((resolve, reject) => {
                const context = HGlobalVariableManager.get('hmscoreFramework', 'coreServiceAbilityContext') || HGlobalVariableManager.get('hmscoreFramework', 'connectAbilityContext');
                if (!context) {
                    reject(new HError(ErrorCode.INTERNAL_ERROR, 'adapter uninitialized.'));
                }
                this.waitQueues.push({ resolve, reject, registryInfo, iId });

                if (context?.abilityInfo != undefined) {
                    HMSLogger.info(HMSLogger.DEFAULT_TAG, `OHOSAdapter connectAbility AbilityContext ${context?.abilityInfo?.name}`);
                } else if (context?.extensionAbilityInfo != undefined) {
                    HMSLogger.info(HMSLogger.DEFAULT_TAG, `OHOSAdapter connectAbility ServiceExtensionContext ${context?.extensionAbilityInfo?.name}`);
                }

                context.connectServiceExtensionAbility(CONNECT_LOCAL_PARAMS, {
                    onConnect: this.onConnectCallback.bind(this),
                    onDisconnect: this.onDisconnectCallback.bind(this),
                    onFailed: this.onFailedCallback.bind(this),
                });
                this.connectTimeoutHandle();
            }); 
        }
    }

    private padStart(str: string, length: number, fill: string): string {
        if (str.length === length) {
            return str;
        } else if (str.length < length) {
            return (new Array(length - str.length)).fill(fill).join('') + str;
        } else {
            return str.substring(str.length - length);
        }
    }

    /**
     * 
     * @param appid appid
     * @param iId iid
     * @returns 9位appid + iid + 自增量 + 17位时间 + 6位随机
     */
    private createTransactId(appid: string = '', iId: string = ''): string {
        const temp: Array<string> = new Array(10);
        temp[0] = this.padStart(appid, 9, '0');
        temp[1] = iId + (this.transactCode++);
        const date = new Date();
        temp[2] = `${date.getFullYear()}`;
        temp[3] = this.padStart(`${date.getMonth() + 1}`, 2, '0');
        temp[4] = this.padStart(`${date.getDay()}`, 2, '0');
        temp[5] = this.padStart(`${date.getHours()}`, 2, '0');
        temp[6] = this.padStart(`${date.getMinutes()}`, 2, '0');
        temp[7] = this.padStart(`${date.getSeconds()}`, 2, '0');
        temp[8] = this.padStart(`${date.getMilliseconds()}`, 3, '0');
        temp[9] = this.padStart(`${Math.random() * 999999}`, 6, '0');
        return temp.join('');
    }

    /**
     * 创建Header
     */
    async createHeader(param: any): Promise<HHeader> {
        let iId: string = param?.iId;
        if (iId == undefined) {
            HMSLogger.warn(HMSLogger.DEFAULT_TAG, `createHeader iId is undefined`);
            iId = "";
        }

        HMSLogger.info(HMSLogger.DEFAULT_TAG, `createHeader iId = ${iId}`);
        const header = new HHeader(this.protocolVersion);
        header.appid = await this.getAppInfoManager().getAppId();
        header.packageName = await this.getAppInfoManager().getPackageName();
        header.transactId = this.createTransactId(header.appid, iId);
        header.callingUid = process.uid.toString();
        return header;
    }

    private sendAsyncRequest(data: rpc.MessageSequence, reply: rpc.MessageSequence, option: rpc.MessageOption): Promise<rpc.MessageSequence> {
        return new Promise((resolve) => {
            HMSLogger.info(HMSLogger.DEFAULT_TAG, 'sendAsyncRequest.');
	        // 采用客户端uid作为callback的Descriptor供对端使用可避免ROM第一次获取callinguid不准问题
            const callbackObject: OHOSCallbackObject = new OHOSCallbackObject(process.uid.toString());
            // 远端对象回调
            callbackObject.onRemoteRequest = (remoteCode: number, remoteData: rpc.MessageSequence, remoteReply: rpc.MessageSequence, remoteOption: rpc.MessageOption): boolean => {
                HMSLogger.info(HMSLogger.DEFAULT_TAG, `callback success. code = ${remoteCode}`);
                resolve(remoteData);
                return true;
            }
            // 写回调对象
            data.writeRemoteObject(callbackObject);

            this.remoteObj.sendMessageRequest(1, data, reply, option);
        });
    }

    private createHErrorCode(status: number, statusMsg: string): HError {
        for (let p in ErrorCode) {
            if (ErrorCode.hasOwnProperty(p) && Number(ErrorCode[p]) === status) {
                return new HError(status, statusMsg);
            }
        }
        return new HError(ErrorCode.NAMING_INVALID, 'send request fail.');
    }

    /**
     * request Service
     * @param resolve
     * @param registryInfo
     */
    async requestService(registryInfo: HServiceRegistryInfo, iId: string): Promise<HObject> {
        HMSLogger.info(HMSLogger.DEFAULT_TAG, 'requestService.');
        const option: rpc.MessageOption = new rpc.MessageOption(1);
        option.setFlags(1); // ohos 构造函数设置TF_ASYNC无效,用flag设置
        const data: rpc.MessageSequence = rpc.MessageSequence.create();
        const reply: rpc.MessageSequence = rpc.MessageSequence.create();
        // 写header
        const dataParcel: HParcel = new HParcel();
        const requestHeader: HHeader = await this.createHeader({ iId });
        dataParcel.writeHeader(requestHeader);
        HMSLogger.info(HMSLogger.DEFAULT_TAG, `send info: mSId=${registryInfo.mSId}, mProgId=${registryInfo.mProgId} iId=${iId} mApiLevel=${registryInfo.mApiLevel}`);
        // 写request内容
        dataParcel.writeString(1, registryInfo.mSId);
        dataParcel.writeString(2, registryInfo.mProgId);
        dataParcel.writeString(3, iId);
        dataParcel.writeInt(4, registryInfo.mApiLevel);
        const bytes: Uint8Array = dataParcel.getWriterBuffer();
        data.writeByteArray([...bytes]);
        // 告诉HMS Core去拿对应的HObject
        const callbackReply: rpc.MessageSequence = await this.sendAsyncRequest(data, reply, option);
        data.reclaim();
        reply.reclaim();
        const status: number = callbackReply.readInt();
        HMSLogger.info(HMSLogger.DEFAULT_TAG, `reply status = ${status}`);
        const statusMsg: string = callbackReply.readString();
        HMSLogger.info(HMSLogger.DEFAULT_TAG, `reply statusMsg = ${statusMsg}`);
        if (status !== 0) {
            const error: HError = this.createHErrorCode(status, statusMsg);
            error.setData({ status, statusMsg });
            throw error;
        } else {
            const hObject: HObject = new HObject();
            hObject.mAdapter = this;
            hObject.mId = callbackReply.readString();
            hObject.mRemoteStub = callbackReply.readRemoteObject();
            hObject['iId'] = iId;
            return hObject;
        }
    }

    /**
     * 远程调用
     * @param {HObject} hObject 远程对象
     * @param {Number} code 方法序号
     * @param {HParcel} hParcel 数据
     * @returns {Promise} 调用成功后返回HParcel对象
     */
    async transact(hObject: HObject, code: number, hParcel: HParcel): Promise<HParcel> {
        HMSLogger.info(HMSLogger.DEFAULT_TAG, `OHOSAdapter transact code = ${code}`);
        const option: rpc.MessageOption = new rpc.MessageOption(1);
        option.setFlags(1);
        const data: rpc.MessageSequence = rpc.MessageSequence.create();
        const reply: rpc.MessageSequence = rpc.MessageSequence.create();
        const bytes: Uint8Array = hParcel.getWriterBuffer();

        // 写hParcel流数据
        data.writeInt(bytes.length);
        if (bytes.length > 0) {
            data.writeRawData([...bytes], bytes.length);
        }

        const hObjectsLen: number = hParcel.getHObjectIds().length;

        // 写HParcel上携带的HObject数量
        data.writeInt(hObjectsLen);

        // 写需要传递的remoteObject
        if (hObjectsLen > 0) {
            const writeHObjectIds: string[] = hParcel.getHObjectIds();
            const remoteObjectArray: HObjectWrapper[] = [];
            for (let i = 0; i < writeHObjectIds.length; i++) {
                // 从缓存中根据id取出并填入数组
                remoteObjectArray[i] = this.remoteObjects[writeHObjectIds[i]];
            }

            data.writeRemoteObjectArray(remoteObjectArray);
        }

        const callbackResp: rpc.MessageSequence = await this.asyncTransact(code, data, reply, option, hObject);
        const replyDataLength: number = callbackResp.readInt();
        const replyData: number[] = callbackResp.readRawData(replyDataLength);
        const parcel: HParcel = new HParcel().setReaderBuffer(replyData);
        parcel.mAdapter = this;

        data.reclaim();
        reply.reclaim();
        return parcel;
    }

    private asyncTransact(code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence, option: rpc.MessageOption, hObject: HObject): Promise<rpc.MessageSequence> {
        return new Promise((resolve, reject) => {
            const callbackObject: OHOSCallbackObject = new OHOSCallbackObject('KitTransactCallback');
            // 远端对象回调
            callbackObject.onRemoteRequest = (remoteCode: number, remoteData: rpc.MessageSequence, remoteReply: rpc.MessageSequence, remoteOption: rpc.MessageOption): boolean => {
                HMSLogger.info(HMSLogger.DEFAULT_TAG, `callback success. code = ${remoteCode}`);
                // remoteCode 为0时表示失败，为1时表示成功，其他值是老版本hmscore传输过来的
                if (remoteCode === 0) {
                    const message: string = remoteData.readString();
                    const code: number = remoteData.readLong();
                    reject(new HError(code, message));
                } else if (remoteCode === 1) {
                    resolve(remoteData);
                } else {
                    HMSLogger.info(HMSLogger.DEFAULT_TAG, 'The versions of HMSCore and Adapter do not match.')
                    reject(new HError(AvailableCode.USER_ALREADY_KNOWS_SERVICE_UNAVAILABLE,
                        'The versions of HMSCore and Adapter do not match.'));
                }
                return true;
            }

            data.writeRemoteObject(callbackObject);

            HMSLogger.info(HMSLogger.DEFAULT_TAG, 'sendRequest begin');
            hObject.mRemoteStub.sendMessageRequest(code, data, reply, option).catch((error) => {
                HMSLogger.info(HMSLogger.DEFAULT_TAG, `OHOSAdapter asyncTransact error: ${JSON.stringify(error)}`);
                if (error.errCode == OHOS_ERROR_CODE_SERVICE_DIED) {
                    reject(new HError(HMS_CORE_SERVICE_PROCESS_DIED, "service process died"));
                }
                reject(error);
            });
        });
    }

    private onConnectCallback(elementName: any, remote: rpc.IRemoteObject): void {
        HMSLogger.info(HMSLogger.DEFAULT_TAG, 'OHOSAdapter connected.');
        this.remoteObj = remote;
        this.connectStatus = STATUS_CONNECTED;
        for (let i = 0; i < this.waitQueues.length; i++) {
            const { resolve, reject, registryInfo, iId } = this.waitQueues[i];
            this.requestService(registryInfo, iId).then(resolve, reject);
        }
        this.waitQueues = [];
    }

    private onDisconnectCallback(elementName: any): void {
        this.connectStatus = STATUS_DISCONNECT;
        this.remoteObj = undefined;
        HMSLogger.info(HMSLogger.DEFAULT_TAG, `mServiceConnection disconnect, ${JSON.stringify(elementName)}`);
        for (let i = 0; i < this.waitQueues.length; i++) {
            const { reject } = this.waitQueues[i];
            reject(new HError(ErrorCode.CLIENT_API_INVALID, 'disconnect'));
        }
        this.waitQueues = [];
    }

    private onFailedCallback(code: number): void {
        this.connectStatus = STATUS_DISCONNECT;
        this.remoteObj = undefined;
        HMSLogger.info(HMSLogger.DEFAULT_TAG, `onConnectLocalService onFailed errCode:${code}`);
        for (let i = 0; i < this.waitQueues.length; i++) {
            const { reject } = this.waitQueues[i];
            reject(new HError(ErrorCode.CLIENT_API_INVALID, `connect fail, error code = ${code}`));
        }
        this.waitQueues = [];
    }

    // 连接超时处理
    private connectTimeoutHandle(): void {
        const flag: number = Math.random();
        this.connectFlag = flag;
        setTimeout(() => {
            if (this.connectStatus === STATUS_CONNECTING && this.connectFlag === flag) {
                this.connectStatus = STATUS_DISCONNECT;
                for (let i = 0; i < this.waitQueues.length; i++) {
                    const { reject } = this.waitQueues[i];
                    reject(new HError(ErrorCode.EXECUTE_TIMEOUT, 'connect timeout.'));
                }
                this.waitQueues = [];
            }
        }, HMSCORE_CONNECT_TIMEOUT);
    }

    private guid(): string {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            const r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
            return v.toString(16);
        });
    }

    newStub(hObject: HObject): Promise<HObject> {
        return new Promise(resolve => {
            const mId: string = hObject.mId || this.guid();
            const mRemoteStub: HObject = hObject;
            mRemoteStub.mId = mId;

            this.holdHObject(hObject);

            HMSLogger.info(HMSLogger.DEFAULT_TAG, `newStub mId substring is: ${mId.substring(8).toLowerCase()}`);
            resolve(mRemoteStub);
        });
    }

    holdHObject(hObject: HObject) {
        // 将hObject包装为remoteObject对象并缓存
        const hObjectWrapper: HObjectWrapper = new HObjectWrapper(hObject.mId, hObject);
        this.remoteObjects[hObject.mId] = hObjectWrapper;
        return hObject;
    }

    /**
     * 获取配置管理
     * @returns 配置管理对象
     */
     getPreferencesManager(): Function {
        return OHOSPreferences;
    }

    getAppInfoManager(): OHOSAppInfo {
        if (!this.appinfo) {
            const context = HGlobalVariableManager.get('hmscoreFramework', 'connectAbilityContext');
            this.appinfo = new OHOSAppInfo(context);
        }
        return this.appinfo;
    }

    getCommonMessenger(): OHOSCommonMessenger {
        return OHOSCommonMessenger;
    }
}
