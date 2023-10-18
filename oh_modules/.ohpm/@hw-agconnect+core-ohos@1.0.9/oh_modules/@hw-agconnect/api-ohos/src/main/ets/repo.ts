import { ServiceRepository, ServiceInfo } from '../../../types'
const DEFAULT_CATEGORY = "[DEFAULT_CATEGORY]";

class ServiceRepositoryImpl implements ServiceRepository {
  private readonly servicesIdentifierMap = new Map<string, Map<string, any>>();
  private readonly registeredService = new Map<string, ServiceInfo>();
  registryService(serviceInfo: ServiceInfo): void {
    const name = serviceInfo.name;
    if (!this.registeredService.has(name)) {
      this.registeredService.set(name, serviceInfo);
    }
  }

  unregistryService(serviceInfo: ServiceInfo): void {
  }

  getService<T>(name: string, data: any, category: string = DEFAULT_CATEGORY): T | null {
    let map = this.servicesIdentifierMap.get(category);
    if (map == undefined) {
      map = new Map<string, ServiceInfo<T>>();
      this.servicesIdentifierMap.set(category, map);
    } else {
      const instance = map.get(name);
      if (instance != undefined) {
        return <T>instance;
      }
    }

    let srv = this.registeredService.get(name);
    if (srv != null) {
      const instance = <T>srv.serviceFactory(data);
      map.set(name, instance);
      return instance;
    }
    return null;
  }
}

const repo = new ServiceRepositoryImpl
export { repo, DEFAULT_CATEGORY }
