# 🔐 API 认证

> MCPCat 网关 API 的认证机制详解

## 概述

MCPCat 网关 API **仅支持 API Key 鉴权**（不支持 JWT，JWT 仅用于控制台）。

所有 MCP 方法调用（initialize / tools/list / tools/call）都必须在 HTTP Header 中携带有效的 API Key。

---

## 🔑 API Key

### 格式

```
mcpc_sk_<32位随机字符>
```

示例：
```
mcpc_sk_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6
```

### 获取方式

1. 登录 [MCPCat 控制台](https://mcpcat.cn/console)
2. 进入「[API Key 管理](https://mcpcat.cn/console/keys)」
3. 点击「+ 创建 API Key」
4. 填写名称和速率限制
5. **立即复制明文**（只显示一次）

详细创建步骤见 [快速开始](../getting-started/quickstart.md#step-2创建-api-key)

---

## 📡 HTTP Header

### 必填 Header

| Header | 值 | 必填 |
|--------|-----|------|
| `Authorization` | `Bearer mcpc_sk_xxxxx` | ✅ |
| `Content-Type` | `application/json` | ✅ |
| `Accept` | `application/json, text/event-stream` | ✅ |

### 完整请求示例

```bash
curl -X POST https://mcp.mcpcat.cn/v1/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -H "Authorization: Bearer mcpc_sk_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "initialize",
    "params": {
      "protocolVersion": "2024-11-05",
      "capabilities": {},
      "clientInfo": {"name": "my-client", "version": "1.0.0"}
    }
  }'
```

### 可选 Header

| Header | 用途 |
|--------|------|
| `X-Request-ID` | 请求追踪 ID，便于日志排查 |
| `X-Client-Info` | 自定义客户端标识（仅日志用） |

---

## 🛡️ 安全特性

### 1. API Key 哈希存储

- **存储**：MCPCat 仅保存 API Key 的 SHA-256 哈希值
- **明文**：仅在创建时返回一次，丢失无法恢复
- **保护**：即使数据库泄露，攻击者也无法直接使用 Key

### 2. 速率限制

每个 API Key 可独立配置速率限制（默认 60 次/分钟）：

| 层级 | 限制 |
|------|------|
| **IP 级** | 300 次/分钟（每 IP） |
| **Key 级** | 默认 60 次/分钟（可配置） |
| **User 级** | 200 次/分钟（每用户） |
| **Tool 级** | 60 次/分钟（每工具） |

超出限制会返回 `429 Too Many Requests`。

### 3. IP 白名单

创建 API Key 时可配置 IP 白名单，仅白名单内的 IP 可使用：

```json
{
  "name": "production-server",
  "allowed_ips": ["1.2.3.4", "5.6.7.0/24"],
  "rate_limit_per_min": 100
}
```

不在白名单内的 IP 调用会返回 `403 Forbidden`。

### 4. 风控冻结

异常行为检测：

- **短时间大量调用高价工具** → 自动冻结 Key
- **参数注入攻击** → 自动冻结 Key
- **绕过计费尝试** → 永久封禁

冻结后需在控制台手动解封。

### 5. 全链路 HTTPS

- 强制 HTTPS
- TLS 1.2+
- 证书自动续期（Let's Encrypt）

---

## ❌ 错误处理

### 401 Unauthorized

API Key 无效或缺失：

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

**原因**：
- 缺失 `Authorization` Header
- API Key 拼写错误
- API Key 已被撤销
- API Key 格式错误（不是 `mcpc_sk_` 开头）

### 403 Forbidden

IP 不在白名单：

```json
{
  "jsonrpc": "2.0",
    "id": 1,
    "error": {
      "code": -32001,
      "message": "未授权：IP 不在白名单内"
    }
}
```

**原因**：
- 调用 IP 不在 API Key 配置的 `allowed_ips` 中

### 429 Too Many Requests

速率限制超出：

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "error": {
    "code": -32004,
    "message": "速率限制超出，请稍后重试",
    "data": {
      "retry_after": 30
    }
  }
}
```

**处理**：
- 等待 `retry_after` 秒后重试
- 或升级 API Key 速率限制（在控制台修改）

### 403 Frozen

API Key 被风控冻结：

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "error": {
    "code": -32001,
    "message": "API Key 已被冻结，请联系 support@mcpcat.cn"
  }
}
```

**处理**：
- 联系 support@mcpcat.cn 申请解封
- 或创建新的 API Key

---

## 🧪 测试认证

### 1. 验证 Key 有效性

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
      "clientInfo": {"name": "test", "version": "1.0"}
    }
  }'
```

**成功响应**：

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "result": {
    "protocolVersion": "2024-11-05",
    "capabilities": {"tools": {}},
    "serverInfo": {"name": "mcpcat", "version": "1.0.0"}
  }
}
```

**失败响应**（Key 无效）：

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "error": {
    "code": -32001,
    "message": "未授权：API Key 无效"
  }
}
```

### 2. 验证余额

```bash
# 登录控制台查询
# 或调用任意工具，看返回的错误信息
```

---

## 🔄 API Key 生命周期管理

### 创建

| 方式 | 说明 |
|------|------|
| **控制台** | 在「API Key 管理」页面创建（推荐） |
| **API** | `POST /api/keys`（开发中） |

### 查看

| 方式 | 说明 |
|------|------|
| **控制台** | 「API Key 管理」页面，仅显示前缀和后 4 位 |
| **用量统计** | 每个 Key 独立统计调用次数、成功率、最后调用时间 |

### 修改

| 操作 | 是否支持 |
|------|---------|
| **重命名** | ✅ |
| **修改速率限制** | ✅ |
| **修改 IP 白名单** | ✅ |
| **修改 Key 明文** | ❌（明文不可恢复） |

### 撤销

| 方式 | 说明 |
|------|------|
| **控制台** | 「API Key 管理」→ 删除 |
| **立即生效** | ✅ 撤销后所有调用立即失败 |
| **不可恢复** | ❌ 删除后 Key 永久失效 |

---

## 💡 最佳实践

### ✅ 应该做的

1. **多环境隔离**：为开发/测试/生产创建不同 Key
2. **轮换 Key**：定期（如每 90 天）轮换一次
3. **IP 白名单**：生产环境启用，限制特定出口 IP
4. **安全存储**：用 1Password / vaultwarden 等工具保存
5. **监控用量**：定期查看 API Key 调用日志，发现异常及时撤销
6. **最小权限**：不需要的功能不要勾选工具，减少被滥用的风险

### ❌ 不应该做的

1. **不要硬编码到公开仓库**：即使是私有项目也不安全
2. **不要在前端代码中暴露**：API Key 设计上**不**用于浏览器直接调用
3. **不要共享 Key**：每个客户端/服务用独立 Key
4. **不要忽视异常**：发现 Key 泄露立即撤销
5. **不要使用过期 Key**：定期检查 Key 状态

---

## 🆘 常见问题

### Q: API Key 泄露了怎么办？

1. 立即在控制台「API Key 管理」**删除**该 Key
2. 创建新 Key
3. 更新所有使用该 Key 的客户端配置
4. 检查账单，确认没有异常调用
5. 如有资损，联系 support@mcpcat.cn

### Q: 怎么查看 API Key 的用量？

登录控制台 → API Key 管理 → 每个 Key 旁边有「用量统计」按钮，显示：
- 总调用次数
- 成功/失败次数
- 最后调用时间
- 按工具/按日/按小时统计

### Q: 多个客户端可以共用一个 Key 吗？

技术上可以，但**不推荐**：
- ❌ 无法独立撤销
- ❌ 无法独立统计
- ❌ 无法独立限流
- ✅ 建议每个客户端独立 Key

### Q: API Key 会被自动撤销吗？

正常情况下不会，仅在以下情况撤销：
- 用户手动删除
- 风控系统检测到异常
- 账号被封禁

### Q: 余额不足会影响 Key 吗？

不会，Key 本身仍然有效，只是调用会因 `余额不足` 失败。充值后立即恢复。

---

## 📚 相关文档

- [快速开始](../getting-started/quickstart.md) — 创建第一个 API Key
- [认证说明](../getting-started/authentication.md) — JWT + API Key 双凭证
- [错误码](error-codes.md) — 完整错误处理
- [计费规则](billing.md) — 余额管理
- [工具列表](../tools/README.md) — 可用工具

---

> 🔒 安全是产品的第一道防线，凭证管理是用户的必修课
