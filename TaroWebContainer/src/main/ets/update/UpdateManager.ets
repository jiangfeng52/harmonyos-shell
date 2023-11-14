import ArrayList from '@ohos.util.ArrayList'
import List from '@ohos.util.List';
import { NetworkTaskStaus } from '../data/source/bean/NetworkTask';

export class ResOptions {
  public hasUpdate: boolean

  constructor(hasUpdate:boolean) {
    this.hasUpdate = hasUpdate
  }
}

export type OnCheckForUpdateFunction = (res: ResOptions)=>void

export abstract class UpdateManager {
  protected onCheckForUpdateListeners: ArrayList<(res: ResOptions)=>void> = new ArrayList<(res: ResOptions)=>void>();
  protected onUpdateReadyListeners: ArrayList<()=>void> = new ArrayList<()=>void>();
  protected onUpdateFailedListeners: ArrayList<()=>void> = new ArrayList<()=>void>();

  protected checkForUpdateResult: ResOptions | null = null
  protected updateResult: NetworkTaskStaus | null = null

  reset(){
    this.checkForUpdateResult = null
    this.updateResult = null
  }

  applyUpdate(): void {

  }

  onCheckForUpdate(listener: (res: ResOptions)=>void): void {
    this.onCheckForUpdateListeners.add(listener)

    if (this.checkForUpdateResult) {
      listener && listener(this.checkForUpdateResult)
    }
  }

  onUpdateReady(listener: ()=>void): void {
    this.onUpdateReadyListeners.add(listener)

    if(this.updateResult == NetworkTaskStaus.READY) {
      listener && listener()
    }
  }

  onUpdateFailed(listener: ()=>void): void {
    this.onUpdateFailedListeners.add(listener)

    if(this.updateResult == NetworkTaskStaus.FAILED) {
      listener && listener()
    }
  }

  notifyCheckForUpdate(res: ResOptions){
    this.checkForUpdateResult = res

    this.onCheckForUpdateListeners.forEach((listener: (res: ResOptions)=>void)=>{
      listener && listener(res)
    })
  }

  notifyUpdateFailed(){
    this.updateResult = NetworkTaskStaus.FAILED

    this.onUpdateFailedListeners.forEach((listener: ()=>void)=>{
      listener && listener()
    })
  }

  notifyUpdateReady(){
    this.updateResult = NetworkTaskStaus.READY

    this.onUpdateReadyListeners.forEach((listener: ()=>void)=>{
      listener && listener()
    })
  }

}