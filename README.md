# CipherTalk - 秘语

[![HarmonyOS](https://img.shields.io/badge/HarmonyOS-4.0+-blue.svg)](https://developer.harmonyos.com/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.0+-blue.svg)](https://www.typescriptlang.org/)
[![ArkTS](https://img.shields.io/badge/ArkTS-4.0+-green.svg)](https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/arkts-get-started-0000001504769321-V3)

> 一个基于HarmonyOS开发的加密即时通讯应用，提供安全的文字、语音聊天功能和AI智能助手服务。

## 📖 项目简介

CipherTalk（秘语）是一款专注于隐私保护的即时通讯应用，采用HarmonyOS原生开发，集成了密码加密、语音识别、AI智能体等先进功能。应用采用仿微信的UI设计，为用户提供熟悉而安全的聊天体验。

## ✨ 主要特性

### 🔐 安全通讯
- **密码加密**: 使用AES256加密算法保护用户密码和敏感信息
- **安全认证**: 基于邮箱的用户注册和登录系统
- **隐私保护**: 端到端加密确保通讯安全

### 💬 即时通讯
- **多媒体消息**: 支持文字、语音、图片消息
- **实时语音**: 语音录制、播放和实时语音识别
- **聊天记录**: 完整的聊天历史记录
- **联系人管理**: 通过邮箱添加好友

### 🤖 AI智能助手
- **集成Coze AI**: 接入扣子平台的智能体服务
- **智能对话**: 提供AI助手进行智能问答
- **上下文理解**: 支持连续对话和上下文记忆

### 🎨 用户界面
- **仿微信设计**: 熟悉的四Tab布局（秘语、联系人、发现、我）
- **Material Design**: 现代化的UI组件和交互效果
- **响应式布局**: 适配手机、平板等多种设备

## 🏗️ 技术架构

### 开发框架
- **HarmonyOS SDK**: 鸿蒙原生应用开发
- **ArkTS**: TypeScript扩展语言
- **ArkUI**: 声明式UI开发框架

### 核心技术
- **加密技术**: `@ohos.security.cryptoFramework` - AES256加密
- **网络请求**: `@ohos/axios` - HTTP客户端
- **语音处理**: 
  - `AudioCaptureManager` - 录音管理
  - `AudioRendererManager` - 音频播放
  - `SpeechRecognizerManager` - 语音识别
- **多媒体**: `@kit.MediaLibraryKit` - 图片选择和处理
- **权限管理**: `PermissionUtils` - 应用权限管理

### 第三方服务
- **Coze AI Platform**: 智能体API服务
- **自定义后端**: 用户认证和数据管理

## 📁 项目结构

```
CipherTalk/
├── AppScope/                          # 应用级配置
│   ├── app.json5                     # 应用配置文件
│   └── resources/                    # 应用级资源
├── entry/                            # 主模块
│   ├── src/main/
│   │   ├── ets/
│   │   │   ├── component/           # 通用组件
│   │   │   │   ├── InputField.ets   # 输入框组件
│   │   │   │   ├── ListChatItem.ets # 聊天列表项
│   │   │   │   ├── PrimaryButton.ets # 主按钮
│   │   │   │   └── ...
│   │   │   ├── pages/               # 页面
│   │   │   │   ├── Index.ets        # 主页面（Tab容器）
│   │   │   │   ├── login/           # 登录页面
│   │   │   │   ├── register/        # 注册页面
│   │   │   │   ├── home/            # 聊天列表
│   │   │   │   ├── chat/            # 聊天页面
│   │   │   │   ├── contact/         # 联系人
│   │   │   │   ├── discovery/       # 发现页面
│   │   │   │   ├── mine/            # 个人页面
│   │   │   │   └── AgentPage/       # AI智能体
│   │   │   ├── utils/               # 工具类
│   │   │   │   ├── PasswordCrypto.ets # 密码加密
│   │   │   │   ├── AgentUtil.ets    # AI助手工具
│   │   │   │   ├── AudioCapturerManager.ets # 录音管理
│   │   │   │   ├── SpeechRecognizerManager.ets # 语音识别
│   │   │   │   └── ...
│   │   │   └── params/              # 参数模型
│   │   └── resources/               # 资源文件
│   │       ├── base/element/        # 字符串资源
│   │       └── base/media/          # 图片资源
├── oh-package.json5                  # 依赖配置
├── build-profile.json5               # 构建配置
└── hvigorfile.ts                     # 构建脚本
```

## 🚀 快速开始

### 环境要求

- **DevEco Studio**: 4.0 或更高版本
- **HarmonyOS SDK**: API Level 9 或更高
- **Node.js**: 16.0 或更高版本

### 安装步骤

1. **克隆项目**
   ```bash
   git clone https://github.com/your-username/CipherTalk.git
   cd CipherTalk
   ```

2. **安装依赖**
   ```bash
   # DevEco Studio会自动安装oh-package.json5中的依赖
   # 或手动执行
   ohpm install
   ```

3. **配置API密钥**
   
   在 `entry/src/main/ets/utils/AgentUtil.ets` 中配置Coze API Token：
   ```typescript
   const authToken = "your_coze_api_token_here";
   ```

4. **运行项目**
   - 在DevEco Studio中打开项目
   - 选择目标设备（模拟器或真机）
   - 点击运行按钮

### 配置说明

#### 应用权限
应用需要以下权限（已在module.json5中配置）：
- `ohos.permission.INTERNET` - 网络访问
- `ohos.permission.READ_ACCESSIBILITY_CONFIG` - 无障碍服务
- `ohos.permission.READ_WRITE_USER_FILE` - 用户文件读写

#### API配置
1. **后端服务**: 需要配置用户认证API地址
2. **Coze AI**: 需要申请Coze平台API密钥

## 📱 功能演示

### 主要页面

1. **登录/注册页面**
   - 邮箱密码登录
   - 用户注册（支持头像上传）
   - 密码加密存储

2. **聊天列表（秘语）**
   - 显示最近聊天记录
   - AI智能体入口
   - 消息预览和时间

3. **聊天页面**
   - 文字消息收发
   - 语音录制和播放
   - 实时语音转文字
   - 图片消息发送

4. **AI智能体**
   - 集成Coze平台AI助手
   - 智能问答和对话
   - 聊天上下文记忆

5. **联系人页面**
   - 通过邮箱搜索添加好友
   - 联系人列表管理

6. **发现页面**
   - 仿微信功能入口
   - 朋友圈、视频号等（UI展示）

7. **个人页面**
   - 用户信息展示
   - 设置和服务入口
   - 退出登录

## 🔧 开发指南

### 添加新功能

1. **创建新页面**
   ```typescript
   @Entry
   @Component
   struct NewPage {
     build() {
       // 页面UI代码
     }
   }
   ```

2. **添加路由**
   在 `main_pages.json` 中添加页面路径：
   ```json
   {
     "src": [
       "pages/NewPage"
     ]
   }
   ```

3. **创建组件**
   ```typescript
   @Component
   export default struct NewComponent {
     build() {
       // 组件UI代码
     }
   }
   ```

### 调试技巧

- 使用 `console.log()` 输出调试信息
- 在DevEco Studio中使用断点调试
- 通过Hilog查看应用日志

## 🔒 安全特性

### 密码加密
- 使用AES256对称加密算法
- 随机生成盐值和初始化向量
- Base64编码存储加密结果

### 网络安全
- HTTPS通信协议
- API Token认证
- 请求数据验证

### 隐私保护
- 本地数据加密存储
- 敏感信息脱敏处理
- 最小权限原则

## 🤝 贡献指南

欢迎提交Issue和Pull Request来改进项目！

### 开发流程
1. Fork项目仓库
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送分支 (`git push origin feature/AmazingFeature`)
5. 创建Pull Request

### 代码规范
- 遵循TypeScript代码规范
- 使用ArkTS官方推荐的编码风格
- 添加必要的注释和文档

## 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

## 🙏 致谢

- [HarmonyOS官方文档](https://developer.harmonyos.com/)
- [Coze AI平台](https://www.coze.cn/)
- [Axios HTTP客户端](https://github.com/axios/axios)

## 📞 联系我们

- 项目作者：[您的姓名]
- 邮箱：[xzy1476569428@163.com]
- 项目链接：[https://github.com/maskisbest/-CipherTalk]

---

**注意**: 这是一个学习项目，用于SCU本科作业，仅供教育和研究目的使用。
