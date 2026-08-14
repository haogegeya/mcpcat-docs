# 📚 MCPCat 文档

> **MCP 能力聚合网关官方文档**  
> 一个 MCP 端点，几百个 AI 工具立刻能用

[![Website](https://img.shields.io/badge/website-mcpcat.cn-FF6B35?style=flat-square)](https://mcpcat.cn)
[![MCP](https://img.shields.io/badge/MCP-compatible-1A1A2E?style=flat-square)](https://modelcontextprotocol.io)
[![License](https://img.shields.io/badge/license-MIT-4ECDC4?style=flat-square)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen?style=flat-square)](CONTRIBUTING.md)

[官网](https://mcpcat.cn) · [MCP 端点](https://mcp.mcpcat.cn) · [更新日志](CHANGELOG.md) · [问题反馈](https://github.com/haogegeya/mcpcat-docs/issues)

---

## 🎯 MCPCat 是什么？

**MCPCat** 是一个 MCP（Model Context Protocol）能力聚合网关服务。

**一个 MCP 端点接入 12+ 常用 AI 工具**，覆盖天气、快递、手机归属地、IP 归属、贵金属行情、发票验真、条码、火车票、油价、运营商三要素等场景。

**不写代码、不买 API、不搭环境**，按用量花平台币（MCoin）结算，**失败自动退款**。

---

## 🚀 5 分钟接入

### 1. 注册账号
访问 [mcpcat.cn](https://mcpcat.cn) 注册，新用户**送 100 MCoin** 体验额度。

### 2. 创建 API Key
在控制台「[API Key 管理](https://mcpcat.cn/console/keys)」创建 Key，仅创建时显示明文，请妥善保存。

### 3. 配置 MCP 客户端

**Claude Desktop** —— 编辑 `claude_desktop_config.json`：

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

**Cursor / Cline / OpenClaw**：

| 字段 | 值 |
|------|-----|
| Endpoint | `https://mcp.mcpcat.cn/v1/mcp` |
| Auth Header | `Authorization: Bearer <your-key>` |
| Transport | Streamable HTTP |

### 4. 勾选工具
登录控制台，在「[工具市场](https://mcpcat.cn/console/tools)」勾选需要启用的工具，立即可用。

---

## ✨ 核心特性

| 特性 | 说明 |
|------|------|
| **统一 MCP 端点** | 完整支持 MCP JSON-RPC 2.0，兼容主流 MCP 客户端 |
| **12+ 工具** | 覆盖天气/快递/手机归属/IP/贵金属/发票验真等场景 |
| **平台币 MCoin** | ¥1 = 100 MCoin，充值档位有赠送 |
| **失败自动退款** | 上游异常或返回空结果时自动识别并退还费用 |
| **0 接入成本** | 无需自购 API、自写 MCP Server、自搭环境 |
| **四层限流** | IP / Key / User / Tool 独立限速 |
| **统一输出格式** | JSONPath 映射 + 沙箱表达式，上游五花八门秒变 MCP 标准 |
| **持续扩充** | 路线图涵盖数据/动作/SaaS/AI/自动化五层能力 |

---

## 📖 文档导航

### 🚀 快速开始
- [快速开始](docs/getting-started/quickstart.md) — 5 分钟接入 MCPCat
- [认证说明](docs/getting-started/authentication.md) — API Key 与 JWT 双凭证体系
- [核心概念](docs/getting-started/concepts.md) — MCoin、工具、Adapter

### 🔌 客户端接入
- [Claude Desktop](docs/guides/claude-desktop.md)
- [Cursor](docs/guides/cursor.md)
- [Cline](docs/guides/cline.md)
- [OpenClaw](docs/guides/openclaw.md)
- [其他客户端](docs/guides/other-clients.md)

### 🛠️ API 参考
- [API 概览](docs/api/README.md)
- [认证](docs/api/authentication.md)
- [initialize](docs/api/initialize.md)
- [tools/list](docs/api/tools-list.md)
- [tools/call](docs/api/tools-call.md)
- [错误码](docs/api/error-codes.md)
- [计费规则](docs/api/billing.md)

### 🧰 工具列表
- [工具市场](docs/tools/README.md) — 全部工具索引
- [生活服务](docs/tools/lifestyle.md) — 天气、空气质量
- [物流快递](docs/tools/express.md) — 快递查询
- [通信查询](docs/tools/communication.md) — 手机归属、三要素、携号转网
- [网络工具](docs/tools/network.md) — IP 归属
- [金融行情](docs/tools/finance.md) — 贵金属、油价
- [验证核验](docs/tools/verification.md) — 发票验真、条码
- [出行查询](docs/tools/travel.md) — 火车票

### 📚 更多
- [定价说明](docs/pricing.md) — MCoin 计费规则
- [使用示例](docs/examples.md) — 实战 Case
- [常见问题](docs/faq.md) — FAQ
- [路线图](docs/roadmap.md) — 五层能力演进
- [更新日志](CHANGELOG.md)
- [贡献指南](CONTRIBUTING.md)

---

## 🆚 为什么选 MCPCat？

| 维度 | 自购 API | 自写 MCP Server | **MCPCat** |
|------|----------|-----------------|------------|
| 接入时间 | 半天 | 1-2 天/工具 | **5 分钟** |
| 代码量 | 多 | 很多 | **0** |
| API Key 管理 | 多个自己管 | 多个自己管 | **MCPCat 统一** |
| 返回格式统一 | ❌ | ❌ | **✅** |
| 失败处理 | 手动 | 手动 | **✅ 自动退款** |
| 计费 | 多份账单 | 多份账单 | **✅ 统一 MCoin** |
| 部署运维 | 需自建 | 需自建 | **✅ HTTP 远程** |

---

## 🧬 能力路线图

```
数据查询类（当前）  →  动作执行类  →  SaaS 集成类  →  AI 能力类  →  私有自动化
  12 工具，验证中       建壁垒中        规划中          规划中        长期目标
```

- **短期（1-2 月）**：上线 OCR、翻译、地图、股票、汇率、邮编
- **中期（3-6 月）**：Notion/飞书/GitHub OAuth 集成、文生图/TTS、向量检索
- **长期**：浏览器自动化、RPA 沙箱

---

## 🤝 贡献

欢迎提交 Issue 和 PR 改进文档！详见 [CONTRIBUTING.md](CONTRIBUTING.md)。

**发现文档错误** → [提交 Issue](https://github.com/haogegeya/mcpcat-docs/issues/new)  
**工具使用问题** → [MCPCat 用户群](#)  
**商务合作** → support@mcpcat.cn

---

## 📄 许可证

本项目文档采用 [MIT 许可证](LICENSE)。

---

## 🔗 相关链接

- **官网**：https://mcpcat.cn
- **MCP 端点**：`https://mcp.mcpcat.cn/v1/mcp`
- **状态页**：https://status.mcpcat.cn
- **邮箱**：support@mcpcat.cn
- **GitHub**：https://github.com/haogegeya/mcpcat-docs

---

> 🐱 **MCPCat — 让每个 Agent 都有一只接口猫**
