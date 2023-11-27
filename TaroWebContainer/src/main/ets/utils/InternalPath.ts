/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * internal路径与沙盒路径的转换
 */
export function switchInternalToHapSandBox(path :string) {
    if(path.startsWith('internal://bundle/')){
        return path.replace('internal://bundle',globalThis.abilityContext.bundleCodeDir)
    }
    if(path.startsWith('internal://cache/')){
        return path.replace('internal://cache',globalThis.abilityContext.cacheDir)
    }
    if(path.startsWith('internal://files/')){
        return path.replace('internal://files',globalThis.abilityContext.filesDir)
    }
    if(path.startsWith('internal://preferences/')){
        return path.replace('internal://preferences',globalThis.abilityContext.preferencesDir)
    }
    if(path.startsWith('internal://temp/')){
        return path.replace('internal://temp',globalThis.abilityContext.tempDir)
    }
    if(path.startsWith('internal://database/')){
        return path.replace('internal://database',globalThis.abilityContext.databaseDir)
    }
    if(path.startsWith('internal://distributedFiles/')){
        return path.replace('internal://distributedFiles',globalThis.abilityContext.distributedFilesDir)
    }
    return path
}

/**
 * 沙盒路径转internal路径
 */
export function switchHapSandBoxToInternal(path :string) {
    if(path.startsWith(globalThis.abilityContext.bundleCodeDir)){
        return path.replace(globalThis.abilityContext.bundleCodeDir, 'internal://bundle')
    }
    if(path.startsWith(globalThis.abilityContext.cacheDir)){
        return path.replace(globalThis.abilityContext.cacheDir, 'internal://cache')
    }
    if(path.startsWith(globalThis.abilityContext.filesDir)){
        return path.replace(globalThis.abilityContext.filesDir, 'internal://files')
    }
    if(path.startsWith(globalThis.abilityContext.preferencesDir)){
        return path.replace(globalThis.abilityContext.preferencesDir, 'internal://preferences')
    }
    if(path.startsWith(globalThis.abilityContext.tempDir)){
        return path.replace(globalThis.abilityContext.tempDir, 'internal://temp')
    }
    if(path.startsWith(globalThis.abilityContext.databaseDir)){
        return path.replace(globalThis.abilityContext.databaseDir, 'internal://database')
    }
    if(path.startsWith(globalThis.abilityContext.distributedFilesDir)){
        return path.replace(globalThis.abilityContext.distributedFilesDir, 'internal://distributedFiles')
    }
    return path
}