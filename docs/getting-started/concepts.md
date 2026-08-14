# 🧠 核心概念

> 理解 MCPCat 的三大核心概念：MCoin、工具、Adapter

## 💰 MCoin（平台币）

### 是什么

**MCoin** 是 MCPCat 平台统一的虚拟货币单位，用于支付工具调用费用。

### 关键参数

| 项目 | 值 |
|------|-----|
| 名称 | MCoin（喵币） |
| 汇率 | **¥1 = 100 MCoin** |
| 最小单位 | 1 MCoin |
| 有效期 | 长期有效（无过期） |

### 为什么用平台币而不是直接付人民币？

✅ **整数计算，无精度问题**（0.1 元 = 10 MCoin，不会出现 0.10000001）  
✅ **支持营销活动**（充值送、签到送、邀请送）  
✅ **统一计费单位**（不同 API 成本差异大，需要灵活定价）  
✅ **未来扩展性**（会员等级、积分体系、交易手续费等）

### 充值档位

| 充值金额 | 获得 MCoin | 赠送 | 实际汇率 |
|---------|-----------|------|---------|
| ¥10 | 1,000 | 0 | 1 分/MCoin |
| ¥50 | 5,100 | 100 (+2%) | ~0.98 分/MCoin |
| ¥100 | 10,500 | 500 (+5%) | ~0.95 分/MCoin |
| ¥500 | 55,000 | 5,000 (+10%) | ~0.91 分/MCoin |

> 💡 充得越多送得越多，最高 10% 赠送。

### 计费流程

```
用户调用工具
    ↓
1. 查询工具定价（sell_mcoin）
2. 检查钱包余额 >= sell_mcoin
   ↓ 不足 → 返回 "MCoin 余额不足"
3. 开启数据库事务
   a. 预扣：transactions (type=consume, amount=-sell)
   b. 扣减：wallets.balance -= sell
   c. 记录：call_logs (status=pending)
4. 提交事务
    ↓
5. 执行实际 API 调用
    ↓
6. 成功 → 标记 call_logs.status=success
   失败 → 退款 transactions (type=refund) + 余额回滚
```

### 失败退款机制

**核心原则：可以接受偶尔多退，绝对不能多扣。**

- **空结果检测**：上游返回 200 但 data 为空 → 自动退款
- **异常检测**：参数错误、超时、5xx → 自动退款
- **退款时效**：实时（< 1 秒到账）
- **退款记录**：在账单中可查

### 工具定价分层

| 层级 | 用途 | 典型工具 | 定价 |
|------|------|---------|------|
| **免费工具** | 引流、降低门槛 | 天气、IP 归属 | 0 MCoin（每日额度） |
| **基础付费** | 常规现金流 | 快递、手机归属 | 3-10 MCoin/次 |
| **高级付费** | 高毛利覆盖成本 | 发票验真、三要素 | 50-1000+ MCoin/次 |
| **订阅会员**（规划中） | 稳定订阅收入 | 工具包 | 月费制 |

### 免费工具的边界

- 每个免费工具设置 **每日调用上限**（如 50 次/天）
- 免费调用 **不扣费但记日志**（用于分析用户行为）
- 超限后按付费价格计费或提示充值
- IP/Key/User/Tool 四层限流必须生效

---

## 🧰 工具（Tool）

### 是什么

**工具** 是 MCPCat 暴露给 AI Agent 的可调用函数，对应一个具体的业务能力（如"查天气"、"查快递"）。

### 工具 vs Adapter 的关系

```
Adapter（适配器）= 一个上游 API 的封装
  ↓
Tool（工具）= Adapter 暴露的一个具体函数

一个 Adapter 可以有多个 Tool
一个 Tool 只属于一个 Adapter
```

**示例**：

- Adapter `aliyun_weather` 暴露 2 个 Tool：
  - `weather_query`（查天气）
  - `air_quality_query`（查空气质量）
- Adapter `express_100` 暴露 1 个 Tool：
  - `express_query`（查快递）

### 工具定义

每个工具在 MCPCat 中有完整描述，AI Agent 通过 `tools/list` 获取：

```json
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
}
```

### 工具生命周期

```
1. 平台上线新 Adapter
   ↓
2. Adapter 暴露的 Tools 自动加入工具市场
   ↓
3. 用户在控制台勾选启用
   ↓
4. AI Agent 通过 tools/list 看到这些工具
   ↓
5. AI 决定何时调用 tools/call
   ↓
6. MCPCat 路由到对应 Adapter 执行
   ↓
7. 返回标准化结果
```

### 工具动态下发

**用户勾选控制可见性**：

- 用户在控制台勾选的工具 → `tools/list` 返回
- 用户未勾选的工具 → `tools/list` 不返回
- 即使用户猜到了工具名，调用也会被拒

**好处**：

- 避免用户被无关工具干扰
- 用户控制成本（看到收费的不勾选）
- 不同 Agent 看到不同工具集（精细化控制）

### 工具调用流程

```
AI Agent: "帮我查北京天气"
   ↓
AI 决定调用 weather_query(cityname="北京")
   ↓
发送 JSON-RPC 2.0 请求到 MCPCat 网关
   ↓
MCPCat 网关：
  1. 验证 API Key
  2. 验证工具是否启用
  3. 预扣 MCoin
  4. 路由到对应 Adapter
  5. Adapter 调用上游 API
  6. JSONPath 映射 + 格式统一
  7. 返回标准化结果
   ↓
AI Agent 收到结果，整理成自然语言回复
```

---

## 🔌 Adapter（适配器）

### 是什么

**Adapter** 是 MCPCat 连接上游 API 的"翻译官"，负责：

- 处理不同的**认证方式**（AppCode/Bearer/OAuth2/...）
- 转换不同的**请求格式**（参数拼装）
- 转换不同的**返回格式**（JSONPath 映射 + 模板渲染）
- 处理**错误和重试**

### 三层接入架构

```
┌─────────────────────────────────────────┐
│  Layer 1: 通用 HTTP Adapter（90%）        │
│  填配置零代码，5 秒接入                  │
└─────────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────────┐
│  Layer 2: 认证模板（9%）                  │
│  选模板 + 填参数，1 分钟接入              │
└─────────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────────┐
│  Layer 3: 原生 Adapter（1%）              │
│  写 Python 代码，特殊协议/复杂逻辑        │
└─────────────────────────────────────────┘
```

### Layer 1：通用 HTTP Adapter

**适用场景**：标准 RESTful API，认证方式是 Header/Query 传 Key。

**配置示例**：

```json
{
  "name": "阿里云天气",
  "adapter_type": "generic_http",
  "base_url": "https://aliyun.weather.market.alicloudapi.com",
  "auth_type": "appcode",
  "auth_config": {
    "appcode": "你的AppCode"
  },
  "tools": [
    {
      "name": "weather_query",
      "description": "查询天气",
      "http_path": "/day15",
      "http_method": "GET",
      "parameters": {
        "cityname": {
          "type": "string",
          "required": true,
          "location": "query"
        }
      },
      "result_mapper": {
        "city": "$.data.city.city",
        "temperature": "$.data.day_weather",
        "weather": "$.data.weather"
      }
    }
  ]
}
```

**特点**：
- 5 秒接入
- 热加载生效
- 无需重启服务

### Layer 2：认证模板

**适用场景**：复杂认证（OAuth2、HMAC、JWT 等）。

**支持的认证类型**：

| 认证类型 | 适用场景 | 难度 |
|---------|---------|------|
| `appcode` | 阿里云市场 | ⭐ |
| `bearer` | 标准 Bearer Token | ⭐ |
| `basic` | HTTP Basic Auth | ⭐ |
| `query_key` | URL 拼 key | ⭐ |
| `custom_header` | 自定义 Header | ⭐⭐ |
| `md5_sign` | 快递 100 风格签名 | ⭐⭐⭐ |
| `hmac_sha256` | HMAC-SHA256 签名 | ⭐⭐⭐ |
| `jwt` | JWT 透传/现签 | ⭐⭐ |
| `oauth2` | OAuth2 client_credentials | ⭐⭐⭐ |
| `cookie_session` | Cookie 会话 | ⭐⭐ |

### Layer 3：原生 Adapter

**适用场景**：复杂逻辑、流式响应、自定义协议。

**实现方式**：继承 `MCPAdapter` 基类，实现 `call_tool()` 和 `get_tool_definitions()`。

```python
from adapters.base import MCPAdapter

class MyCustomAdapter(MCPAdapter):
    id = "my_custom"
    name = "我的自定义 Adapter"
    
    def get_tool_definitions(self):
        return [{
            "name": "my_tool",
            "description": "自定义工具",
            "inputSchema": {
                "type": "object",
                "properties": {
                    "input": {"type": "string"}
                }
            }
        }]
    
    async def call_tool(self, tool_name, arguments):
        # 自定义逻辑
        result = await some_complex_logic(arguments)
        return {"content": [{"type": "text", "text": result}]}
```

### Adapter 热加载

**机制**：

```
管理员后台修改配置 → 保存到 MySQL
    ↓
Redis Pub/Sub 发布 mcpcat:adapter:reload
    ↓
所有网关节点收到订阅消息
    ↓
本地内存 Registry 刷新配置
    ↓
新配置立即生效（连接中的用户也能用到）
```

**优势**：
- 改配置无需重启服务
- 0 停机时间
- 跨节点同步

---

## 🔗 三者关系

```
┌─────────────────────────────────────────────┐
│                 MCPCat 平台                  │
│                                              │
│  ┌──────────────┐                            │
│  │   用户       │ ← 注册、充值、勾选工具     │
│  └──────┬───────┘                            │
│         │                                    │
│  ┌──────▼───────┐    ┌─────────────────┐   │
│  │  钱包(MCoin) │ →  │  工具调用计费    │   │
│  └──────────────┘    └────────┬────────┘   │
│                                │             │
│  ┌─────────────────────────────▼──────────┐ │
│  │           工具市场（用户可见）          │ │
│  │  weather_query │ express_query │ ...   │ │
│  └─────────────────────┬──────────────────┘ │
│                        │                     │
│  ┌─────────────────────▼──────────────────┐ │
│  │         Adapter 层（管理员可见）        │ │
│  │  aliyun_weather │ express_100 │ ...   │ │
│  └─────────────────────┬──────────────────┘ │
│                        │                     │
│  ┌─────────────────────▼──────────────────┐ │
│  │       上游 API（阿里云、快递100...）   │ │
│  └────────────────────────────────────────┘ │
└─────────────────────────────────────────────┘
```

**简单记忆**：
- **MCoin** = 钱
- **Tool** = 卖的功能（用户视角）
- **Adapter** = 进货渠道（管理员视角）

---

## 📚 相关文档

- [快速开始](quickstart.md) — 5 分钟接入
- [认证说明](authentication.md) — JWT + API Key 双凭证
- [定价说明](../pricing.md) — MCoin 完整定价表
- [工具列表](../tools/README.md) — 全部工具索引
- [API 参考](../api/README.md) — 完整 API 文档

---

> 🐱 理解了这三个概念，你就掌握了 MCPCat 的全部核心机制。
