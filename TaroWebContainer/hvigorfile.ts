import { harTasks } from '@ohos/hvigor-ohos-plugin';
import { transformSync } from '@babel/core';
import * as fs from 'fs'
import presetEnv from '@babel/preset-env'

export function customPluginFunction(str?: string) {
    return {
        pluginId: 'CustomPluginID',
        apply(pluginContext) {
            pluginContext.registerTask({
                // 编写自定义任务
                name: 'babelTranform',
                run: (taskContext) => {
                    const path = require('path');
                    let injectFilePath = path.join(taskContext.modulePath, "NativeApi", "inject.ts")
                    let rawFileContent = fs.readFileSync(injectFilePath, 'utf8')

                    const result = transformSync(rawFileContent, {
                        presets: [presetEnv],
                        plugins: ["@babel/plugin-transform-typescript"]
                    })
                    let outputFilePath = path.join(taskContext.modulePath, "src", "main", "resources", "rawfile", "native.js")
                    fs.writeFileSync(outputFilePath, result.code)
                },
                // 确认自定义任务插入位置
                postDependencies: ['default@PreBuild']
            })
        }
    }
}

export default {
    system: harTasks, /* Built-in plugin of Hvigor. It cannot be modified. */
    plugins: [customPluginFunction()]         /* Custom plugin to extend the functionality of Hvigor. */
}