# AGConnect crypto

## 简介

AppGalleryConnect crypto 提供Pbkdf2秘钥生成和AES加解密功能。

* Pbkdf2秘钥生成
* AES加解密

## 下载安装

```
ohpm install @hw-agconnect/crypto-ohos
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包]

## 使用说明

```
import { AgcCrypto } from "@hw-agconnect/crypto-ohos";
```

##  需要权限

无

## 使用示例

### Pbkdf2秘钥生成

1. 在您的项目中导入agc组件。

   ```
   import { AgcCrypto } from '@hw-agconnect/crypto-ohos'
   ```

2. 生成秘钥。

   ```
   let secretKey = AgcCrypto.ohGenPbkdf2(password, slHex, iterationCount);
   ```

### AES 加解密

   加密
   ```
   let result = AgcCrypto.ohGenAesCbcEncryptWithIv(“hello world!”, workKey, ivHex);
   ```

### 获取AAID

   解密
   ```
   let result = AgcCrypto.ohGenAesCbcDecryptWithIv(“encrypted string”, workKey, ivHex);
   
   ```

## 约束与限制

在下述版本验证通过： DevEco Studio: 3.1 Beta2(3.1.0.400), SDK: API9 Release(3.2.11.9)

## License

crypto-ohos sdk is licensed under the: "ISC" 