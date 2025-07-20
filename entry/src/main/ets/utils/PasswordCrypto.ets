// PasswordCipher.ets
import cryptoFramework from '@ohos.security.cryptoFramework';
import util from '@ohos.util';

// 明确定义类型
type Uint8Array = number[];

const AES_ALG_NAME = 'AES256';
const AES_KEY_SIZE = 256;
const IV_SIZE = 16;

export class PasswordCipher {
  /**
   * 加密密码
   * @param password 明文密码
   * @param masterKey 主密钥
   * @returns 加密后的Base64字符串
   */
  static async encryptPassword(password: string, masterKey: string): Promise<string> {
    try {
      const salt: Uint8Array = await PasswordCipher.generateRandom(16);
      const iv: Uint8Array = await PasswordCipher.generateRandom(IV_SIZE);

      const secretKey: cryptoFramework.SymKey = await PasswordCipher.deriveKey(masterKey, salt);
      const cipherText: Uint8Array = await PasswordCipher.aesEncrypt(secretKey, iv, password);

      return `${PasswordCipher.uint8ArrayToBase64(salt)}.${PasswordCipher.uint8ArrayToBase64(iv)}.${PasswordCipher.uint8ArrayToBase64(cipherText)}`;
    } catch (error) {
      console.error(`[PasswordCipher] 加密失败: ${error.code}, ${error.message}`);
      const err = new Error(`加密失败: ${error.message}`);
      //  = error.code;
      throw err;
    }
  }

  /**
   * 解密密码
   * @param encryptedData 加密数据
   * @param masterKey 主密钥
   * @returns 解密后的明文密码
   */
  static async decryptPassword(encryptedData: string, masterKey: string): Promise<string> {
    try {
      const parts: string[] = encryptedData.split('.');
      if (parts.length !== 3) {
        throw new Error('无效的加密数据格式');
      }

      const salt: Uint8Array = PasswordCipher.base64ToUint8Array(parts[0]);
      const iv: Uint8Array = PasswordCipher.base64ToUint8Array(parts[1]);
      const cipherText: Uint8Array = PasswordCipher.base64ToUint8Array(parts[2]);

      const secretKey: cryptoFramework.SymKey = await PasswordCipher.deriveKey(masterKey, salt);
      return await PasswordCipher.aesDecrypt(secretKey, iv, cipherText);
    } catch (error) {
      console.error(`[PasswordCipher] 解密失败: ${error.code}, ${error.message}`);
      const err = new Error(`解密失败: ${error.message}`);
      // (err as any).code = error.code;
      throw err;
    }
  }

  // ========== 私有方法 ========== //

  /**
   * 生成随机字节 (ArkTS兼容实现)
   * @param length 字节长度
   */
  private static async generateRandom(length: number): Promise<Uint8Array> {
    const rand: cryptoFramework.Random = cryptoFramework.createRandom();
    const randomData = await rand.generateRandom(length);
    return Array.from(randomData.data) as number[];
  }

  /**
   * 使用SHA256派生密钥 (ArkTS兼容实现)
   * @param password 主密钥
   * @param salt 盐值
   */
  private static async deriveKey(password: string, salt: Uint8Array): Promise<cryptoFramework.SymKey> {
    // 1. 组合密码和盐值
    const passwordBytes: Uint8Array = PasswordCipher.stringToUint8Array(password);
    const combined: Uint8Array = [...passwordBytes, ...salt];

    // 2. 计算SHA256哈希
    const sha256: cryptoFramework.Md = cryptoFramework.createMd('SHA256');
    await sha256.update({ data: combined });
    const hash = await sha256.digest();

    // 3. 创建AES密钥
    const generator: cryptoFramework.SymKeyGenerator = cryptoFramework.createSymKeyGenerator('AES');
    return generator.convertKey({ data: hash.data.slice(0, 32) });
  }

  /**
   * AES加密 (ArkTS兼容实现)
   */
  private static async aesEncrypt(
    key: cryptoFramework.SymKey,
    iv: Uint8Array,
    plainText: string
  ): Promise<Uint8Array> {
    const transformer: cryptoFramework.Cipher = cryptoFramework.createCipher('AES256|CBC|PKCS5');

    const params: cryptoFramework.IvParamsSpec = {
      algName: 'IvParamsSpec',
      iv: iv
    };

    await transformer.init(cryptoFramework.CryptoMode.ENCRYPT_MODE, key, params);

    const input = {
      data: PasswordCipher.stringToUint8Array(plainText)
    };

    const output = await transformer.doFinal(input);
    return Array.from(output.data) as number[];
  }

  /**
   * AES解密 (ArkTS兼容实现)
   */
  private static async aesDecrypt(
    key: cryptoFramework.SymKey,
    iv: Uint8Array,
    cipherText: Uint8Array
  ): Promise<string> {
    const transformer: cryptoFramework.Cipher = cryptoFramework.createCipher('AES256|CBC|PKCS5');

    const params: cryptoFramework.IvParamsSpec = {
      algName: 'IvParamsSpec',
      iv: iv
    };

    await transformer.init(cryptoFramework.CryptoMode.DECRYPT_MODE, key, params);

    const input = {
      data: cipherText
    };

    const output = await transformer.doFinal(input);
    return PasswordCipher.uint8ArrayToString(Array.from(output.data) as number[]);
  }

  // ========== 辅助方法 ========== //

  private static stringToUint8Array(str: string): Uint8Array {
    const encoder = new util.TextEncoder();
    return Array.from(encoder.encode(str));
  }

  private static uint8ArrayToString(array: Uint8Array): string {
    const decoder = new util.TextDecoder();
    return decoder.decode(new Uint8Array(array));
  }

  private static uint8ArrayToBase64(array: Uint8Array): string {
    return util.Base64.encodeToString(array);
  }

  private static base64ToUint8Array(base64: string): Uint8Array {
    return util.Base64.decode(base64) as number[];
  }
}