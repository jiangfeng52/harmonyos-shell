import rpc from "@ohos.rpc"
import { HObject, HParcel } from '@hms-core/framework-base';
import { HMSLogger } from "./HMSLogger";

export class HObjectWrapper extends rpc.RemoteObject {

    mObject: HObject;

    constructor(des: string, object: HObject) {
        // 传入的hId作为RemoteObject的descripter
        super(des)
        this.mObject = object;
        HMSLogger.info(HMSLogger.DEFAULT_TAG, `HObjectWrapper init: this.mObject ${this.mObject}`);
    }

    onRemoteRequest(code: number, data: any, reply: any, options: any): boolean {
        HMSLogger.info(HMSLogger.DEFAULT_TAG, `HObjectWrapper onRemoteRequest: this.mObject ${this.mObject}`);
        
        const remoteCallback: rpc.IRemoteObject = data.readRemoteObject();
        // 根据code处理客户端的请求
        const resultBytes: number[] = data.readByteArray();
        const requestParcel: HParcel = new HParcel().setReaderBuffer(resultBytes);
        const replyParcel: HParcel = new HParcel();
        if (remoteCallback) {
            this.mObject.onTransact(code, requestParcel, replyParcel, 0).then((replyParcel) => {
                const bytes: Uint8Array = replyParcel.getWriterBuffer();
                const option: rpc.MessageOption = new rpc.MessageOption(1);
                option.setFlags(1);
                const callbackData: rpc.MessageSequence = new rpc.MessageSequence();
                callbackData.writeByteArray([...bytes]);
                remoteCallback.sendMessageRequest(
                    1, 
                    callbackData, 
                    new rpc.MessageSequence(),
                    option);
            });
        } else {
            this.mObject.onTransact(code, requestParcel, replyParcel, 0).then((replyParcel) => {
                const bytes: Uint8Array = replyParcel.getWriterBuffer();
                reply.writeByteArray([...bytes]);
            });
        }
        return true;
    }

    
    addDeathRecipient(): boolean {
        return true;
    }

    removeDeathRecipient(): boolean {
        return true;
    }

    isObjectDead(): boolean {
        return false;
    }
}