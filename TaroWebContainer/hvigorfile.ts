import { harTasks } from '@ohos/hvigor-ohos-plugin';
import { transformSync } from '@babel/core';
import * as fs from 'fs'

export default {
  system: harTasks, /* Built-in plugin of Hvigor. It cannot be modified. */
  plugins: [customPluginFunction()]         /* Custom plugin to extend the functionality of Hvigor. */
}

export function customPluginFunction(str?: string) {
  return {
    pluginId: 'CustomPluginID',
    apply(pluginContext) {
      pluginContext.registerTask({
        // 编写自定义任务
        name: 'tsToJsModule',
        run: (taskContext) => {
          const path = require('path');
          let appFilePath = path.join(taskContext.modulePath, "JsBridge", "app.ts")

          let rawFileContent = fs.readFileSync(appFilePath, 'utf8')
          const result = transformSync(rawFileContent, {
            presets: ["@babel/preset-env"],
            plugins: ["@babel/plugin-transform-typescript"],
          })

          let outputFilePath = path.join(taskContext.modulePath, "src", "main", "resources", "rawfile", "app.js")
          fs.writeFileSync(outputFilePath, result.code)
        },
        // 确认自定义任务插入位置
        postDependencies: ['default@PreBuild']
      })
    }
  }
}
