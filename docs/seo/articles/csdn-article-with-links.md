# CSDN 版本（带 mcpcat.cn 外链版）

## 标题
**MCP 协议实战：5 分钟给你的 AI 装上 135+ 个工具（MCPCat 详解）**

## 标签
MCP、Claude、Cursor、AI 工具、API 聚合、Anthropic、Agent

## 分类
后端 > 人工智能

---

## 正文

### 前言

MCP（Model Context Protocol）出来一年了，但很多人不知道——

**想给 AI 装个新工具，得自己买 API、写代码、搭环境**。

装个天气 MCP 折腾 2 小时。
装个快递 MCP 又折腾 3 小时。
再装 10 个工具？再折腾 30 小时。

为了解决这个问题，我做了 **MCPCat**（mcpcat.cn），一个 MCP 聚合网关。

### MCPCat 是什么？

一句话：**一个 MCP 端点 = 135+ 个 AI 工具**。

支持：
- 天气查询（免费）
- 快递查询
- 手机归属地
- 运营商三要素
- IP 归属
- 贵金属行情
- 油价
- 火车票
- 发票验真
- 条码查询
- ... 还有 125+ 个

### 为什么选 MCPCat？

| 维度 | 自建 MCP | MCPCat |
|------|----------|--------|
| 接入时间 | 1-2 天/工具 | 5 分钟全包 |
| 代码量 | 几百行/工具 | 0 行 |
| API Key | 多个自管 | 统一 |
| 失败处理 | 手动重试 | 自动退款 |
| 计费 | 自己写 | MCoin 平台币 |
| 工具扩充 | 自己开发 | 平台持续上新 |

### 怎么接入？

**Step 1：注册**

去 https://www.mcpcat.cn 注册账号（送 100 MCoin）。

**Step 2：创建 API Key**

控制台 → API Key → 创建。

**Step 3：粘贴配置**

以 Claude Desktop 为例，在 `claude_desktop_config.json` 加：

```json
{
  "mcpServers": {
    "mcpcat": {
      "type": "streamable-http",
      "url": "https://mcp.mcpcat.cn/v1/mcp",
      "headers": {"Authorization": "Bearer mcpcat_你的key"}
    }
  }
}
```

重启 Claude Desktop，搞定。

### 怎么计费？

- 平台币 **MCoin**：1 元 = 100 MCoin
- 按调用扣费，不调用不收钱
- 失败自动退款
- 新用户注册送 100 MCoin

**价格档**：
- 免费工具：4 个（天气、空气质量等）
- 2 MCoin/次：贵金属、航班、彩票
- 4-5 MCoin/次：药企、运营商三要素
- 30 MCoin/次：发票验真

### 支持的 AI 客户端

- Claude Desktop / Claude Code
- Cursor
- Cline
- Windsurf
- Trae
- 通义灵码
- Cherry Studio
- Gemini CLI
- Codex CLI
- OpenClaw
- ... 共 16 个

### 总结

MCPCat 适合：
- ✅ 想给 AI 装工具但不想折腾的
- ✅ 同时需要多种数据查询的
- ✅ 按调用付费、不想包月的
- ✅ 想要统一管理 API Key 的

官网：https://www.mcpcat.cn
文档：https://www.mcpcat.cn/docs
GitHub：https://github.com/haogegeya/mcpcat-docs

---

## 📌 互动话术

- 有人问「MCPCat 跟 mcp.so 收录站区别」→ mcp.so 是收录站（告诉你有哪些 MCP 可用），MCPCat 是网关（直接帮你用）
- 有人问「怎么盈利」→ 按调用收费（MCoin），免费工具有 4 个
- 有人问「安全吗」→ API Key sha256 存，不接触对话内容，30 天日志自动清

## 🔗 外链位置

- 文中 2 次：mcpcat.cn（一次介绍、一次引导注册）
- 文末 3 个外链：官网、文档、GitHub
- 评论区 1 条：作者评论再带一次官网链接
