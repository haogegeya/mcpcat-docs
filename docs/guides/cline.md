# Cline 接入指南

> VS Code 中的 AI Agent 扩展，深度支持 MCP

## 📋 前置准备

1. 安装 [VS Code](https://code.visualstudio.com/)（最新版）
2. 在扩展市场安装 [Cline](https://marketplace.visualstudio.com/items?itemName=saoudrizwan.claude-dev)
3. 已注册 [MCPCat](https://mcpcat.cn) 账号
4. 已创建 API Key

---

## ⚙️ 配置步骤

### 方式 1：Cline UI 配置（推荐）

#### Step 1：打开 Cline

点击 VS Code 侧边栏的 Cline 图标（通常在左侧活动栏）。

#### Step 2：进入 MCP 设置

点击 Cline 面板右上角的「MCP Servers」图标（🔌）。

#### Step 3：点击配置按钮

点击「**Configure MCP Servers**」，会自动打开 `cline_mcp_settings.json` 文件。

#### Step 4：添加配置

在 `mcpServers` 字段下添加：

```json
{
  "mcpServers": {
    "mcpcat": {
      "url": "https://mcp.mcpcat.cn/v1/mcp",
      "type": "http",
      "headers": {
        "Authorization": "***"
      }
    }
  }
}
```

> ⚠️ 把 `mcpc_sk_xxxxx` 替换为你的真实 API Key。

#### Step 5：保存

保存 `cline_mcp_settings.json`，Cline 会自动重载配置。

#### Step 6：验证

- 在 Cline 面板的「MCP Servers」区域
- 应看到 **mcpcat** 状态为 **🟢 Connected**
- 展开后能看到工具列表

---

### 方式 2：手动编辑配置文件

#### 配置文件位置

| 系统 | 路径 |
|------|------|
| **macOS** | `~/Library/Application Support/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json` |
| **Linux** | `~/.config/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json` |
| **Windows** | `%APPDATA%\Code\User\globalStorage\saoudrizwan.claude-dev\settingscline_mcp_settings.json` |

#### 创建/编辑文件

```bash
# macOS
mkdir -p ~/Library/Application\ Support/Code/User/globalStorage/saoudrizwan.claude-dev/settings
nano ~/Library/Application\ Support/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json
```

配置内容同上。

---

## 💬 使用示例

### 基础对话

在 Cline 对话框中输入：

> "我有一个 Python 项目在 `~/projects/myapp`，需要查询天气 API 来展示城市天气。帮我用 MCPCat 实现"

Cline 会自动：
1. 浏览项目结构
2. 调用 MCPCat 的 `weather_query` 工具获取示例数据
3. 编写集成代码
4. 测试运行

### 复杂任务

> "我需要做一个工具：用户输入手机号，返回归属地。帮我创建一个完整的项目结构，包括前端表单、后端 API、错误处理，用 MCPCat 实现归属地查询"

Cline 会分步骤完成：
- 创建项目目录
- 编写前端 HTML/JS
- 编写后端 Node.js/Python
- 集成 MCPCat SDK
- 添加输入验证
- 测试整个流程

### 多步任务编排

> "用 MCPCat 查一下 13800138000 的归属地，然后查这个城市的天气，最后用 Python 写一个脚本把两个信息整合输出"

Cline 会：
1. 调用 `phone_attribution(phone="13800138000")` → 拿到归属地
2. 调用 `weather_query(cityname=<城市>)` → 拿到天气
3. 编写整合脚本

---

## 🎨 高级配置

### 与其他 MCP 服务器组合

```json
{
  "mcpServers": {
    "mcpcat": {
      "url": "https://mcp.mcpcat.cn/v1/mcp",
      "type": "http",
      "headers": {"Authorization": "Bearer mcpc_sk_xxxxx"}
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/Users/you/projects"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {"GITHUB_TOKEN": "ghp_xxxxx"}
    }
  }
}
```

### 多个 MCPCat 账号

为不同项目隔离：

```json
{
  "mcpServers": {
    "mcpcat-personal": {
      "url": "https://mcp.mcpcat.cn/v1/mcp",
      "type": "http",
      "headers": {"Authorization": "Bearer mcpc_sk_personal_xxx"}
    },
    "mcpcat-work": {
      "url": "https://mcp.mcpcat.cn/v1/mcp",
      "type": "http",
      "headers": {"Authorization": "Bearer mcpc_sk_work_xxx"}
    }
  }
}
```

---

## 🆘 常见问题

### ❌ 看到 "Server disconnected" 错误？

排查步骤：

1. **检查网络**：
   ```bash
   curl -I https://mcp.mcpcat.cn
   ```

2. **检查 API Key**：登录 [MCPCat 控制台](https://mcpcat.cn/console/keys) 确认 Key 有效

3. **检查余额**：登录控制台 → 钱包，确认有足够 MCoin

4. **查看 Cline 输出日志**：
   - 打开 VS Code 输出面板（`Ctrl+Shift+U` 或 `Cmd+Shift+U`）
   - 下拉选择 "Cline" 或 "MCP"

### ❌ 工具列表为空？

1. 在 Cline 面板的 MCP Servers 区域展开 mcpcat，确认状态
2. 登录 [MCPCat 控制台](https://mcpcat.cn/console/tools) 确认已勾选工具
3. 尝试重新加载：删除 mcpcat 配置后保存 → 重新添加

### ❌ 工具调用失败？

- 查看 [错误码文档](../api/error-codes.md)
- 确认参数名和类型正确（参考 [工具列表](../tools/README.md)）
- 检查网络稳定性

### ❌ Cline 没有自动调用工具？

在提示中**明确要求**：

> "**用 MCPCat 工具**查北京天气"

或者更具体：

> "调用 mcpcat 的 `weather_query` 工具，参数 cityname='北京'"

---

## 💡 进阶玩法

### 让 Cline 自动发现并修复问题

> "我的项目用了 MCPCat 查天气，但有时候返回格式不稳定。帮我加上错误处理和重试机制"

Cline 会：
1. 阅读你的项目代码
2. 调用 MCPCat 测试不同错误情况
3. 编写健壮的错误处理代码

### 用 MCPCat 增强 Cline 工作流

> "我需要批量处理 100 个快递单号，每个都查物流并整理成 Excel。帮我用 MCPCat 写个 Python 脚本"

Cline 会：
1. 调用 `express_query` 工具测试查询
2. 编写批量处理脚本
3. 加上进度显示和错误重试
4. 输出到 Excel

---

## 📚 相关文档

- [快速开始](../getting-started/quickstart.md) — 5 分钟接入
- [Claude Desktop](claude-desktop.md) — 另一个客户端
- [Cursor](cursor.md) — 另一个客户端
- [工具列表](../tools/README.md) — 全部可用工具
- [使用示例](../examples.md) — 实战案例

---

> 🐱 Cline + MCPCat = 拥有真实工具的 AI 程序员
