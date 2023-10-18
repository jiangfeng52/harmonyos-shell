# AGConnect Base SDK

##  简介

AGConnect Base SDK提供基础工具类的接口能力：

* 哈希算法：支持MD5和SHA256
* AES加解密
* 数据本地存储：支持文件和Preference

## 下载安装

```
ohpm install @hw-agconnect/base-ohos
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

##  使用说明

```
import { Hash, AegisAes } from "@hw-agconnect/base-ohos";
```

##  需要权限

无

## 使用示例

### 哈希算法

 SHA256

   ```
   import { sha256 } from "@hw-agconnect/base-ohos";
   
   let str = sha256(unit8Array);
   
   ```
   
### AES加解密
1. 创建秘钥

   ```
   import { AegisAes } from '@hw-agconnect/base-ohos';
   
   
    let key = await AegisAes.buildKey(rxHex, ryHex, rZHex, slHex, ITERATION_COUNT);
   ```

2. AES加密。

   ```
   let result = await AegisAes.encryptWithIv(aesKey, iv, plain);
   ```

3. AES解密。

   ```
    let result = AegisAes.decryptWithIv(aesKey, iv, cipher);
   ```

### 数据本地存储
1. 文件。

   ```
   import { FileStorage } from "@hw-agconnect/base-ohos";
   
   FileStorage.write(context, FILE_PATH, FILE_NAME, "file content");
   
   FileStorage.read(context, this.FILE_PATH, FILE_NAME);
   ```

2. Preference。

   ```
   import { Preferences } from '../datastore/preference';
   
   Preferences.put(context, FILE_NAME, KEY, value);
   
   Preferences.get(context, FILE_NAME, KEY);
   ```

##  约束与限制

在下述版本验证通过： DevEco Studio: 3.1 Beta2(3.1.0.400), SDK: API9 Release(3.2.11.9)

## License

function-ohos sdk is licensed under the: "ISC" 