import agconnect from '@hw-agconnect/api-ohos'
import { ApiManager, ServiceRepository, AGCApi } from '@hw-agconnect/api-ohos'
import { AGCInstanceImpl } from './src/main/ets/AGCInstanceImpl'
import { InstanceMap } from './src/main/ets/singleton'
import "./src/main/ets/aaid"

export { Singleton, InstanceMap } from './src/main/ets/singleton'
export { AGCError, AGCErrorCode } from "./src/main/ets/AGCError";

const apiName = "instance";
const creator = new InstanceMap((args: any[]) => {
  return new AGCInstanceImpl(<ServiceRepository><any>agconnect, args[0]);
});

export enum AGCRoutePolicy {
  UNKNOWN,
  CHINA,
  GERMANY,
  RUSSIA,
  SINGAPORE
}

function main(container: ApiManager) {
  container.registerApiProvider(apiName, (args?: any[]) => creator.get(args));
}

main(agconnect as ApiManager);
