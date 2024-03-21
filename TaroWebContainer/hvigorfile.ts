import { harTasks } from '@ohos/hvigor-ohos-plugin';
import { transformSync } from '@babel/core';
import * as fs from 'fs'

export default {
  system: harTasks, /* Built-in plugin of Hvigor. It cannot be modified. */
  plugins: [customPluginFunction()]         /* Custom plugin to extend the functionality of Hvigor. */
}

function writeFileToRawfileSync(source,target) {
  let rawFileContent = fs.readFileSync(source, 'utf8')
  const content = transformSync(rawFileContent, {
    presets: ["@babel/preset-env"],
    plugins: ["@babel/plugin-transform-typescript"],
  })
  fs.writeFileSync(target, content.code)
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
          writeFileToRawfileSync(
            path.join(taskContext.modulePath, "JsBridge", "app.ts"),
            path.join(taskContext.modulePath, "src", "main", "resources", "rawfile", "app.js")
          )
          // write osChannelApi
          writeFileToRawfileSync(
            path.join(taskContext.modulePath, "OsChannel", "osChannelApi.ts"),
            path.join(taskContext.modulePath, "src", "main", "resources", "rawfile", "osChannelApi.js")
          )
        },
        // 确认自定义任务插入位置
        postDependencies: ['default@PreBuild']
      })
    }
  }
}
