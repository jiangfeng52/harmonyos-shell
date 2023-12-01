import ArrayList from '@ohos.util.ArrayList'

export abstract class UpdateManager {
  protected onCheckForUpdateListeners: ArrayList<(hasUpdate: boolean)=>void> = new ArrayList<(hasUpdate: boolean)=>void>();
  protected onUpdateReadyListeners: ArrayList<(updatedPath: string)=>void> = new ArrayList<()=>void>();
  protected onUpdateFailedListeners: ArrayList<()=>void> = new ArrayList<()=>void>();

  protected hasUpdate: boolean | null = null
  protected updatedPath: string | null = null

  reset(){
    this.hasUpdate = null
    this.updatedPath = null
  }

  applyUpdate(): void {

  }

  onCheckForUpdate(listener: (hasUpdate: boolean)=>void): void {
    this.onCheckForUpdateListeners.add(listener)

    if (this.hasUpdate != null) {
      listener && listener(this.hasUpdate)
    }
  }

  onUpdateReady(listener: (updatedPath: string)=>void): void {
    this.onUpdateReadyListeners.add(listener)

    if(this.updatedPath != null && this.updatedPath != '') {
      listener && listener(this.updatedPath)
    }
  }

  onUpdateFailed(listener: ()=>void): void {
    this.onUpdateFailedListeners.add(listener)

    if(this.updatedPath == '') {
      listener && listener()
    }
  }

  notifyCheckForUpdate(hasUpdate: boolean){
    this.hasUpdate = hasUpdate

    this.onCheckForUpdateListeners.forEach((listener: (hasUpdate: boolean)=>void)=>{
      listener && listener(hasUpdate)
    })
  }

  notifyUpdateFailed(){
    this.updatedPath = ''

    this.onUpdateFailedListeners.forEach((listener: ()=>void)=>{
      listener && listener()
    })
  }

  notifyUpdateReady(updatedPath: string){
    this.updatedPath = updatedPath

    this.onUpdateReadyListeners.forEach((listener: (updatedPath: string)=>void)=>{
      listener && listener(updatedPath)
    })
  }

}