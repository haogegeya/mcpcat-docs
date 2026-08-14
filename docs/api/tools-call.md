# tools/call

> 调用指定工具，执行实际业务逻辑

## 概述

`tools/call` 是 MCPCat 最核心的方法，AI Agent 通过它执行具体的工具调用。

**核心特性**：
- 参数严格校验（按 `inputSchema`）
- 预扣 MCoin → 执行 → 成功/失败退款
- 返回统一格式的 MCP 标准结果
- 流式响应（Streamable HTTP）

---

## 请求

### 方法名

```
tools/call
```

### 参数

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `name` | string | ✅ | 工具名称（必须在 `tools/list` 返回中） |
| `arguments` | object | ❌ | 工具参数（按 `inputSchema`） |

### 请求示例

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

### curl 示例

```bash
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

## 响应

### 响应结构

| 字段 | 类型 | 说明 |
|------|------|------|
| `content` | array | 返回内容列表 |
| `content[].type` | string | 内容类型，固定为 `"text"` |
| `content[].text` | string | 格式化后的文本结果 |
| `isError` | boolean | 是否出错，true 表示调用失败（已退款） |

### 响应示例（成功）

```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "result": {
    "content": [
      {
        "type": "text",
        "text": "📍 北京\n🌡️ 温度：18-26°C\n☀️ 天气：晴\n💨 风向：东南风\n💪 风力：2 级\n💧 湿度：45%\n\n空气质量：良（AQI 65）"
      }
    ],
    "isError": false
  }
}
```

### 响应示例（失败）

```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "result": {
    "content": [
      {
        "type": "text",
        "text": "❌ 调用失败：参数错误，城市名不能为空"
      }
    ],
    "isError": true
  }
}
```

---

## 💰 计费机制

### 预扣 + 失败回滚

```
1. 查工具定价 sell_mcoin
2. 检查余额 >= sell_mcoin
3. 事务：预扣 MCoin
4. 执行上游 API 调用
5. 成功 → 标记成功（不退款）
   失败 → 自动退款（写入 transactions type=refund）
```

### 失败场景

以下情况会**自动退款**：

| 场景 | 是否退款 | 说明 |
|------|---------|------|
| **空结果** | ✅ | 上游返回 200 但 data 为空 |
| **参数错误** | ✅ | 客户端参数不符合 schema |
| **上游 5xx** | ✅ | 上游服务异常 |
| **上游 4xx** | ✅ | 上游返回错误（如快递单号不存在） |
| **网络超时** | ✅ | 超过 30 秒未响应 |
| **余额不足** | ❌ | 调用前就失败，不扣费 |

### 退款时效

- 实时退款（< 1 秒）
- 在账单中可查 `type=refund` 的记录

---

## 🛡️ 空结果检测

MCPCat 会检测"上游返回 200 但实际没数据"的情况，避免扣费：

**检测规则**：
- 响应解析后所有关键字段为 null/空
- 格式化文本为空或仅包含 "null"、"None"
- 响应数组长度为 0

**示例**：乱码城市名查天气
- 上游返回 200，但 data 字段全空
- MCPCat 检测到空结果
- 设置 `isError=true`，自动退款
- 用户实际余额变化为 0

> 可在 Adapter 配置中通过 `skip_empty_check: true` 关闭

---

## ⏱️ 超时与重试

### 超时设置

- 默认超时：30 秒
- 可在 Adapter 配置中调整

### 重试策略

- 客户端超时：MCPCat 不自动重试
- 上游 5xx：MCPCat 默认重试 1 次（间隔 200ms）
- 上游 4xx：不重试

---

## 🐍 Python SDK 示例

```python
import httpx
import asyncio

async def call_tool():
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
                "id": 3,
                "method": "tools/call",
                "params": {
                    "name": "weather_query",
                    "arguments": {"cityname": "北京"}
                }
            }
        )
        return response.json()

result = asyncio.run(call_tool())
if result["result"]["isError"]:
    print("❌ 调用失败：", result["result"]["content"][0]["text"])
else:
    print("✅ 结果：", result["result"]["content"][0]["text"])
```

---

## 🟨 JavaScript SDK 示例

```javascript
try {
  const result = await client.callTool({
    name: "weather_query",
    arguments: { cityname: "北京" }
  });
  
  if (result.isError) {
    console.error("❌ 调用失败：", result.content[0].text);
  } else {
    console.log("✅ 结果：", result.content[0].text);
  }
} catch (error) {
  console.error("网络错误：", error);
}
```

---

## 📦 当前所有工具的调用示例

### 1. 天气查询

```json
{
  "name": "weather_query",
  "arguments": {
    "cityname": "北京"
  }
}
```

### 2. 空气质量

```json
{
  "name": "air_quality_query",
  "arguments": {
    "cityname": "北京"
  }
}
```

### 3. 快递查询

```json
{
  "name": "express_query",
  "arguments": {
    "no": "SF1234567890",
    "com": "shunfeng"
  }
}
```

> `com` 可选，不传则自动识别

### 4. 手机归属地

```json
{
  "name": "phone_attribution",
  "arguments": {
    "phone": "13800138000"
  }
}
```

### 5. 运营商三要素

```json
{
  "name": "carrier_verify",
  "arguments": {
    "name": "张三",
    "id_card": "110101199001011234",
    "phone": "13800138000"
  }
}
```

### 6. IP 归属地

```json
{
  "name": "ip_location",
  "arguments": {
    "ip": "8.8.8.8"
  }
}
```

### 7. 贵金属行情

```json
{
  "name": "precious_metals",
  "arguments": {}
}
```

### 8. 油价查询

```json
{
  "name": "oil_price",
  "arguments": {
    "province": "北京"
  }
}
```

### 9. 发票验真

```json
{
  "name": "invoice_verify",
  "arguments": {
    "invoice_no": "12345678",
    "invoice_code": "011002100311",
    "amount": "100.00",
    "invoice_date": "2026-08-14"
  }
}
```

### 10. 条码查询

```json
{
  "name": "barcode_query",
  "arguments": {
    "barcode": "6901028180173"
  }
}
```

### 11. 火车票查询

```json
{
  "name": "train_query",
  "arguments": {
    "from": "北京",
    "to": "上海",
    "date": "2026-08-15"
  }
}
```

### 12. 携号转网

```json
{
  "name": "number_portability",
  "arguments": {
    "phone": "13800138000"
  }
}
```

---

## ⚠️ 注意事项

### 1. 参数严格校验

- 必填参数缺失 → 返回 `-32602 Invalid params`
- 参数类型错误 → 返回 `-32602 Invalid params`
- 额外参数（schema 中未定义）会被忽略，不会报错

### 2. 工具必须先勾选

未在用户工具列表中的工具，调用会返回：

```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "error": {
    "code": -32002,
    "message": "工具未启用"
  }
}
```

### 3. 余额不足

钱包余额 < 工具定价时：

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

### 4. 速率限制

单 Key 单分钟超过限制：

```json
{
  "jsonrpc": "2.0",
  "id": 3,
  "error": {
    "code": -32004,
    "message": "速率限制超出，请稍后重试",
    "data": {"retry_after": 30}
  }
}
```

---

## 🆘 错误处理

详见 [错误码文档](error-codes.md)，常见错误：

| 错误码 | 含义 | 处理 |
|--------|------|------|
| `-32001` | 未授权 | 检查 API Key |
| `-32002` | 工具未启用 | 提示用户勾选 |
| `-32003` | 余额不足 | 提示充值 |
| `-32004` | 速率限制 | 等待 retry_after 秒 |
| `-32005` | 上游错误 | 稍后重试或换工具 |
| `-32006` | 调用超时 | 稍后重试 |
| `-32602` | 参数错误 | 检查参数 schema |

---

## 📚 相关文档

- [API 概览](README.md)
- [initialize](initialize.md)
- [tools/list](tools-list.md)
- [错误码](error-codes.md)
- [计费规则](billing.md)
- [工具详细列表](../tools/README.md)

---

> 🐱 一次 call，结果立等可取
