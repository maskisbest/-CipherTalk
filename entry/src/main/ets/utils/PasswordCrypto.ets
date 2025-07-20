// // 文件路径：entry/src/main/ets/utils/SecureStorage.ets
// import cryptoFramework from '@ohos.security.cryptoFramework'
// import keyStore from '@ohos.security.keyStore'
// import util from '@ohos.util'
//
// /**
//  * 安全存储工具类 - 提供密码加密、解密和安全存储功能
//  * 使用AES-256-CBC加密算法，结合系统密钥库实现安全密钥管理
//  */
// export class SecureStorage {
//   private static readonly KEY_ALIAS = 'app_crypto_key'
//   private static readonly IV_LENGTH = 16 // AES IV length in bytes
//   private static readonly KEY_SIZE = 256 // AES key size in bits
//
//   /**
//    * 获取或生成加密密钥
//    * @returns Promise<cryptoFramework.Key> 加密密钥
//    */
//   private async getOrCreateKey(): Promise<cryptoFramework.Key> {
//     try {
//       // 获取系统密钥库
//       const store = await keyStore.getKeyStore('default')
//
//       // 尝试获取现有密钥
//       const existingKey = await store.getKey(SecureStorage.KEY_ALIAS)
//       if (existingKey) {
//         return existingKey
//       }
//
//       // 生成新密钥
//       const keyGenerator = cryptoFramework.createKeyGenerator('AES')
//       keyGenerator.init(SecureStorage.KEY_SIZE)
//       const newKey = keyGenerator.generateKey()
//
//       // 存储新密钥
//       await store.putKey(SecureStorage.KEY_ALIAS, newKey, 0)
//
//       return newKey
//     } catch (error) {
//       console.error('密钥管理失败，使用回退方案:', error)
//       // 回退到内存生成密钥（仅用于开发环境）
//       return this.generateInMemoryKey()
//     }
//   }
//
//   /**
//    * 生成内存密钥（仅用于开发环境）
//    */
//   private generateInMemoryKey(): cryptoFramework.Key {
//     const keyGenerator = cryptoFramework.createKeyGenerator('AES')
//     keyGenerator.init(SecureStorage.KEY_SIZE)
//     return keyGenerator.generateKey()
//   }
//
//   /**
//    * 生成随机IV向量
//    */
//   private generateIV(): ArrayBuffer {
//     const randomGenerator = cryptoFramework.createSecureRandom()
//     const iv = new Uint8Array(SecureStorage.IV_LENGTH)
//     randomGenerator.nextBytes(iv)
//     return iv.buffer
//   }
//
//   /**
//    * 加密数据
//    * @param plainText 明文数据
//    * @returns 加密后的Base64字符串
//    */
//   public async encrypt(plainText: string): Promise<string> {
//     try {
//       const key = await this.getOrCreateKey()
//       const iv = this.generateIV()
//
//       // 创建加密器（使用CBC模式）
//       const cipher = cryptoFramework.createCipher('AES/CBC/PKCS7')
//       cipher.init(cryptoFramework.CipherMode.ENCRYPT_MODE, key, { iv })
//
//       // 执行加密
//       const cipherBlob = cipher.doFinal({ data: plainText })
//
//       // 合并IV和加密数据（IV需要传递给解密端）
//       const combined = new Uint8Array(SecureStorage.IV_LENGTH + cipherBlob.data.byteLength)
//       combined.set(new Uint8Array(iv), 0)
//       combined.set(new Uint8Array(cipherBlob.data), SecureStorage.IV_LENGTH)
//
//       // 转换为Base64
//       return util.bufferUtils.toBase64(combined.buffer)
//     } catch (error) {
//       console.error('加密失败:', error)
//       throw new Error(`加密失败: ${error.message}`)
//     }
//   }
//
//   /**
//    * 解密数据
//    * @param cipherText 加密后的Base64字符串
//    * @returns 解密后的明文数据
//    */
//   public async decrypt(cipherText: string): Promise<string> {
//     try {
//       const key = await this.getOrCreateKey()
//
//       // Base64解码
//       const combined = util.bufferUtils.fromBase64(cipherText)
//       const combinedArray = new Uint8Array(combined)
//
//       // 提取IV和密文
//       const iv = combinedArray.slice(0, SecureStorage.IV_LENGTH)
//       const cipherData = combinedArray.slice(SecureStorage.IV_LENGTH)
//
//       // 创建解密器
//       const cipher = cryptoFramework.createCipher('AES/CBC/PKCS7')
//       cipher.init(cryptoFramework.CipherMode.DECRYPT_MODE, key, { iv: iv.buffer })
//
//       // 执行解密
//       const plainBlob = cipher.doFinal({ data: cipherData.buffer })
//
//       return this.arrayBufferToString(plainBlob.data)
//     } catch (error) {
//       console.error('解密失败:', error)
//       throw new Error(`解密失败: ${error.message}`)
//     }
//   }
//
//   /**
//    * ArrayBuffer转字符串
//    */
//   private arrayBufferToString(buffer: ArrayBuffer): string {
//     return String.fromCharCode.apply(null, new Uint8Array(buffer))
//   }
//
//   /**
//    * 清除安全存储的密钥（应用卸载时调用）
//    */
//   public async clearSecurityKey(): Promise<void> {
//     try {
//       const store = await keyStore.getKeyStore('default')
//       await store.deleteKey(SecureStorage.KEY_ALIAS)
//     } catch (error) {
//       console.warn('清除密钥失败:', error)
//     }
//   }
// }
