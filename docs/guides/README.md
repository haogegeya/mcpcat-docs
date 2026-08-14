# 🔌 客户端接入指南

> 各种支持 MCP 协议的客户端如何接入 MCPCat

## 📑 目录

- [Claude Desktop](#claude-desktop)
- [Cursor](#cursor)
- [Cline](#cline)
- [OpenClaw](#openclaw)
- [其他客户端](#其他客户端)
- [MCP Inspector（调试工具）](#mcp-inspector调试工具)

---

## Claude Desktop

> Anthropic 官方桌面客户端，原生支持 MCP 协议

### 📋 前置准备

1. 安装 [Claude Desktop](https://claude.ai/download)（macOS/Windows/Linux）
2. 已注册 [MCPCat](https://mcpcat.cn) 账号
3. 已创建 API Key（[获取方式](../getting-started/quickstart.md#step-2创建-api-key)）

### ⚙️ 配置文件位置

| 系统 | 路径 |
|------|------|
| **macOS** | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| **Windows** | `%APPDATA%\Claude\claude_desktop_config.json` |
| **Linux** | `~/.config/Claude/claude_desktop_config.json` |

### 🔧 配置步骤

1. **关闭 Claude Desktop**

2. **打开配置文件**（如不存在则创建）

3. **添加 MCPCat 配置**：

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

4. **保存文件**

5. **重启 Claude Desktop**

6. **验证配置**：
   - 在 Claude Desktop 中，点击左下角"设置"图标
   - 进入"开发者"或"扩展"页面
   - 应该能看到 "mcpcat" 服务器

### 💬 使用示例

在 Claude Desktop 中对话：

> "帮我查北京今天的天气"

Claude 会自动调用 `weather_query` 工具，返回结果。

### 🆘 常见问题

**Q: 配置后没看到 mcpcat 服务器？**
- 确认 JSON 格式正确（用 JSON 校验工具）
- 确认 API Key 格式正确（`mcpc_sk_` 前缀）
- 重启 Claude Desktop
- 查看日志：macOS `~/Library/Logs/Claude/`

**Q: Claude 提示"无法连接到 mcpcat"？**
- 检查网络能否访问 `mcp.mcpcat.cn`
- 确认 URL 拼写正确（注意是 `/v1/mcp` 不是 `/mcp`）
- 临时关闭代理/VPN 试试

**Q: 工具调用失败？**
- 登录 MCPCat 控制台查看错误日志
- 检查 API Key 余额
- 确认已勾选对应工具

---

## Cursor

> AI-first 代码编辑器，深度集成 MCP 协议

### 📋 前置准备

1. 安装 [Cursor](https://cursor.sh/)（最新版）
2. 已注册 MCPCat 账号
3. 已创建 API Key

### ⚙️ 配置步骤

#### 方式 1：UI 配置（推荐）

1. 打开 Cursor
2. 进入「**Settings**」（macOS: `Cmd+,` / Windows: `Ctrl+,`）
3. 找到「**Features**」→「**Model Context Protocol**」
4. 点击「**+ Add New MCP Server**」
5. 填写：
   - **Name**：`mcpcat`
   - **Type**：`http`
   - **URL**：`https://mcp.mcpcat.cn/v1/mcp`
   - **Headers**：
     ```
     Authorization: Bearer mcpc_sk_xxxxx
     ```
6. 点击「**Save**」

#### 方式 2：手动配置

编辑 `~/.cursor/mcp.json`（macOS/Linux）或 `%APPDATA%\Cursor\mcp.json`（Windows）：

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

### 💬 使用示例

在 Cursor 的 Composer（`Cmd+I` / `Ctrl+I`）中：

> "用 Python 写一个脚本，调用 MCPCat 查北京天气"

Composer 会自动识别可用的 MCP 工具并调用。

### 🆘 常见问题

**Q: 配置后没看到工具？**
- 在 Composer 中点击工具图标，确认 mcpcat 已启用
- 重新加载窗口（`Cmd+Shift+P` → "Reload Window"）

**Q: Type 字段填什么？**
- 填 `http`（Streamable HTTP 传输）
- 不要填 `sse` 或 `stdio`（MCPCat 不支持这两种）

---

## Cline

> VS Code 中的 AI Agent 扩展，深度支持 MCP

### 📋 前置准备

1. 安装 [VS Code](https://code.visualstudio.com/)
2. 在扩展市场安装 [Cline](https://marketplace.visualstudio.com/items?itemName=saoudrizwan.claude-dev)
3. 已注册 MCPCat 账号
4. 已创建 API Key

### ⚙️ 配置步骤

#### 方式 1：Cline UI 配置

1. 打开 VS Code
2. 点击侧边栏的 Cline 图标
3. 点击右上角「MCP Servers」图标
4. 点击「**Configure MCP Servers**」
5. 在打开的 `cline_mcp_settings.json` 中添加：

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

6. 保存文件
7. Cline 会自动加载新配置

#### 方式 2：直接编辑配置文件

配置文件位置：
- **macOS/Linux**：`~/Library/Application Support/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json`
- **Windows**：`%APPDATA%\Code\User\globalStorage\saoudrizwan.claude-dev\settings\cline_mcp_settings.json`

### 💬 使用示例

在 Cline 对话框中：

> "我有一个 Python 项目在 ~/projects/myapp，需要查询天气 API 来展示城市天气，帮我用 MCPCat 实现"

Cline 会自动调用 MCPCat 工具，查询并展示。

### 🆘 常见问题

**Q: 看到 "Server disconnected" 错误？**
- 检查网络连接
- 确认 API Key 有效
- 查看 Cline 输出日志

**Q: 工具列表为空？**
- 在 Cline 设置中确认 mcpcat 已启用
- 登录 MCPCat 控制台确认工具已勾选

---

## OpenClaw

> OpenClaw 个人 AI 助手

### 📋 前置准备

1. 已部署 OpenClaw（参考 OpenClaw 官方文档）
2. 已注册 MCPCat 账号
3. 已创建 API Key

### ⚙️ 配置步骤

在 OpenClaw 配置目录创建/编辑 `mcp.json`：

```bash
# 默认配置目录
~/.openclaw/workspace/mcp.json
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

重启 OpenClaw 服务：

```bash
# 如果用 systemd
systemctl --user restart openclaw

# 如果用 nohup
ps aux | grep openclaw
kill <pid>
nohup openclaw &
```

### 💬 使用示例

在 OpenClaw 对话中：

> "明天去北京出差，帮我查一下北京明天的天气"

OpenClaw 会自动调用 MCPCat 天气工具。

---

## 其他客户端

> 理论上所有支持 MCP Streamable HTTP 协议的客户端都可以接入

### Continue（VS Code / JetBrains）

编辑 `~/.continue/config.json`：

```json
{
  "mcpServers": [
    {
      "name": "mcpcat",
      "url": "https://mcp.mcpcat.cn/v1/mcp",
      "headers": {
        "Authorization": "***"
      }
    }
  ]
}
```

### Zed

编辑 `~/.config/zed/settings.json`：

```json
{
  "context_servers": {
    "mcpcat": {
      "url": "https://mcp.mcpcat.cn/v1/mcp",
      "headers": {
        "Authorization": "***"
      }
    }
  }
}
```

### 自定义 HTTP 客户端

如果你的客户端只支持 stdio，可以用 `mcp-proxy` 等工具转换：

```bash
npx -y mcp-proxy \
  --url https://mcp.mcpcat.cn/v1/mcp \
  --header "Authorization: Bearer mcpc_sk_xxx" \
  --stdio
```

然后配置客户端用 `npx mcp-proxy` 作为 stdio 命令。

### Python SDK

```python
from mcp import ClientSession
import httpx

async with httpx.AsyncClient() as client:
    async with client.stream(
        "POST",
        "https://mcp.mcpcat.cn/v1/mcp",
        headers={"Authorization": "Bearer mcpc_sk_xxx"},
        json={
            "jsonrpc": "2.0",
            "id": 1,
            "method": "tools/list"
        }
    ) as response:
        # 处理流式响应
        pass
```

---

## MCP Inspector（调试工具）

> 官方提供的 MCP 调试可视化工具

### 启动

```bash
npx -y @modelcontextprotocol/inspector@latest
```

默认端口：
- Client UI: `http://localhost:6274`
- Server: `http://localhost:6277`

### 连接 MCPCat

1. Transport 选择 `Streamable HTTP`
2. URL 填：`https://mcp.mcpcat.cn/v1/mcp`
3. 点击「**Add Header**」：
   - Name: `Authorization`
   - Value: `Bearer mcpc_sk_xxxxx`
4. 点击「**Connect**」

### 测试工具

连接成功后可以：

- 看到所有可用工具
- 手动调用 `tools/call` 并填参数
- 查看实时响应
- 调试错误

### 注意事项

- Inspector 会自动创建 Server 进程（默认 6277）
- 通过 `npx` 后台启动容易被会话清理，建议用 `tmux` 或 `screen` 长驻
- 仅用于开发调试，不要用于生产

---

## 🆘 通用问题排查

### 1. 配置不生效

**检查清单**：
- [ ] JSON 格式正确（用 https://jsonlint.com 校验）
- [ ] API Key 完整且正确（`mcpc_sk_` 前缀）
- [ ] URL 正确：`https://mcp.mcpcat.cn/v1/mcp`（带 `/v1/mcp`）
- [ ] 已重启客户端
- [ ] 网络能访问 `mcp.mcpcat.cn`

### 2. 客户端连不上

**排查步骤**：

```bash
# 测试网络连通性
curl -I https://mcp.mcpcat.cn

# 测试 initialize
curl -X POST https://mcp.mcpcat.cn/v1/mcp \
  -H "Authorization: Bearer mcpc_sk_xxx" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"1.0"}}}'
```

### 3. 工具调用失败

**常见原因**：
- 工具未在控制台勾选 → 去 [工具市场](https://mcpcat.cn/console/tools) 勾选
- API Key 余额不足 → 去 [充值](https://mcpcat.cn/console/billing) 页面
- 参数错误 → 参考 [工具文档](../tools/README.md)

### 4. 获取更多帮助

- 📖 [API 错误码](../api/error-codes.md)
- 💬 [MCPCat 用户群](#)
- 📧 邮件：support@mcpcat.cn
- 🐛 [GitHub Issues](https://github.com/haogegeya/mcpcat-docs/issues)

---

## 📚 相关文档

- [快速开始](../getting-started/quickstart.md) — 5 分钟接入
- [认证说明](../getting-started/authentication.md) — API Key 与 JWT
- [API 参考](../api/README.md) — 完整 API 文档
- [工具列表](../tools/README.md) — 全部可用工具

---

> 🐱 选择你的客户端，5 分钟接入 MCPCat！
