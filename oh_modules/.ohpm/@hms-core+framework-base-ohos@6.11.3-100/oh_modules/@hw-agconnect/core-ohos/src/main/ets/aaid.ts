import { InstanceMap } from './singleton'
import { ApiManager } from '@hw-agconnect/api-ohos'
import agconnect from '@hw-agconnect/api-ohos'
import { AaidImpl } from "./AGCAaidImpl";

const creator = new InstanceMap(() => {
  return new AaidImpl();
});

function main(container: ApiManager) {
  container.registerApiProvider('aaid', (args?: any[]) => creator.get(args));
}

main(agconnect as ApiManager);
