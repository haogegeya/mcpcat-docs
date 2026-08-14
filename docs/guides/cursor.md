# Cursor 接入指南

> AI-first 代码编辑器，深度集成 MCP 协议

## 📋 前置准备

1. 安装 [Cursor](https://cursor.sh/)（最新版，0.40+）
2. 已注册 [MCPCat](https://mcpcat.cn) 账号
3. 已创建 API Key

---

## ⚙️ 配置步骤

### 方式 1：UI 配置（推荐）

#### Step 1：进入设置

打开 Cursor，按 `Cmd+,`（macOS）或 `Ctrl+,`（Windows）打开设置。

#### Step 2：找到 MCP 配置

导航路径：
- **Settings** → **Features** → **Model Context Protocol**

#### Step 3：添加新服务器

点击「**+ Add New MCP Server**」按钮，填写：

| 字段 | 值 |
|------|-----|
| **Name** | `mcpcat` |
| **Type** | `http` |
| **URL** | `https://mcp.mcpcat.cn/v1/mcp` |
| **Headers** | `Authorization: Bearer mcpc_sk_xxxxx` |

#### Step 4：保存

点击「**Save**」，Cursor 会自动连接并加载工具列表。

#### Step 5：验证

- 状态应显示 **🟢 Connected**
- 工具列表应展示你已勾选的 MCPCat 工具

---

### 方式 2：手动编辑配置文件

#### 配置文件位置

| 系统 | 路径 |
|------|------|
| **macOS** | `~/.cursor/mcp.json` |
| **Linux** | `~/.cursor/mcp.json` |
| **Windows** | `%USERPROFILE%\.cursor\mcp.json` |

#### 创建/编辑文件

```bash
# macOS / Linux
mkdir -p ~/.cursor
nano ~/.cursor/mcp.json
```

配置内容：

```json
{
  "mcpServers": {
    "mcpcat": {
      "url": "https://mcp.mcpcat.cn/v1/mcp",
      "headers": {
        "Authorization": "***"
      }
    }
  }
}
```

> ⚠️ 把 `mcpc_sk_xxxxx` 替换为你的真实 API Key。

保存后重启 Cursor。

---

## 💬 使用示例

### 在 Composer 中使用

按 `Cmd+I`（macOS）或 `Ctrl+I`（Windows）打开 Composer：

> "用 Python 写一个脚本，调用 MCPCat 查北京天气，输出温度和天气状况"

Composer 会自动：
1. 识别 MCPCat 工具可用
2. 调用 `weather_query(cityname="北京")`
3. 编写 Python 代码整合调用

### 在 Chat 中使用

按 `Cmd+L` 打开 Chat：

> "我有个 Node.js 项目需要展示用户所在城市的天气，帮我用 MCPCat 实现"

Chat 会调用 MCPCat 查询示例城市，然后给出集成代码。

### 在 Agent 模式使用

开启 Agent 模式（Composer 右下角切换）：

> "我需要做一个 demo：用户输入手机号，显示归属地。帮我从 0 写一个 React + Node.js 项目，用 MCPCat 实现归属地查询"

Agent 会：
1. 创建项目结构
2. 编写前端表单
3. 编写后端 API 代理（保护 Key）
4. 集成 MCPCat SDK
5. 测试运行

---

## 🎨 高级配置

### 多个环境隔离

为开发/测试/生产创建不同 Key：

```json
{
  "mcpServers": {
    "mcpcat-dev": {
      "url": "https://mcp.mcpcat.cn/v1/mcp",
      "headers": {"Authorization": "Bearer mcpc_sk_dev_xxxxx"}
    },
    "mcpcat-prod": {
      "url": "https://mcp.mcpcat.cn/v1/mcp",
      "headers": {"Authorization": "Bearer mcpc_sk_prod_xxxxx"}
    }
  }
}
```

### 与其他 MCP 服务器组合

```json
{
  "mcpServers": {
    "mcpcat": {
      "url": "https://mcp.mcpcat.cn/v1/mcp",
      "headers": {"Authorization": "Bearer mcpc_sk_xxxxx"}
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/Users/you/projects"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {"GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxxxx"}
    }
  }
}
```

---

## 🆘 常见问题

### ❌ Type 字段应该填什么？

填 `http`（Streamable HTTP 传输）。

- ❌ 不要填 `sse`（Server-Sent Events 旧协议）
- ❌ 不要填 `stdio`（本地进程通信，MCPCat 不支持）
- ✅ 填 `http`

### ❌ 配置后没看到工具？

1. 在 Composer 中点击 🔧 工具图标，确认 mcpcat 已启用
2. 重新加载窗口：`Cmd+Shift+P` → "Developer: Reload Window"
3. 检查网络：`curl -I https://mcp.mcpcat.cn`

### ❌ Composer 没有调用工具？

在提示中**明确要求**：

> "**用 MCPCat 工具**查北京天气"

或者：

> "用 mcpcat 的 weather_query 工具查北京天气"

### ❌ 看到 "Server disconnected" 错误？

- 检查 API Key 是否有效
- 检查钱包余额
- 临时关闭 VPN 试试
- 查看 Cursor 输出日志：`Help` → `Toggle Developer Tools` → Console

### ❌ 工具调用频繁失败？

- 确认 API Key 速率限制（默认 60 次/分钟）
- 查看 [错误码文档](../api/error-codes.md)
- 联系 support@mcpcat.cn

---

## 📚 相关文档

- [快速开始](../getting-started/quickstart.md) — 5 分钟接入
- [Claude Desktop](claude-desktop.md) — 另一个客户端
- [Cline](cline.md) — VS Code 内的 AI Agent
- [工具列表](../tools/README.md) — 全部可用工具

---

> 🐱 Cursor + MCPCat = AI 编程 + AI 工具双重 Buff
