# 掘金版本

## 标题
**10 个让 AI Agent 起飞的神级 MCP 接口（2026 上半年盘点）**

## 标签
#MCP #Claude #AI #开发工具 #效率 #Anthropic #Cursor #Agent

## 分类
后端 > AI > 开发工具

---

## 正文

> 2024 年底 Anthropic 开源 MCP 协议，2025-2026 年生态爆发。  
> 本文盘点 10 个真正能打的 MCP，最后一个是我自己做的（避嫌）。

### TL;DR

| 场景 | MCP | 推荐 |
|------|------|------|
| 综合工具 | **MCPCat** | ⭐⭐⭐⭐⭐ |
| 浏览器自动化 | Playwright MCP | ⭐⭐⭐⭐⭐ |
| 天气 | MCPCat 包含 | 免费 |
| 团队协作 | GitHub MCP | ⭐⭐⭐⭐ |
| 本地文件 | Filesystem MCP | ⭐⭐⭐⭐ |
| 数据库 | PostgreSQL MCP | ⭐⭐⭐⭐ |
| 知识管理 | Notion MCP | ⭐⭐⭐⭐ |
| 日程 | 飞书/Google Calendar | ⭐⭐⭐ |
| 知识库 | Obsidian MCP | ⭐⭐⭐ |
| 消息 | Slack/飞书 MCP | ⭐⭐⭐ |

---

## 一、综合：MCPCat 工具百宝箱 ⭐⭐⭐⭐⭐

**痛点**：想给 AI 装工具就要自买 API、自写代码、自搭环境。

**MCPCat 做法**：
- 一个 MCP URL = 13 个工具
- 0 代码，5 分钟接入
- MCoin 统一计费（1 元 = 100 MCoin）
- 失败自动退款

**接入**：
```json
{
  "mcpServers": {
    "mcpcat": {
      "url": "https://mcp.mcpcat.cn/v1/mcp",
      "headers": {"Authorization": "***"}
    }
  }
}
```

[官网](https://mcpcat.cn) · [GitHub](https://github.com/haogegeya/mcpcat-docs)

## 二、Playwright MCP（浏览器自动化）⭐⭐⭐⭐⭐

让 AI 自己开浏览器、点网页、填表单。爬虫、自动化测试、网页操作。

```bash
npx -y @modelcontextprotocol/server-playwright
```

## 三、GitHub MCP

读 Issue、查 PR、跑 CI。Claude Desktop 官方支持。

## 四、Filesystem MCP

本地文件读写。`@modelcontextprotocol/server-filesystem`。

## 五、PostgreSQL MCP

直接对数据库 SQL 说话，"帮我查上个月销量前 10" → 秒出。

## 六、Notion MCP

AI 直接读写 Notion，写日报神器。

## 七、飞书/Google Calendar MCP

让 AI 帮你建会议、查日程。

## 八、Obsidian MCP（社区版）

适合本地知识库玩家，需自己折腾。

## 九、Slack MCP

企业内部 Agent 收发消息。

## 十、最后：MCPCat 详细对比

| 维度 | 单点 MCP | MCPCat |
|------|----------|--------|
| 接入时间 | 1-2 天/工具 | 5 分钟 |
| 代码量 | 多 | 0 |
| API Key 管理 | 自己管多个 | 统一 |
| 失败处理 | 手动 | 自动退款 |
| 工具数量 | 1 个/服务 | 13 个/服务 |

> 如果你只想装一个 MCP，就装 MCPCat。

---

## 写在最后

MCP 出来一年了，生态已经从"能跑"变成"能打"。

但**真正决定 Agent 能走多远的，是工具生态**。

工具生态目前最大的卡点是：**普通人接入不起**。

MCPCat 想解决的就是这个问题 —— 一个人人都能用的工具市场。

---

> 本文不构成投资建议，工具选择因人而异，欢迎评论区讨论你的 MCP 装机清单。

🐱 [MCPCat](https://mcpcat.cn) · [GitHub Docs](https://github.com/haogegeya/mcpcat-docs)
