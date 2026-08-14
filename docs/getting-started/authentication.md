# 🔑 认证说明

> 深入理解 MCPCat 的双凭证体系：JWT（人/浏览器）+ API Key（AI Agent）

## 🎯 核心概念

MCPCat 使用 **两套独立的凭证体系**：

| 凭证 | 用途 | 存储位置 | 失效机制 |
|------|------|---------|---------|
| **JWT** | 浏览器登录控制台 | localStorage | 7 天过期 |
| **API Key** | AI Agent 调用工具 | 客户端配置 | 不过期，可手动撤销 |

**为什么分两套？**

- **JWT**：用于人操作（登录、充值、看账单），需要短期有效保护账号安全
- **API Key**：用于机器调用（AI 调工具），需要长期稳定但可独立撤销

---

## 🔐 API Key

### 格式

```
mcpc_sk_<32位随机字符>
```

示例：
```
mcpc_sk_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6
```

### 生命周期

1. **创建** — 在控制台「API Key 管理」创建，仅创建时返回明文
2. **存储** — MCPCat 仅保存 SHA-256 哈希值，无法恢复明文
3. **使用** — 在 HTTP Header 中以 Bearer Token 形式传递
4. **撤销** — 在控制台手动删除，立即失效

### 创建 API Key

**控制台方式**：

1. 登录 [mcpcat.cn](https://mcpcat.cn/console)
2. 进入「API Key 管理」
3. 点击「+ 创建 API Key」
4. 填写信息：
   - **名称**：用于区分用途（如 "Claude Desktop"、"生产环境"）
   - **速率限制**：默认 60 次/分钟
   - **IP 白名单**：可选，限制特定 IP 使用
5. 点击「创建」
6. ⚠️ **立即复制明文**（只显示一次！）

**API 方式**（开发中）：

```bash
curl -X POST https://mcpcat.cn/api/keys \
  -H "Authorization: Bearer <jwt_token>" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "production",
    "rate_limit_per_min": 100
  }'
```

### 使用 API Key

**MCP 客户端配置**：

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

**直接调用 API**：

```bash
curl -X POST https://mcp.mcpcat.cn/v1/mcp \
  -H "Authorization: Bearer mcpc_sk_xxx" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}'
```

### 管理 API Key

| 操作 | 说明 |
|------|------|
| **查看列表** | 控制台「API Key 管理」查看所有 Key（仅显示前缀和后 4 位） |
| **重命名** | 点击 Key 名称旁的编辑图标 |
| **查看用量** | 每个 Key 独立统计调用次数 |
| **撤销** | 点击「删除」立即失效，不可恢复 |
| **IP 白名单** | 创建时配置，仅白名单 IP 可使用 |

### 安全建议

✅ **应该做的**：
- 为不同环境创建不同 Key（开发/测试/生产）
- 定期轮换 Key
- 离职员工 / 设备淘汰时及时撤销
- 启用 IP 白名单（如有固定出口 IP）
- 在 1Password / vaultwarden 等工具中安全保存

❌ **不应该做的**：
- 把 Key 硬编码到公开仓库
- 在前端代码中暴露（Key 设计上**不**用于浏览器直接调用）
- 多个客户端共用一个 Key（无法独立撤销）

---

## 🪪 JWT（人/浏览器凭证）

### 用途

JWT 仅用于 **MCPCat 控制台（dashboard）** 的浏览器登录：

- 登录/注册
- 查看余额和账单
- 管理 API Key
- 勾选工具
- 充值

### 生命周期

| 阶段 | 时长 |
|------|------|
| Token 有效期 | 7 天 |
| 自动续期 | 每次请求时检查并续期 |
| 强制登出 | 清除 localStorage 或后端撤销 |

### 工作流程

```
浏览器 → POST /api/auth/login (邮箱+密码)
   ↓
MCPCat 返回 JWT (存 localStorage)
   ↓
浏览器 → GET /api/auth/me (Header: Bearer <jwt>)
   ↓
MCPCat 验证 JWT → 返回用户信息
   ↓
JWT 临近过期 → 后端自动续期 → 返回新 JWT
```

### 自动续期机制

MCPCat 使用 **滑动过期** 策略：

- Token 有效期内，每次请求都会延长有效期
- 长期活跃用户基本不会"突然掉线"
- 7 天不活跃则 Token 失效

### 安全机制

- **签名算法**：HS256
- **密钥管理**：服务端 `JWT_SECRET` 环境变量（生产环境必须修改）
- **传输**：仅 HTTPS
- **存储**：浏览器 localStorage（**注意 XSS 风险**）
- **登出**：清除 localStorage 中的 token

---

## 🔄 两套凭证的关系

```
┌─────────────────────────────────────────────────┐
│                  你的账号                         │
│                                                  │
│  ┌──────────┐                                    │
│  │   JWT    │ ── 浏览器登录控制台                 │
│  │  (7天)   │    用户名/密码 → JWT                │
│  └──────────┘                                    │
│                                                  │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐         │
│  │ API Key1 │ │ API Key2 │ │ API Key3 │         │
│  │ (长期)   │ │ (长期)   │ │ (长期)   │         │
│  └──────────┘ └──────────┘ └──────────┘         │
│       ↓              ↓              ↓            │
│   Claude        Cursor          Cline           │
│   Desktop                                        │
└─────────────────────────────────────────────────┘
```

**举例**：
- 你的账号有 1 个 JWT（登录浏览器用）
- 你可以创建多个 API Key：
  - Key 1：Claude Desktop 用
  - Key 2：Cursor 用
  - Key 3：生产服务器用
- 撤销 Key 2 不影响 Key 1 和 Key 3
- JWT 过期只影响浏览器登录，不影响任何 API Key

---

## 🆘 凭证相关问题

### 忘记密码？

当前版本需要联系 [support@mcpcat.cn](mailto:support@mcpcat.cn) 人工重置。

后续版本会支持：
- 邮箱验证码重置
- 手机验证码重置

### API Key 泄露了？

1. 立即在控制台「API Key 管理」**删除**该 Key
2. 创建新 Key
3. 更新所有使用该 Key 的客户端配置
4. 检查账单，确认没有异常调用

### JWT 过期了？

- 重新登录即可
- 浏览器会自动跳转到登录页（如果检测到 401）

### 怀疑账号被盗？

1. 立即修改密码
2. 撤销所有 API Key
3. 检查账单，标记异常调用
4. 联系 support@mcpcat.cn

---

## 📚 相关文档

- [快速开始](quickstart.md) — 5 分钟接入
- [核心概念](concepts.md) — MCoin、工具、Adapter
- [API 认证](../api/authentication.md) — API 层面的认证细节
- [错误码](../api/error-codes.md) — 401/403 等错误处理

---

> 🔒 安全无小事，凭证管理是产品体验的第一道防线。
