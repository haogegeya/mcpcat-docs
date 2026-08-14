# 其他 MCP 客户端接入

> 理论上所有支持 MCP Streamable HTTP 协议的客户端都可以接入 MCPCat

## 📑 本页收录

- [Continue（VS Code / JetBrains）](#continuevs-code--jetbrains)
- [Zed](#zed)
- [Windsurf](#windsurf)
- [Cherry Studio](#cherry-studio)
- [自定义 HTTP 客户端](#自定义-http-客户端)
- [MCP Inspector（调试工具）](#mcp-inspector调试工具)
- [stdio 兼容（mcp-proxy 转换）](#stdio-兼容mcp-proxy-转换)

---

## Continue（VS Code / JetBrains）

> VS Code / JetBrains 系列 IDE 的 AI 代码助手

### VS Code

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

重启 VS Code 即可。

### JetBrains

在 `Settings → Tools → Continue` 中找到 MCP 配置，添加：

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

---

## Zed

> 高性能代码编辑器，原生支持 MCP

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

---

## Windsurf

> Codeium 推出的 AI IDE

在 `Settings → Cascade → Model Context Protocol` 中：

1. 点击「Add MCP Server」
2. 填写：
   - **Name**: `mcpcat`
   - **Server URL**: `https://mcp.mcpcat.cn/v1/mcp`
   - **Headers**: `Authorization: Bearer mcpc_sk_xxxxx`

---

## Cherry Studio

> 国产多模型桌面客户端，支持 MCP

在「设置 → MCP 服务器」中添加：

- **名称**: `mcPCat`
- **URL**: `https://mcp.mcpcat.cn/v1/mcp`
- **认证**: Bearer Token
- **Token**: `mcpc_sk_xxxxx`

---

## 自定义 HTTP 客户端

> 如果你开发自己的 MCP 客户端

### Python SDK

```python
from mcp import ClientSession
import httpx

async with httpx.AsyncClient() as client:
    # initialize 握手
    init_response = await client.post(
        "https://mcp.mcpcat.cn/v1/mcp",
        headers={"Authorization": "Bearer mcpc_sk_xxx"},
        json={
            "jsonrpc": "2.0",
            "id": 1,
            "method": "initialize",
            "params": {
                "protocolVersion": "2024-11-05",
                "capabilities": {},
                "clientInfo": {"name": "my-client", "version": "1.0.0"}
            }
        }
    )
    
    # tools/list
    tools_response = await client.post(
        "https://mcp.mcpcat.cn/v1/mcp",
        headers={"Authorization": "Bearer mcpc_sk_xxx"},
        json={
            "jsonrpc": "2.0",
            "id": 2,
            "method": "tools/list"
        }
    )
    
    # tools/call
    call_response = await client.post(
        "https://mcp.mcpcat.cn/v1/mcp",
        headers={"Authorization": "Bearer mcpc_sk_xxx"},
        json={
            "jsonrpc": "2.0",
            "id": 3,
            "method": "tools/call",
            "params": {
                "name": "weather_query",
                "arguments": {"cityname": "北京"}
            }
        }
    )
```

### JavaScript SDK

```javascript
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StreamableHTTPClientTransport } from "@modelcontextprotocol/sdk/client/streamableHttp.js";

const transport = new StreamableHTTPClientTransport(
  new URL("https://mcp.mcpcat.cn/v1/mcp"),
  {
    requestInit: {
      headers: {
        Authorization: "Bearer mcpc_sk_xxxxx"
      }
    }
  }
);

const client = new Client(
  { name: "my-client", version: "1.0.0" },
  { capabilities: {} }
);

await client.connect(transport);

// 列出工具
const tools = await client.listTools();
console.log(tools);

// 调用工具
const result = await client.callTool({
  name: "weather_query",
  arguments: { cityname: "北京" }
});
console.log(result);
```

### 直接 HTTP 调用

```bash
# initialize
curl -X POST https://mcp.mcpcat.cn/v1/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -H "Authorization: Bearer mcpc_sk_xxxxx" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "initialize",
    "params": {
      "protocolVersion": "2024-11-05",
      "capabilities": {},
      "clientInfo": {"name": "curl", "version": "1.0"}
    }
  }'

# tools/list
curl -X POST https://mcp.mcpcat.cn/v1/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -H "Authorization: Bearer mcpc_sk_xxxxx" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'

# tools/call
curl -X POST https://mcp.mcpcat.cn/v1/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -H "Authorization: Bearer mcpc_sk_xxxxx" \
  -d '{
    "jsonrpc": "2.0",
    "id": 3,
    "method": "tools/call",
    "params": {
      "name": "weather_query",
      "arguments": {"cityname": "北京"}
    }
  }'
```

---

## stdio 兼容（mcp-proxy 转换）

> 如果你的客户端只支持 stdio，可以用 mcp-proxy 转换

### 用法

```bash
npx -y mcp-proxy \
  --url https://mcp.mcpcat.cn/v1/mcp \
  --header "Authorization: Bearer mcpc_sk_xxxxx" \
  --stdio
```

### 客户端配置

```json
{
  "mcpServers": {
    "mcpcat": {
      "command": "npx",
      "args": [
        "-y", "mcp-proxy",
        "--url", "https://mcp.mcpcat.cn/v1/mcp",
        "--header", "Authorization: Bearer mcpc_sk_xxxxx",
        "--stdio"
      ]
    }
  }
}
```

---

## MCP Inspector（调试工具）

> 官方提供的 MCP 调试可视化工具，**强烈推荐**用于排查问题

### 启动

```bash
npx -y @modelcontextprotocol/inspector@latest
```

默认端口：
- Client UI: `http://localhost:6274`
- Server: `http://localhost:6277`

### 连接 MCPCat

1. 打开 `http://localhost:6274`
2. Transport 选择 `Streamable HTTP`
3. URL 填：`https://mcp.mcpcat.cn/v1/mcp`
4. 点击「Add Header」：
   - Name: `Authorization`
   - Value: `Bearer mcpc_sk_xxxxx`
5. 点击「**Connect**」

### 测试工具

连接成功后可以：

- 查看所有可用工具
- 手动调用 `tools/call` 并填参数
- 查看实时 JSON 响应
- 调试认证问题
- 验证参数 schema

### 注意事项

- Inspector 会自动创建 Server 进程（默认 6277）
- 通过 `npx` 后台启动容易被会话清理，建议用 `tmux` / `screen` 长驻：

```bash
# 用 tmux 长驻
tmux new -s mcp-inspector
npx -y @modelcontextprotocol/inspector@latest
# Ctrl+B 然后 D 脱离
```

- 仅用于开发调试，**不要用于生产**

---

## 🆘 通用问题排查

### 1. 配置不生效

- [ ] JSON 格式正确（用 https://jsonlint.com 校验）
- [ ] API Key 完整且正确（`mcpc_sk_` 前缀）
- [ ] URL 正确：`https://mcp.mcpcat.cn/v1/mcp`（带 `/v1/mcp`）
- [ ] 已重启客户端
- [ ] 网络能访问 `mcp.mcpcat.cn`

### 2. 客户端连不上

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

> 🐱 MCP 协议是开放的，MCPCat 兼容所有标准实现
