# 🚀 快速开始

> 5 分钟接入 MCPCat，让你的 AI Agent 真正能干活

## 📋 前置要求

- 一个支持 MCP 协议的 AI 客户端（Claude Desktop / Cursor / Cline / OpenClaw 等）
- 一个 MCPCat 账号（[注册地址](https://mcpcat.cn/register)）
- 5 分钟时间

---

## 🎯 接入流程

### Step 1：注册账号

访问 [mcpcat.cn](https://mcpcat.cn/register) 注册账号。

- 邮箱 + 密码即可，**30 秒搞定**
- 注册成功即送 **100 MCoin** 体验额度
- 可调用大部分付费工具几十次

---

### Step 2：创建 API Key

登录后进入「[API Key 管理](https://mcpcat.cn/console/keys)」：

1. 点击「**+ 创建 API Key**」
2. 填写名称（用于区分用途，如"Claude Desktop"、"Cursor"）
3. 设置速率限制（默认 60 次/分钟）
4. 点击「**创建**」
5. ⚠️ **立即复制明文 Key**（只显示一次！）

Key 格式：
```
mcpc_sk_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

> 🔒 MCPCat 仅保存 Key 的 SHA-256 哈希值，明文丢失需重新创建。

---

### Step 3：配置 MCP 客户端

根据你使用的客户端，选择对应配置：

#### Claude Desktop

编辑配置文件：

- **macOS**：`~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**：`%APPDATA%\Claude\claude_desktop_config.json`
- **Linux**：`~/.config/Claude/claude_desktop_config.json`

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

保存后重启 Claude Desktop。

#### Cursor

进入「Settings → Features → Model Context Protocol」：

- 点击「**+ Add New MCP Server**」
- **Name**：`mcpcat`
- **Type**：`http`
- **URL**：`https://mcp.mcpcat.cn/v1/mcp`
- **Headers**：`Authorization: Bearer mcpc_sk_xxxxx`

#### Cline

编辑 Cline MCP 配置文件（通常在 IDE 设置中找到）：

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

#### OpenClaw

在 OpenClaw 配置目录的 `mcp.json`：

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

> 📚 更多客户端接入详见 [客户端接入指南](../guides/README.md)

---

### Step 4：勾选工具

登录 MCPCat 控制台「[工具市场](https://mcpcat.cn/console/tools)」：

1. 浏览 12+ 可用工具
2. 勾选你想启用的工具
3. 点击「**保存**」
4. 立即生效，无需重启客户端

> 💡 **小贴士**：建议先用免费工具（天气、IP 归属）测试接入是否成功。

---

### Step 5：开始使用

重启你的 AI 客户端，对 AI 说：

> "帮我查一下北京今天的天气"

AI 会自动调用 MCPCat 的天气工具，几秒后返回结果：

> 北京今天晴，温度 18-26°C，东南风 2 级，空气质量良。

检查你的 MCPCat 钱包：

- 免费工具：**不扣费**
- 付费工具：自动从余额扣 MCoin
- 调用失败：**自动退款**

---

## ✅ 验证接入

### 方法 1：用 curl 测试

```bash
# 1. initialize 握手
curl -X POST https://mcp.mcpcat.cn/v1/mcp \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer mcpc_sk_你的key" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "initialize",
    "params": {
      "protocolVersion": "2024-11-05",
      "capabilities": {},
      "clientInfo": {
        "name": "test-client",
        "version": "1.0.0"
      }
    }
  }'
```

成功响应：
```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "protocolVersion": "2024-11-05",
    "capabilities": {"tools": {}},
    "serverInfo": {
      "name": "mcpcat",
      "version": "1.0.0"
    }
  }
}
```

### 方法 2：用 MCP Inspector

官方可视化调试工具：

```bash
npx -y @modelcontextprotocol/inspector@latest
```

- Transport 选 `Streamable HTTP`
- URL 填 `https://mcp.mcpcat.cn/v1/mcp`
- Header 加 `Authorization: Bearer <your-key>`
- 打开浏览器 6274 端口测试

---

## 🆘 常见问题

### ❌ 客户端连不上？
1. 检查 API Key 是否正确（`mcpc_sk_` 前缀）
2. 检查 URL 是否正确：`https://mcp.mcpcat.cn/v1/mcp`
3. 检查网络：能否访问 `mcp.mcpcat.cn`
4. 查看客户端日志

### ❌ tools/list 为空？
1. 登录控制台「工具市场」
2. 确认已勾选至少一个工具
3. 确认工具保存成功

### ❌ tools/call 报错？
1. 检查参数是否符合工具定义
2. 查看错误码说明：[错误码](../api/error-codes.md)
3. 联系 support@mcpcat.cn

---

## 📚 下一步

- 📖 [认证说明](authentication.md) — 深入理解 API Key 与 JWT
- 🧠 [核心概念](concepts.md) — MCoin、工具、Adapter
- 🛠️ [API 参考](../api/README.md) — 完整 API 文档
- 🧰 [工具列表](../tools/README.md) — 浏览全部工具

---

> 🐱 接入成功？来 [GitHub 给我们点个 Star](https://github.com/haogegeya/mcpcat-docs) 吧！
