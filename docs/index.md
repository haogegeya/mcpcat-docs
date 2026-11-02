# 📚 MCPCat 文档

> **MCP 能力聚合网关官方文档** —— 一个 MCP 端点，接入实时世界的数据能力。

**在线服务** · [`https://mcp.mcpcat.cn/v1/mcp`](https://mcp.mcpcat.cn/v1/mcp) · [官网](https://mcpcat.cn) · [状态页](https://status.mcpcat.cn)

---

## 这是什么

**MCPCat** 是一个 MCP（Model Context Protocol）能力聚合网关：把大量异构数据源（天气、快递、行情、归属地、核验、出行……）聚合到**一个标准 MCP 端点**后面，供 AI Agent 直接调用。

**不写代码、不买 API、不搭环境**，按用量花平台币（MCoin）结算，**失败自动退款**。

| 字段 | 值 |
|------|-----|
| Endpoint | `https://mcp.mcpcat.cn/v1/mcp` |
| Auth Header | `Authorization: Bearer <your-key>` |
| Transport | Streamable HTTP |
| 协议 | MCP JSON-RPC 2.0（`initialize` / `tools/list` / `tools/call`） |

---

## 从这里开始

| 你是谁 | 先看 |
|--------|------|
| 第一次接入 | [快速开始](getting-started/quickstart.md) —— 5 分钟跑通 |
| 配客户端 | [客户端接入总览](guides/README.md) —— Claude Desktop / Cursor / Cline / OpenClaw |
| 写代码对接 | [API 参考](api/README.md) —— 认证、请求格式、错误码、计费 |
| 想知道有什么能力 | [工具市场](tools/README.md) —— 按场景分类的工具索引 |
| 在算成本 | [定价说明](pricing.md) —— MCoin 计费与退款规则 |
| 遇到问题 | [常见问题](faq.md) |

---

## 最小接入示例

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

其他客户端见 [客户端接入](guides/README.md)，验证连通性见 [快速开始 · 验证接入](getting-started/quickstart.md#验证接入)。

---

## 关于工具数量

本站**刻意不写死工具数量**——写死就会过期。当前可用工具请以实时返回为准：

```bash
curl -s https://mcp.mcpcat.cn/v1/mcp \
  -H "Authorization: Bearer <your-key>" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list"}'
```

返回的 `tools` 数组就是**你当前勾选可用的全部工具**。控制台「[工具市场](https://mcpcat.cn/console/tools)」可以勾选/取消。

!!! note "文档站与平台规范的关系"
    本文件（`mcpcat-docs`）是**分篇详细文档站**：按客户端、按 API 方法、按工具类别拆开写，适合查阅与收录。
    平台的**产品边界、接入规范与使用方式**定义在姊妹仓库 [haogegeya/mcpcat-platform](https://github.com/haogegeya/mcpcat-platform)，那边是平台口径的单一来源。两者定位不同，内容不重复。

---

## 🆘 需要人工帮助

- 文档没找到答案 → [提交 Issue](https://github.com/haogegeya/mcpcat-docs/issues/new)
- 工具使用问题 → 邮件 [support@mcpcat.cn](mailto:support@mcpcat.cn)
- 商务合作 → 邮件 [business@mcpcat.cn](mailto:business@mcpcat.cn)

---

> 🐱 **MCPCat — 让每个 Agent 都有一只接口猫**
