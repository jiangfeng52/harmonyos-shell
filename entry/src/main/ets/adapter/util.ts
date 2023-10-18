export function switchInternalToHapSandBox(path :string){
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