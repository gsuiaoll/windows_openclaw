# OpenClaw Windows 安装指南

本指南介绍如何在 Windows 系统上安装和运行 OpenClaw。

## 系统要求

- **操作系统**: Windows 10/11
- **Node.js**: v22.12.0 或更高版本
- **pnpm**: v8.0.0 或更高版本（可选，推荐）
- **Git**: 用于克隆仓库（可选）

## 快速安装

### 方法一：自动安装（推荐）

1. **下载 Node.js**
   
   访问 [https://nodejs.org/](https://nodejs.org/) 下载并安装 Node.js v22.12.0+
   
   安装完成后，打开 PowerShell 或 CMD 验证：
   ```cmd
   node -v
   ```

2. **克隆或下载 OpenClaw**
   
   ```cmd
   git clone https://github.com/openclaw/openclaw.git
   cd openclaw
   ```
   
   或者直接下载 ZIP 文件并解压。

3. **运行安装脚本**
   
   双击运行 `install.bat`，或在命令行中执行：
   ```cmd
   install.bat
   ```
   
   安装脚本会自动：
   - 检查 Node.js 和 pnpm
   - 安装依赖
   - 构建项目
   - 创建配置目录
   - （可选）添加防火墙规则
   - （可选）安装开机启动服务

### 方法二：手动安装

1. **安装 Node.js**
   
   从 [https://nodejs.org/](https://nodejs.org/) 下载并安装

2. **安装 pnpm**
   ```cmd
   npm install -g pnpm
   ```

3. **安装依赖**
   ```cmd
   pnpm install --ignore-scripts
   ```

4. **构建项目**
   ```cmd
   pnpm build
   ```

5. **创建配置目录**
   ```cmd
   mkdir %USERPROFILE%\.openclaw
   ```

## 运行 OpenClaw

### 启动 OpenClaw

有几种方式可以启动 OpenClaw：

**方式 1：使用 Windows 启动脚本（推荐）**
```cmd
openclaw.cmd
```

**方式 2：直接使用 Node.js**
```cmd
node openclaw.mjs
```

**方式 3：使用 pnpm（开发模式）**
```cmd
pnpm start
```

**方式 4：使用开发脚本**
```cmd
node scripts/run-node.mjs
```

### 验证安装

运行以下命令查看 OpenClaw 是否正常工作：
```cmd
node openclaw.mjs --version
```

## 配置

### 配置文件位置

OpenClaw 的配置文件位于：
```
%USERPROFILE%\.openclaw\openclaw.json
```

即：
```
C:\Users\<你的用户名>\.openclaw\openclaw.json
```

### 环境变量

可以通过环境变量自定义配置：

- `OPENCLAW_HOME`: 配置目录路径（默认：`%USERPROFILE%\.openclaw`）
- `OPENCLAW_STATE_DIR`: 状态数据目录
- `OPENCLAW_CONFIG_PATH`: 配置文件路径
- `OPENCLAW_GATEWAY_PORT`: 网关端口（默认：18789）
- `OPENCLAW_PROFILE`: 运行配置文件

示例（PowerShell）：
```powershell
$env:OPENCLAW_HOME="D:\OpenClaw\config"
node openclaw.mjs
```

示例（CMD）：
```cmd
set OPENCLAW_HOME=D:\OpenClaw\config
node openclaw.mjs
```

## Windows 特定功能

### 防火墙配置

OpenClaw 网关服务需要防火墙规则才能接受外部连接。

**添加防火墙规则：**
```cmd
scripts\add-firewall-rule.bat
```

**移除防火墙规则：**
```cmd
scripts\remove-firewall-rule.bat
```

**注意：** 这些脚本可能需要管理员权限。右键点击脚本，选择"以管理员身份运行"。

### 开机自动启动

**安装开机启动服务：**
```cmd
scripts\install-service.bat
```

这会将 OpenClaw 注册为 Windows 计划任务，在登录时自动启动。

**卸载开机启动服务：**
```cmd
scripts\uninstall-service.bat
```

### 控制台 UI

OpenClaw 提供多种控制台 UI 选项：

**TUI（文本用户界面）：**
```cmd
node openclaw.mjs tui
```

**Web Dashboard：**
启动网关后，访问 http://localhost:18789

## 常见问题

### Q: "找不到 node.exe"

**解决方案：**
1. 确保 Node.js 已正确安装
2. 验证 Node.js 在 PATH 中：`where node`
3. 重新安装 Node.js

### Q: "权限被拒绝"

**解决方案：**
1. 以管理员身份运行 CMD/PowerShell
2. 右键点击脚本，选择"以管理员身份运行"

### Q: "防火墙规则添加失败"

**解决方案：**
1. 手动添加防火墙规则：
   - 打开"Windows Defender 防火墙"
   - 点击"高级设置"
   - 添加入站规则，允许 node.exe

### Q: 中文乱码

**解决方案：**
确保命令行使用 UTF-8 编码：
```cmd
chcp 65001
```

### Q: 路径太长错误

**解决方案：**
Windows 有路径长度限制。可以：
1. 将项目放在较短的路径（如 `C:\openclaw`）
2. 启用 Windows 长路径支持（组策略或注册表）

## 开发

### 开发模式

```cmd
pnpm dev
```

这会自动监听源代码变化并重新构建。

### 运行测试

```cmd
pnpm test
```

### 构建

```cmd
pnpm build
```

## 卸载

1. **停止所有运行的进程**
   ```cmd
   taskkill /F /IM node.exe
   ```

2. **卸载服务**
   ```cmd
   scripts\uninstall-service.bat
   ```

3. **删除配置目录**
   ```cmd
   rmdir /s /q %USERPROFILE%\.openclaw
   ```

4. **删除项目文件**
   直接删除 openclaw 文件夹即可。

## 获取帮助

- 文档：[docs/index.md](docs/index.md)
- GitHub Issues: https://github.com/openclaw/openclaw/issues
- 社区讨论：查看文档中的频道列表

## 更新

```cmd
git pull
pnpm install
pnpm build
```

或者重新运行安装脚本：
```cmd
install.bat
```

---

**注意：** OpenClaw 的 Windows 支持仍在不断改进中。如果遇到问题，请提交 Issue 或 Pull Request。
