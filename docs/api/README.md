# 🛠️ API 参考

> MCPCat 网关 API 完整参考文档

MCPCat 网关实现 **MCP JSON-RPC 2.0 协议**，通过单一 HTTP 端点暴露：

```
POST https://mcp.mcpcat.cn/v1/mcp
```

支持 **Streamable HTTP** 传输方式。

---

## 📑 API 索引

| 端点 / 方法 | 文档 | 说明 |
|------------|------|------|
| 通用认证 | [authentication.md](authentication.md) | API Key / JWT 双凭证体系 |
| `initialize` | [initialize.md](initialize.md) | 握手协议 |
| `tools/list` | [tools-list.md](tools-list.md) | 列出可用工具 |
| `tools/call` | [tools-call.md](tools-call.md) | 调用工具 |
| 错误处理 | [error-codes.md](error-codes.md) | 错误码参考 |
| 计费规则 | [billing.md](billing.md) | MCoin 计费详细说明 |

---

## 🔌 通用规范

### Base URL

```
https://mcp.mcpcat.cn/v1/mcp
```

### 传输方式

- **Transport**: Streamable HTTP
- **Content-Type**: `application/json`
- **Accept**: `application/json, text/event-stream`
- **HTTP Method**: `POST`（所有方法都通过 POST 发送）

### 认证方式

所有请求必须在 HTTP Header 中携带 Bearer Token：

```
Authorization: Bearer mcpc_sk_xxxxx
```

> 详细说明见 [认证文档](authentication.md)

### 请求格式

所有请求遵循 JSON-RPC 2.0 规范：

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "tools/list",
  "params": {}
}
```

| 字段 | 必填 | 说明 |
|------|------|------|
| `jsonrpc` | ✅ | 固定值 `"2.0"` |
| `id` | ✅ | 请求 ID，任意可区分的字符串/数字 |
| `method` | ✅ | 方法名，如 `tools/list` |
| `params` | ❌ | 方法参数（对象或数组） |

### 响应格式

#### 成功响应

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    // 方法特定的返回数据
  }
}
```

#### 错误响应

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "error": {
    "code": -32601,
    "message": "未知方法: foo/bar"
  }
}
```

### 错误码

| 错误码 | 含义 |
|--------|------|
| `-32700` | Parse error（JSON 解析失败）|
| `-32600` | Invalid Request（请求格式错误）|
| `-32601` | Method not found |
| `-32602` | Invalid params（参数错误）|
| `-32603` | Internal error（服务器内部错误）|
| `-32001` | 未授权（API Key 无效）|
| `-32002` | 工具未启用 |
| `-32003` | 余额不足 |
| `-32004` | 速率限制 |
| `-32005` | 上游 API 错误 |
| `-32006` | 调用超时 |

> 详细说明见 [错误码文档](error-codes.md)

---

## 📨 主要方法

### 1. initialize

握手协议，建立客户端与服务端的连接。

**请求**：

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

**响应**：

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

详见 [initialize.md](initialize.md)

---

### 2. tools/list

列出当前 API Key 可用的所有工具（用户在控制台勾选的）。

**请求**：

```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "tools/list"
}
```

**响应**：

```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "result": {
    "tools": [
      {
        "name": "weather_query",
        "description": "查询指定城市的天气信息",
        "inputSchema": {
          "type": "object",
          "properties": {
            "cityname": {
              "type": "string",
              "description": "城市名称"
            }
          },
          "required": ["cityname"]
        }
      }
    ]
  }
}
```

详见 [tools-list.md](tools-list.md)

---

### 3. tools/call

调用指定的工具。

**请求**：

```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "method": "tools/call",
  "params": {
    "name": "weather_query",
    "arguments": {
      "cityname": "北京"
    }
  }
}
```

**响应**：

```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "result": {
    "content": [
      {
        "type": "text",
        "text": "北京今天晴，温度 18-26°C，东南风 2 级。"
      }
    ],
    "isError": false
  }
}
```

详见 [tools-call.md](tools-call.md)

---

## 💰 计费机制

工具调用采用**预扣 + 失败回滚**机制：

```
1. 查工具定价（sell_mcoin）
2. 余额检查
3. 事务：预扣 MCoin
4. 执行 API 调用
5. 成功：标记成功
   失败：自动退款
```

详细说明见 [billing.md](billing.md)

---

## 🔒 安全

- ✅ HTTPS 强制
- ✅ API Key 哈希存储
- ✅ Bearer Token 鉴权
- ✅ 四层限流（IP/Key/User/Tool）
- ✅ 风控冻结
- ⚠️ 当前版本**不**支持重放攻击防护（nonce + timestamp），v1.0 上线前补齐

---

## 🧪 调试

### MCP Inspector（推荐）

```bash
npx -y @modelcontextprotocol/inspector@latest
```

访问 `http://localhost:6274`，Transport 选 Streamable HTTP，URL 填 `https://mcp.mcpcat.cn/v1/mcp`。

### curl

```bash
curl -X POST https://mcp.mcpcat.cn/v1/mcp \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer mcpc_sk_xxxxx" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"curl","version":"1.0"}}}'
```

---

## 📚 相关文档

- [快速开始](../getting-started/quickstart.md) — 5 分钟接入
- [认证说明](../getting-started/authentication.md) — API Key 与 JWT
- [客户端接入](../guides/README.md) — 各种客户端配置
- [工具列表](../tools/README.md) — 全部可用工具

---

> 🐱 标准化协议，让集成更简单
