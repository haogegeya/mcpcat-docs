# initialize 握手

> MCP 协议握手方法，建立客户端与服务端的连接

## 概述

`initialize` 是 MCP 协议的第一个调用，用于：

- 协商协议版本
- 交换客户端/服务端能力
- 获取服务端信息

**必须在任何其他方法之前调用。**

---

## 请求

### 方法名

```
initialize
```

### 参数

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `protocolVersion` | string | ✅ | MCP 协议版本，当前 `2024-11-05` |
| `capabilities` | object | ✅ | 客户端能力声明，MCPCat 当前忽略此字段 |
| `clientInfo` | object | ✅ | 客户端标识信息 |
| `clientInfo.name` | string | ✅ | 客户端名称（如 `claude-desktop`） |
| `clientInfo.version` | string | ✅ | 客户端版本号 |

### 请求示例

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "initialize",
  "params": {
    "protocolVersion": "2024-11-05",
    "capabilities": {},
    "clientInfo": {
      "name": "claude-desktop",
      "version": "1.0.0"
    }
  }
}
```

### curl 示例

```bash
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
      "clientInfo": {"name": "test-client", "version": "1.0.0"}
    }
  }'
```

---

## 响应

### 成功响应

| 字段 | 类型 | 说明 |
|------|------|------|
| `protocolVersion` | string | 协商后的协议版本 |
| `capabilities` | object | 服务端能力，当前固定为 `{"tools": {}}` |
| `serverInfo` | object | 服务端信息 |
| `serverInfo.name` | string | 服务端名称，固定为 `mcpcat` |
| `serverInfo.version` | string | 服务端版本号 |

### 响应示例

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "protocolVersion": "2024-11-05",
    "capabilities": {
      "tools": {}
    },
    "serverInfo": {
      "name": "mcpcat",
      "version": "1.0.0"
    }
  }
}
```

### Python SDK 示例

```python
import httpx
import asyncio

async def initialize():
    async with httpx.AsyncClient() as client:
        response = await client.post(
            "https://mcp.mcpcat.cn/v1/mcp",
            headers={
                "Content-Type": "application/json",
                "Accept": "application/json, text/event-stream",
                "Authorization": "Bearer mcpc_sk_xxxxx"
            },
            json={
                "jsonrpc": "2.0",
                "id": 1,
                "method": "initialize",
                "params": {
                    "protocolVersion": "2024-11-05",
                    "capabilities": {},
                    "clientInfo": {
                        "name": "my-client",
                        "version": "1.0.0"
                    }
                }
            }
        )
        return response.json()

result = asyncio.run(initialize())
print(result)
```

### JavaScript SDK 示例

```javascript
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StreamableHTTPClientTransport } from "@modelcontextprotocol/sdk/client/streamableHttp.js";

const transport = new StreamableHTTPClientTransport(
  new URL("https://mcp.mcpcat.cn/v1/mcp"),
  {
    requestInit: {
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json, text/event-stream",
        "Authorization": "Bearer mcpc_sk_xxxxx"
      }
    }
  }
);

const client = new Client(
  { name: "my-client", version: "1.0.0" },
  { capabilities: {} }
);

await client.connect(transport);
const serverInfo = client.getServerVersion();
console.log(serverInfo);
```

---

## 🔄 协议版本

MCPCat 当前支持的 MCP 协议版本：

| 版本 | 状态 | 说明 |
|------|------|------|
| `2024-11-05` | ✅ 当前 | MCP 协议标准版本 |

**版本协商策略**：

- 客户端发送的 `protocolVersion` 等于或早于服务端支持的版本 → 使用客户端版本
- 客户端发送的 `protocolVersion` 晚于服务端支持的版本 → 使用服务端最新版本
- 不识别的版本 → 使用服务端最新版本

---

## ⚠️ 注意事项

### 1. 必须最先调用

所有其他方法（`tools/list`、`tools/call` 等）**必须**在 `initialize` 成功之后调用，否则会返回 `-32603 Internal error`。

### 2. 重复调用是允许的

重复调用 `initialize` 不会产生副作用，但**不推荐**。SDK 通常会在连接时自动调用一次。

### 3. capabilities 当前是占位

MCPCat 当前只支持 `tools` 能力，`resources` 和 `prompts` 暂未实现。客户端能力声明 MCPCat 会忽略，不影响协议握手。

### 4. 无需保存 session

MCPCat 是无状态的，每次调用都通过 API Key 鉴权，无需保存 session token。

---

## 🆘 错误处理

### 协议版本不识别

如果协议版本完全不识别，会回退到服务端最新版本，并在日志中记录。

### 其他错误

见 [错误码文档](error-codes.md)。

---

## 📚 相关文档

- [API 概览](README.md)
- [认证](authentication.md)
- [tools/list](tools-list.md)
- [tools/call](tools-call.md)

---

> 🐱 一次握手，无限可能
