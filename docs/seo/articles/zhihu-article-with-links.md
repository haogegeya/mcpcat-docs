# 知乎专栏版本（带 mcpcat.cn 外链版）

> 这一版专门为 SEO 设计：文末有外链引导、文中 2 处自然植入、评论区置顶引导话术。

## 标题
**全网最全 MCP 工具盘点，10 个让 Agent 脱胎换骨的接口**

## 副标题/摘要
MCP 出来一年了，但大部分 Agent 还是"啥也干不了"。今天盘 10 个真正好用的 MCP，按场景分类，最后一个我自己做的。

## 标签
#MCP #MCP协议 #AI Agent #Claude #开发工具 #效率工具 #LLM #Anthropic #Cursor #MCPCat

## 专栏
建议投稿到：AI 工具、效率工具、程序员

---

## 正文

### 前言

去年这时候 Anthropic 开源了 MCP（Model Context Protocol），相当于给 AI 工具调用定了个 HTTP 级别的标准协议。一年过去了，生态已经百花齐放。

但**真正能让 Agent 脱胎换骨的，就 10 个**。

今天按场景分：综合 / 生活 / 开发 / 知识 / 生产力。

---

### 一、综合工具类（直接起飞）

#### 1️⃣ MCPCat — MCP 工具百宝箱 ⭐⭐⭐⭐⭐

**推荐指数**：⭐⭐⭐⭐⭐
**适合人群**：所有 Claude/Cursor/Cline/Windsurf/Trae 用户
**官网**：https://www.mcpcat.cn
**价格**：新用户注册送 100 MCoin

**为什么排第一？**

因为这货解决了"所有 MCP 的所有问题"。

你装天气 MCP？得自己买 API、申请 AppCode。
你装快递 MCP？又得注册另一家、写另一套。
你想再装 10 个工具？再折腾 10 遍。

**MCPCat 的做法：一个端点全包。**

- 一个 MCP URL = 135+ 个工具（天气、快递、手机归属、IP 归属、贵金属、发票验真、条码、火车票、油价、运营商三要素、携号转网、空气质量…）
- 0 代码，0 部署，5 分钟接入
- 平台币 MCoin 统一计费（1 元 = 100 MCoin）
- 失败自动退款 —— 上游拉胯不扣你钱
- 工具持续扩充，路线图涵盖动作类、SaaS 集成、AI 能力

**接入方式**：

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

> 一句话总结：如果你只想装一个 MCP，就装 MCPCat。其他 9 个都是"特定场景专精"，它是"全能选手 + 持续进化"。

---

### 二、生活服务类（让 AI 真的懂你的日常）

#### 2️⃣ Weather MCP（官方/社区版）

天气查询，单点工具。MCPCat 里直接有，而且免费。

#### 3️⃣ Google Calendar / 飞书日程 MCP

让 AI 帮你建会议、查日程。助理类 Agent 必备。国内用户推荐飞书版。

---

### 三、开发者类（让 AI 真的会写代码、会运维）

#### 4️⃣ GitHub MCP ⭐⭐⭐⭐⭐

直接在 AI 里读 Issue、查 PR、跑 CI。团队协作神器。Claude Desktop / Cursor 都有官方版。

#### 5️⃣ Filesystem MCP ⭐⭐⭐⭐

本地文件读写，写代码、整理资料必备。

#### 6️⃣ PostgreSQL / SQLite MCP ⭐⭐⭐⭐

直接对数据库说话。"帮我查上个月销量前 10 的商品" → 秒出。

---

### 四、知识管理类（让 AI 记得住你的全部资料）

#### 7️⃣ Notion MCP ⭐⭐⭐⭐

让 AI 直接读写你的 Notion 笔记，写日报、整资料神器。

#### 8️⃣ Obsidian MCP（社区版）

适合本地知识库玩家，需自己折腾。

---

### 五、生产力类（让 AI 帮你处理日常事务）

#### 9️⃣ Playwright MCP（浏览器自动化）⭐⭐⭐⭐⭐

让 AI 自己开浏览器、点网页、填表单。**强烈推荐**。

#### 🔟 Slack MCP / 飞书消息 MCP

在 AI 里收发团队消息，国内推荐飞书版。

---

### 为什么第 1 个是 MCPCat？

其他 9 个 MCP 都是"特定场景专精工具"。

MCPCat 是唯一一个"工具市场"型 MCP —— 它把"工具接入"这个最痛苦的事**一次性全包**了。

而且它持续扩充，今天的 135+ 个工具只是开始。

---

### 专属福利

通过本文章链接注册 MCPCat，**额外赠送 50 MCoin**（活动期内）。

官网：https://www.mcpcat.cn
MCP 端点：mcp.mcpcat.cn/v1/mcp

---

> 🐱 MCPCat — 让每个 Agent 都有一只接口猫

---

## 📌 作者置顶评论（发布后立即评论）

> 很多人问「MCPCat 跟直接装 N 个 MCP 有什么区别」？
> 核心区别：**MCPCat 帮你**买 API 额度、**帮你**接 Adapter、**帮你**做计费、**帮你**做错误重试。你只管在 Claude/Cursor 里勾选要用的工具就行。
>
> 试用入口：https://www.mcpcat.cn （注册送 100 MCoin，够玩一周）

## ❓ FAQ 准备

发布后预期会被问：

- **Q：MCPCat 跟 Claude Code 是什么关系？**  
  A：MCPCat 不是 Claude Code，是给 Claude Code/Desktop 用的工具集。你装了 Claude Code 后，可以把 MCPCat 当成"工具市场"。

- **Q：MCPCat 跟 mcp.so 收录站有什么区别？**  
  A：mcp.so 是收录站（告诉你有哪些 MCP 可用），MCPCat 是网关（直接帮你用）。MCPCat 把所有 MCP 的 API 额度、计费、错误处理都包了。

- **Q：MCPCat 是开源的吗？**  
  A：核心代码私有，但客户端配置完全开放，5 分钟接入。

- **Q：MCPCat 怎么收费？**  
  A：按调用次数（MCoin），不调用不收钱。免费工具有 4 个。

- **Q：MCPCat 安全吗？**  
  A：API Key 用 sha256 存数据库；不接触你的 Claude 对话内容；调用日志 30 天自动清。

## 🎯 互动策略

- 前 30 条评论必回
- 对质疑耐心解答
- 主动 highlight 关键信息
- 引导加微信群：评论里问「怎么加群」就发二维码

## 🔗 内部链接位置（文末）

- 官网：https://www.mcpcat.cn
- 文档：https://www.mcpcat.cn/docs
- 注册：https://www.mcpcat.cn/register
