import { BaseDeveloper } from 'web-container';

PersistentStorage.persistProp('entryDomain', 'http://10.253.108.182:10086/')
PersistentStorage.persistProp('useBuildIn', true)
let storage = LocalStorage.getShared();

@Entry(storage)
@Component
export struct Developer {
  title: string = '开发者选项'
  @StorageLink('entryDomain') entryDomain:string = ''
  @State entryDomainState: string = this.entryDomain
  @StorageLink('useBuildIn') useBuildIn:boolean = true
  @State useBuildInState: boolean = this.useBuildIn
  @LocalStorageLink('refresh') refresh:boolean = false

  build() {
    Column() {
      BaseDeveloper({
        entryDomain: this.entryDomain,
        useBuildIn: this.useBuildIn,
        refresh: this.refresh
      })
        .width('100%')
        .height('100%')
    }
  }
}