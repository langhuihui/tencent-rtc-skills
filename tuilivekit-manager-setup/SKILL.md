---
name: tuilivekit-manager-setup
description: "TUILiveKit Manager 本地 Demo 一键搭建技能。当用户想要搭建、启动、运行或部署 TUILiveKit Manager 直播间管理系统的本地 Demo 时，应使用此技能。此技能引导完成环境检测、依赖安装、服务端配置、前端配置和服务启动的完整流程。适用于用户提及搭建demo、运行项目、启动TUILiveKit、直播管理后台搭建、本地开发环境等场景。"
---

# TUILiveKit Manager 本地 Demo 搭建

## 概述

TUILiveKit Manager 是一套直播间管理系统，提供直播监控、直播间管理、礼物配置、直播间控制台等完整的直播运营管理能力。此技能引导完成从零搭建本地 Demo 的全部步骤。

## 跨平台说明

此技能同时提供 Bash（macOS/Linux）和 Bat 批处理（Windows）脚本。根据用户操作系统选择对应脚本：

| 操作系统 | 脚本后缀 | 调用方式 |
|----------|----------|----------|
| macOS / Linux | `.sh` | `bash {SKILL_DIR}/scripts/xxx.sh` |
| Windows | `.bat` | `"{SKILL_DIR}\scripts\xxx.bat"` |

通过检测 OS 环境信息（user_info 中的 OS Version）来判断用户系统，自动选择对应脚本。`{SKILL_DIR}` 为此技能所在的目录绝对路径。

## 搭建流程

按以下步骤依次执行，每完成一步确认成功后再进入下一步。

### 第一步：环境检测与自动安装

在开始前检测运行环境，缺少的工具自动安装，无需用户手动操作：

1. **检查并自动安装 Git**：运行 `git --version`，若未安装则根据操作系统自动安装：
   - **macOS**：运行 `xcode-select --install`（系统自带 Git 安装方式，若失败则尝试 `brew install git`）
   - **Windows**：运行 `winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements`（winget 是 Windows 10/11 自带包管理器）
   - **Linux**：运行 `sudo apt install -y git`（Debian/Ubuntu）或 `sudo yum install -y git`（CentOS/RHEL）
   
   安装完成后重新运行 `git --version` 验证安装成功。

2. **检查并自动安装 Node.js**：运行 `node -v`，若未安装或版本低于 18，则使用 CodeBuddy 内置的 `install_binary` 工具安装 Node.js 20（LTS）：
   - 调用 `install_binary(type="node", version="20.19.0")` 自动安装
   - 安装完成后重新运行 `node -v` 验证版本 >= 18

3. **检查并自动安装 pnpm**：运行 `pnpm -v`，若未安装或版本低于 8，运行 `npm install -g pnpm` 自动安装，安装完成后验证。

4. **确认项目路径**：确认当前工作目录为 TUILiveKit Manager 项目根目录（包含 `pnpm-workspace.yaml` 和 `packages/` 目录）。若不在项目目录，使用 Git 自动克隆：
   ```bash
   git clone https://github.com/Tencent-RTC/TUILiveKit_Manager
   cd TUILiveKit_Manager
   ```

### 第二步：安装依赖

运行依赖安装：

```bash
pnpm install
```

等待安装完成，确认没有错误。若遇到网络问题，建议配置镜像源后重试：
```bash
pnpm config set registry https://registry.npmmirror.com
```

### 第三步：收集用户凭证

向用户收集以下必填信息（一次性提问，使用 ask_followup_question 或直接在对话中询问）：

**必填项**：
- **SDK_APP_ID**：腾讯云 SDKAppID（数字）
- **SECRET_KEY**：腾讯云 SecretKey

> 如何获取凭证：
> - SDK_APP_ID 和 SECRET_KEY：前往 [腾讯云 TRTC 控制台](https://cloud.tencent.com/document/product/647/105439) 开通服务获取
> - 管理员账号：参见 [管理员账号管理](https://cloud.tencent.com/document/product/647/117216)
>
> 详细配置项说明可参考 `references/config_guide.md`

### 第四步：配置服务端

服务端配置文件路径为 `packages/server/config/.env`，项目已提供默认模板，只需修改 SDK_APP_ID 和 SECRET_KEY 两项。

使用脚本自动修改（根据用户系统选择对应脚本）：

**macOS / Linux**：
```bash
bash {SKILL_DIR}/scripts/setup_server_env.sh <project_root> <sdk_app_id> <secret_key>
```

**Windows**：
```cmd
"{SKILL_DIR}\scripts\setup_server_env.bat" <project_root> <sdk_app_id> <secret_key>
```

参数说明：
- `project_root`：项目根目录的绝对路径
- `sdk_app_id`：用户提供的 SDKAppID
- `secret_key`：用户提供的 SecretKey

> 图片上传功能（COS 或自定义上传）为可选配置。不配置不影响核心功能，前端会自动降级为 URL 手动输入模式。如需配置，参考 `references/config_guide.md` 中的"图片上传"章节。

### 第五步：启动服务端

1. **检查端口占用**（默认端口 9000）：

   **macOS / Linux**：
   ```bash
   bash {SKILL_DIR}/scripts/check_port.sh 9000
   ```

   **Windows**：
   ```cmd
   "{SKILL_DIR}\scripts\check_port.bat" 9000
   ```

   若端口被占用，提示用户关闭占用进程或在 `packages/server/config/.env` 中修改 PORT。

2. **启动服务端**：
   ```bash
   pnpm run start:server
   ```
   等待看到服务启动成功的日志输出。

### 第六步：启动前端

**默认启动 Vue 前端**，无需询问用户。仅当用户在对话中明确指定使用 React 时才启动 React 版本。

- **Vue（默认）**：
  ```bash
  pnpm run dev:vue
  ```
  对应配置文件 `packages/vue3/.env`。

- **React（仅用户明确指定时）**：
  ```bash
  pnpm run dev:react
  ```
  对应配置文件 `packages/react/.env`。

前端 `.env` 文件已默认配置 `VITE_API_BASE_URL=http://localhost:9000/api`，无需额外修改。若服务端修改了 PORT，需同步修改对应前端目录 `.env` 中的端口号。

启动成功后，在浏览器中打开显示的本地地址（通常是 `http://localhost:5173`）即可访问直播管理系统。

### 第七步：验证

启动完成后进行基本验证：
1. 确认浏览器能正常打开管理页面
2. 确认页面能正常加载，无 API 连接错误
3. 告知用户系统功能：直播监控、直播间管理、礼物配置

## 常见问题处理

| 问题 | 解决方案 |
|------|---------|
| Git 自动安装失败 | macOS 尝试 `brew install git`；Windows 确认 winget 可用或手动从 https://git-scm.com 下载；Linux 确认有 sudo 权限 |
| Node.js 自动安装失败 | 确认 install_binary 工具可用，或手动从 https://nodejs.org/ 下载 LTS 版本 |
| `git clone` 失败 | 检查网络连接；国内用户可尝试镜像地址 |
| `pnpm install` 失败 | 检查网络连接，尝试 `pnpm config set registry https://registry.npmmirror.com` |
| 服务端启动失败提示端口占用 | 运行端口检查脚本查看占用进程，关闭后重试或更换端口 |
| 前端页面 API 请求 401/403 | 检查 SDK_APP_ID、SECRET_KEY 是否正确配置 |
| 前端页面无法连接后端 | 确认 `packages/vue3/.env` 中 VITE_API_BASE_URL 端口号与服务端 PORT 一致 |
| 图片上传不可用 | 正常降级行为，如需使用需配置 STORAGE_PROVIDER（参考 config_guide.md） |

## 注意事项

- 服务端和前端需要分别在两个终端中运行
- 服务端默认端口 9000，前端开发服务器默认端口 5173
- 使用 pnpm 作为包管理器，不要使用 npm 或 yarn
- SECRET_KEY 是敏感信息，不要提交到版本控制系统
