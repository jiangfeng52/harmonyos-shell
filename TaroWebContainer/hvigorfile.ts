import { hspTasks } from '@ohos/hvigor-ohos-plugin';
import { transformSync } from '@babel/core';
import * as fs from 'fs'

export default {
  system: hspTasks, /* Built-in plugin of Hvigor. It cannot be modified. */
  plugins: [customPluginFunction()]         /* Custom plugin to extend the functionality of Hvigor. */
}

export function customPluginFunction(str?: string) {
  return {
    pluginId: 'CustomPluginID',
    apply(pluginContext) {
      pluginContext.registerTask({
        // ±àÐ´×Ô¶¨ÒåÈÎÎñ
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
        // È·ÈÏ×Ô¶¨ÒåÈÎÎñ²åÈëÎ»ÖÃ
        postDependencies: ['default@PreBuild']
      })
    }
  }
}
