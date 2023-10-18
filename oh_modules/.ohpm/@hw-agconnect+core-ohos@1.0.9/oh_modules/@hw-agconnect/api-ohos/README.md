## 简介

api-ohos 是AGC 上层业务SDK的基础框架，提供给上层业务注册能力。

## 下载安装

```
ohpm install @hw-agconnect/api-ohos
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包]

## 使用说明

```
import agconnect from "@hw-agconnect/api-ohos";
```

##  需要权限

无

## 使用示例

1. 在您的项目中导入agc组件。

   ```
   import agconnect from "@hw-agconnect/api-ohos";
   import "@hw-agconnect/core-ohos";
   ```

2. 获取业务sdk，以core-ohos sdk为例（core-ohos在步骤1中已经引入）：

   ```
   let instance = agconnect.instance();
   
   // 调用业务sdk方法
   instance.init();
   ```


## 约束与限制

在下述版本验证通过： DevEco Studio: 3.1 Beta2(3.1.0.400), SDK: API9 Release(3.2.11.9)

## License

api-ohos sdk is licensed under the: "ISC" 