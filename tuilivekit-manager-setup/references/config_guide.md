# TUILiveKit Manager 配置参考

## 项目概述

TUILiveKit Manager 是一套直播间管理系统，采用 pnpm monorepo 架构，包含以下子包：

| 子包 | 路径 | 说明 |
|------|------|------|
| server | `packages/server` | Node.js 服务端，提供 REST API |
| vue3 | `packages/vue3` | Vue3 前端管理界面 |
| react | `packages/react` | React 前端管理界面（可选） |
| common | `packages/common` | 共享代码、类型定义、工具函数 |

## 功能模块

- **直播监控**：多路同屏监播、低延迟播放、房间搜索、强制关播
- **直播间详情**：实时播放、数据统计、用户管理（禁言/封禁）
- **直播间管理**：直播间列表、创建/编辑/解散房间、OBS 推流配置
- **礼物配置**：礼物增删改、分类管理、多语言配置

## 服务端配置项

服务端配置文件路径：`packages/server/config/.env`

### 必填配置

| 配置项 | 说明 | 示例值 |
|--------|------|--------|
| SDK_APP_ID | 腾讯云 SDKAppID | `1400000001` |
| SECRET_KEY | 腾讯云 SecretKey | `xxxxxxxxxxxxxxxx` |
| USER_ID | 管理员 userID | `administrator` |
| PORT | 服务端口号 | `9000` |
| DOMAIN | API 域名（按地域区分） | `console.tim.qq.com` |

### DOMAIN 地域对照

| 地域 | 域名 |
|------|------|
| 中国 | `console.tim.qq.com` |
| 新加坡 | `adminapisgp.im.qcloud.com` |
| 首尔 | `adminapikr.im.qcloud.com` |
| 法兰克福 | `adminapiger.im.qcloud.com` |
| 美国 | `adminapiusa.im.qcloud.com` |
| 印尼 | `adminapiidn.im.qcloud.com` |

### 图片上传（可选）

图片上传支持两种存储 Provider：

#### 腾讯云 COS

| 配置项 | 必填 | 说明 |
|--------|------|------|
| STORAGE_PROVIDER | 是 | 设为 `cos` |
| COS_SECRET_ID | 是 | 腾讯云 API SecretId |
| COS_SECRET_KEY | 是 | 腾讯云 API SecretKey |
| COS_BUCKET | 是 | COS 存储桶名称 |
| COS_REGION | 是 | 存储桶所在地域 |
| COS_CDN_DOMAIN | 否 | CDN 加速域名 |
| COS_PATH_PREFIX | 否 | 存储路径前缀 |

#### 自定义 HTTP 上传

| 配置项 | 必填 | 说明 |
|--------|------|------|
| STORAGE_PROVIDER | 是 | 设为 `custom` |
| CUSTOM_UPLOAD_URL | 是 | 上传接口地址 |
| CUSTOM_ACCESS_DOMAIN | 否 | 文件访问域名前缀 |
| CUSTOM_UPLOAD_FIELD | 否 | 上传字段名，默认 `file` |
| CUSTOM_RESPONSE_URL_FIELD | 否 | 响应中 URL 的 JSON 路径，默认 `data.url` |
| CUSTOM_AUTH_HEADER | 否 | 认证请求头 |
| CUSTOM_PATH_PREFIX | 否 | 存储路径前缀 |

> 不配置 STORAGE_PROVIDER 时，前端会自动降级为 URL 手动输入模式，不影响其他功能。

## 前端配置项

前端配置文件路径：`packages/vue3/.env`（或 `packages/react/.env`）

| 配置项 | 说明 | 示例值 |
|--------|------|--------|
| VITE_API_BASE_URL | API 服务基础地址 | `http://localhost:9000/api` |

> 端口号必须与服务端的 PORT 配置一致。

## pnpm 命令速查

| 命令 | 说明 |
|------|------|
| `pnpm install` | 安装所有依赖 |
| `pnpm run start:server` | 启动服务端 |
| `pnpm run dev:vue` | 启动 Vue3 前端（开发模式） |
| `pnpm run dev:react` | 启动 React 前端（开发模式） |
| `pnpm run build:vue` | 构建 Vue3 前端 |
| `pnpm run build:react` | 构建 React 前端 |

## 获取凭证指引

1. **SDK_APP_ID & SECRET_KEY**：前往 [腾讯云 TRTC 控制台](https://cloud.tencent.com/document/product/647/105439) 开通服务并获取
2. **USER_ID（管理员账号）**：参见 [管理员账号管理](https://cloud.tencent.com/document/product/647/117216)
3. **COS 存储桶**：前往 [腾讯云 COS 控制台](https://console.cloud.tencent.com/cos) 创建

## 环境要求

- Node.js >= 18
- pnpm >= 8
- 现代浏览器（Chrome / Firefox / Edge / Safari）
