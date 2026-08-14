# 错误码参考

> MCPCat 网关 API 完整错误码定义

## 📋 错误码分类

| 范围 | 类别 | 说明 |
|------|------|------|
| `-32700` ~ `-32600` | JSON-RPC 标准错误 | 协议级错误 |
| `-32099` ~ `-32000` | MCPCat 自定义错误 | 业务级错误 |
| HTTP 4xx/5xx | 传输层错误 | 网络/HTTP 错误 |

---

## 🚨 JSON-RPC 标准错误

### `-32700` Parse Error

**JSON 解析失败**

```json
{
  "jsonrpc": "2.0",
  "id": null,
  "error": {
    "code": -32700,
    "message": "Parse error"
  }
}
```

**原因**：
- 请求体不是合法 JSON
- Content-Type 错误
- 请求体过大

**处理**：
- 检查 JSON 格式
- 用 https://jsonlint.com 校验

---

### `-32600` Invalid Request

**请求格式错误**

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "error": {
    "code": -32600,
    "message": "Invalid Request: 缺少 jsonrpc 字段"
  }
}
```

**原因**：
- 缺少 `jsonrpc` 字段
- `jsonrpc` 值不是 `"2.0"`
- 请求结构不符合 JSON-RPC 2.0 规范

**处理**：
- 确认请求包含 `jsonrpc: "2.0"`、`id`、`method`

---

### `-32601` Method Not Found

**方法不存在**

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

**原因**：
- 方法名拼写错误
- 调用了未实现的方法

**处理**：
- 参考 [API 概览](README.md) 确认方法名
- 当前仅支持 `initialize` / `tools/list` / `tools/call`

---

### `-32602` Invalid Params

**参数错误**

```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "error": {
    "code": -32602,
    "message": "Invalid params: 缺少必填参数 cityname"
  }
}
```

**常见情况**：

| 错误信息 | 原因 |
|---------|------|
| `缺少必填参数 X` | 必填参数未传 |
| `参数 X 类型错误` | 类型不匹配（如 string 传了 number） |
| `参数 X 值不在枚举范围内` | enum 校验失败 |
| `参数 X 超出范围` | minimum/maximum 校验失败 |

**处理**：
- 参考工具的 `inputSchema`
- 用 [MCP Inspector](../guides/other-clients.md#mcp-inspector调试工具) 调试

---

### `-32603` Internal Error

**服务器内部错误**

```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "error": {
    "code": -32603,
    "message": "Internal error: 数据库连接失败"
  }
}
```

**原因**：
- 数据库异常
- Redis 异常
- 代码 bug

**处理**：
- 稍后重试
- 联系 support@mcpcat.cn 并附上请求 ID

---

## 🔐 MCPCat 自定义错误

### `-32001` Unauthorized

**未授权**

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "error": {
    "code": -32001,
    "message": "未授权：API Key 无效或已过期"
  }
}
```

**可能原因**：

| 场景 | 错误信息 |
|------|---------|
| 缺失 Header | `未授权：缺少 Authorization Header` |
| Key 格式错误 | `未授权：API Key 格式错误` |
| Key 不存在 | `未授权：API Key 无效` |
| Key 已撤销 | `未授权：API Key 已被撤销` |
| IP 不在白名单 | `未授权：IP 不在白名单内` |
| Key 被冻结 | `API Key 已被冻结，请联系 support@mcpcat.cn` |

**处理**：
- 检查 `Authorization: Bearer mcpc_sk_xxx` 是否正确
- 登录 [控制台](https://mcpcat.cn/console/keys) 确认 Key 状态
- 联系 support@mcpcat.cn 解冻

---

### `-32002` Tool Not Enabled

**工具未启用**

```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "error": {
    "code": -32002,
    "message": "工具未启用：weather_query"
  }
}
```

**原因**：
- 工具名拼写错误
- 工具未在控制台勾选
- 工具已下线

**处理**：
- 登录 [工具市场](https://mcpcat.cn/console/tools) 勾选对应工具
- 调用 `tools/list` 查看可用工具

---

### `-32003` Insufficient Balance

**余额不足**

```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "error": {
    "code": -32003,
    "message": "MCoin 余额不足，请前往 https://mcpcat.cn/console/billing 充值"
  }
}
```

**响应 Header 包含**：
```
X-MCoin-Balance: 5
X-MCoin-Required: 10
```

**处理**：
- 前往 [充值页面](https://mcpcat.cn/console/billing)
- 或提示用户："余额不足，请充值"
- 注册新用户有 100 MCoin 赠送

---

### `-32004` Rate Limit

**速率限制**

```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "error": {
    "code": -32004,
    "message": "速率限制超出，请稍后重试",
    "data": {
      "retry_after": 30,
      "limit": 60,
      "window": "1 minute"
    }
  }
}
```

**响应 Header**：
```
Retry-After: 30
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1692012345
```

**限制层级**：

| 层级 | 默认限制 |
|------|---------|
| IP 级 | 300 次/分钟 |
| Key 级 | 60 次/分钟（可配置） |
| User 级 | 200 次/分钟 |
| Tool 级 | 60 次/分钟 |

**处理**：
- 等待 `Retry-After` 秒后重试
- 升级 Key 速率限制
- 使用多个 Key 分散流量

---

### `-32005` Upstream Error

**上游 API 错误**

```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "error": {
    "code": -32005,
    "message": "上游 API 错误：快递单号不存在",
    "data": {
      "upstream": "express_100",
      "upstream_code": "A0100"
    }
  }
}
```

**原因**：
- 快递单号不存在
- 城市名无效
- 身份证号格式错误
- 上游 API 临时故障

**处理**：
- 检查参数是否正确
- 稍后重试
- 更换其他工具

> ⚠️ 此错误**会自动退款**

---

### `-32006` Timeout

**调用超时**

```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "error": {
    "code": -32006,
    "message": "调用超时（30s）"
  }
}
```

**原因**：
- 上游 API 响应过慢
- 网络问题

**处理**：
- 稍后重试
- 联系 support@mcpcat.cn（如频繁出现）

> ⚠️ 此错误**会自动退款**

---

## 🌐 HTTP 错误

### 400 Bad Request

请求格式错误（同 `-32600`）

### 401 Unauthorized

未认证（同 `-32001`）

### 403 Forbidden

权限不足（如 IP 黑名单、Key 被冻结）

### 404 Not Found

路径错误：

```
POST /v1/mcp/foo  → 404 Not Found
```

**处理**：
- 确认 URL 为 `https://mcp.mcpcat.cn/v1/mcp`

### 405 Method Not Allowed

HTTP 方法错误：

```
GET /v1/mcp  → 405 Method Not Allowed
```

**处理**：
- 使用 POST 方法
- MCP 协议所有方法都通过 POST 发送

### 429 Too Many Requests

速率限制（同 `-32004`）

### 500 Internal Server Error

服务器内部错误（同 `-32603`）

### 502 Bad Gateway

上游网关错误

### 503 Service Unavailable

服务暂时不可用

### 504 Gateway Timeout

上游超时

---

## 🛠️ 错误处理最佳实践

### 客户端实现

```python
import httpx

async def call_tool_safely(tool_name, arguments):
    try:
        response = await client.post(
            "https://mcp.mcpcat.cn/v1/mcp",
            headers={"Authorization": "Bearer mcpc_sk_xxx"},
            json={
                "jsonrpc": "2.0",
                "id": 1,
                "method": "tools/call",
                "params": {"name": tool_name, "arguments": arguments}
            },
            timeout=60
        )
        response.raise_for_status()
        result = response.json()
        
        if "error" in result:
            error = result["error"]
            code = error["code"]
            message = error["message"]
            
            if code == -32003:
                # 余额不足 - 提示用户充值
                return {"error": "balance", "message": message}
            elif code == -32004:
                # 速率限制 - 等待重试
                retry_after = error.get("data", {}).get("retry_after", 60)
                await asyncio.sleep(retry_after)
                return await call_tool_safely(tool_name, arguments)
            elif code == -32002:
                # 工具未启用
                return {"error": "tool_disabled", "message": message}
            else:
                return {"error": "api_error", "code": code, "message": message}
        
        return result["result"]
        
    except httpx.HTTPStatusError as e:
        if e.response.status_code == 429:
            # HTTP 层级速率限制
            await asyncio.sleep(60)
            return await call_tool_safely(tool_name, arguments)
        raise
    except httpx.TimeoutException:
        # 网络超时 - 已在 MCPCat 端退款，重试
        return await call_tool_safely(tool_name, arguments)
```

### AI Agent 实现

提示 AI 优雅处理错误：

```markdown
## 错误处理指引

调用 MCPCat 工具时遇到错误：

1. **余额不足 (-32003)**：告知用户「MCoin 余额不足，请前往 https://mcpcat.cn/console/billing 充值」

2. **工具未启用 (-32002)**：提示用户「请先在 https://mcpcat.cn/console/tools 勾选该工具」

3. **参数错误 (-32602)**：检查参数名和类型，参考工具定义

4. **速率限制 (-32004)**：等待 retry_after 秒后自动重试

5. **上游错误 (-32005)**：可能是参数业务上无效（如快递单号不存在），换个方式询问用户

6. **网络超时**：稍后重试
```

---

## 📊 错误码速查表

| 错误码 | 名称 | 自动退款 | 客户端处理 |
|--------|------|---------|----------|
| `-32700` | Parse Error | 否 | 检查 JSON |
| `-32600` | Invalid Request | 否 | 检查请求格式 |
| `-32601` | Method Not Found | 否 | 检查方法名 |
| `-32602` | Invalid Params | 否 | 检查参数 |
| `-32603` | Internal Error | 否 | 重试 / 联系支持 |
| `-32001` | Unauthorized | 否 | 检查 API Key |
| `-32002` | Tool Not Enabled | 否 | 提示用户勾选 |
| `-32003` | Insufficient Balance | 否 | 提示充值 |
| `-32004` | Rate Limit | 否 | 等待后重试 |
| `-32005` | Upstream Error | ✅ | 检查参数 / 换工具 |
| `-32006` | Timeout | ✅ | 稍后重试 |

---

## 🆘 获取更多帮助

- 📖 [API 概览](README.md)
- 💬 [MCPCat 用户群](#)
- 📧 邮件：support@mcpcat.cn
- 🐛 [GitHub Issues](https://github.com/haogegeya/mcpcat-docs/issues)

---

> 🐱 优雅处理错误，是成熟集成的标志
