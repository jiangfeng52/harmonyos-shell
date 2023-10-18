import { AGCApi, ApiManager, ServiceFactory, ServiceInfo, Property,ServiceRepository } from './types'
import { repo } from './src/main/ets/repo'
import { defineProperty } from './src/main/ets/utils'

export { DEFAULT_CATEGORY } from "./src/main/ets/repo"

class AGCApiImpl implements ApiManager, ServiceRepository {
    registerApiProvider<T, V>(name: string, factory: ServiceFactory<T, V>, props?: Property): void {
        (this as any)[name] = (...args: any) => {
            return factory(args);
        }
        if (props != undefined) {
            let target = (this as any)[name];
            defineProperty(target, props);
        }
    }

    registerInternalService<T, V>(serviceInfo: ServiceInfo<T, V>): void {
        repo.registryService(serviceInfo);
    }

    getService<T>(name: string, data: any, category?: string | undefined): T | null {
        return repo.getService(name, data, category);
    }
}

const agconnect: AGCApi = new AGCApiImpl();
export default agconnect;
