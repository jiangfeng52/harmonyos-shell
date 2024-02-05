import { BuilderData } from '../common/entity/BuilderData'
import { TaroWebContainer } from '../../components/TaroWebContainer'

const TAG: string = 'zhou WebBuilder'

@Builder
export function WebBuilder(builderData: BuilderData) {
  Column() {
    TaroWebContainer({
      webUrl: builderData.webUrl,
      taroWebController: builderData.taroWebController,
      useCache: true,
      isFullScreen: true
    })
  }
}