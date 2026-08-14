# tools/list

> 列出当前 API Key 可用的所有工具

## 概述

`tools/list` 返回当前 API Key 关联用户**已勾选启用**的工具列表。

**关键特性**：
- 只返回用户**主动勾选**的工具（动态下发）
- 即使客户端猜到了工具名，未勾选的也调用不了
- 每次调用都返回最新状态（实时）

---

## 请求

### 方法名

```
tools/list
```

### 参数

无

### 请求示例

```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "tools/list"
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
    "id": 2,
    "method": "tools/list"
  }'
```

---

## 响应

### 响应结构

| 字段 | 类型 | 说明 |
|------|------|------|
| `tools` | array | 工具列表 |
| `tools[].name` | string | 工具唯一名称 |
| `tools[].description` | string | 工具描述（AI 用此决定何时调用） |
| `tools[].inputSchema` | object | JSON Schema 格式的参数定义 |

### inputSchema 详解

`inputSchema` 是 JSON Schema 草案 7 标准：

```typescript
{
  type: "object",
  properties: {
    [paramName]: {
      type: "string" | "number" | "boolean" | "array" | "object",
      description?: string,
      enum?: any[],        // 枚举值
      default?: any,       // 默认值
      minimum?: number,    // 最小值（数字）
      maximum?: number,    // 最大值（数字）
      items?: object       // 数组元素 schema
    }
  },
  required?: string[]      // 必填参数名列表
}
```

### 响应示例

```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "result": {
    "tools": [
      {
        "name": "weather_query",
        "description": "查询指定城市的天气信息，包括温度、湿度、天气状况、风向风力",
        "inputSchema": {
          "type": "object",
          "properties": {
            "cityname": {
              "type": "string",
              "description": "城市名称，如 '北京'、'上海'"
            }
          },
          "required": ["cityname"]
        }
      },
      {
        "name": "express_query",
        "description": "查询快递物流信息",
        "inputSchema": {
          "type": "object",
          "properties": {
            "no": {
              "type": "string",
              "description": "快递单号"
            },
            "com": {
              "type": "string",
              "description": "快递公司代码，可选；不传则自动识别"
            }
          },
          "required": ["no"]
        }
      }
    ]
  }
}
```

---

## 🛠️ 当前所有工具

详见 [工具列表](../tools/README.md)，当前 12 个工具：

| 工具名 | 分类 | 定价 |
|--------|------|------|
| `weather_query` | 生活 | 免费 |
| `air_quality_query` | 生活 | 免费 |
| `express_query` | 物流 | 3 MCoin |
| `express_query_v2` | 物流 | 3 MCoin |
| `phone_attribution` | 通信 | 3 MCoin |
| `carrier_verify` | 通信 | 5 MCoin |
| `number_portability` | 通信 | 3 MCoin |
| `ip_location` | 网络 | 3 MCoin |
| `precious_metals` | 金融 | 5 MCoin |
| `oil_price` | 金融 | 3 MCoin |
| `invoice_verify` | 核验 | 10 MCoin |
| `barcode_query` | 核验 | 5 MCoin |
| `train_query` | 出行 | 5 MCoin |

---

## 🐍 Python SDK 示例

```python
import httpx
import asyncio

async def list_tools():
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
                "id": 2,
                "method": "tools/list"
            }
        )
        return response.json()

result = asyncio.run(list_tools())
for tool in result["result"]["tools"]:
    print(f"- {tool['name']}: {tool['description']}")
```

---

## 🟨 JavaScript SDK 示例

```javascript
const tools = await client.listTools();

tools.tools.forEach(tool => {
  console.log(`- ${tool.name}: ${tool.description}`);
  console.log(`  params:`, tool.inputSchema);
});
```

---

## ⚠️ 注意事项

### 1. 工具列表会变

- 平台新增工具 → 列表自动增加
- 工具下线/升级 → 列表可能变化
- **建议**：每次 AI Agent 启动时重新调用 `tools/list`，而不是缓存

### 2. 工具按用户隔离

- 不同用户看到的工具列表**可能不同**（取决于勾选）
- 同一用户多个 Key 看到的工具列表**相同**

### 3. 工具调用权限

- 用户在 `tools/list` 中**看不到**的工具 → 也不能调用
- 即使用户手动构造了 `tools/call` 请求，未勾选的工具会返回 `-32002 工具未启用`

### 4. 工具描述的重要性

`description` 字段是 AI 决定**何时调用哪个工具**的关键，**不要忽略**：

- 描述要清晰说明工具的功能
- 描述要说明典型使用场景
- 描述要给出参数示例

---

## 🆘 错误处理

### 401 Unauthorized

API Key 无效：

```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "error": {
    "code": -32001,
    "message": "未授权：API Key 无效"
  }
}
```

### 403 Forbidden

IP 不在白名单或 Key 被冻结：见 [错误码](error-codes.md)

### 空列表

如果用户没有勾选任何工具，返回：

```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "result": {
    "tools": []
  }
}
```

**处理**：
- 提示用户去 [MCPCat 工具市场](https://mcpcat.cn/console/tools) 勾选工具

---

## 📚 相关文档

- [API 概览](README.md)
- [initialize](initialize.md)
- [tools/call](tools-call.md)
- [工具详细列表](../tools/README.md)

---

> 🐱 一次 list，所有可用工具一目了然
