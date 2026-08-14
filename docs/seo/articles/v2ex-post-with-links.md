# V2EX 版本（带 mcpcat.cn 外链版）

## 标题
**做了个 MCP 聚合网关 MCPCat，一个端点搞定 135+ AI 工具（送 100 MCoin）**

## 节点
创造者 / 程序员 / 分享创造

---

## 正文

MCP 出来一年了，我也用了一年。

最大的痛点：**想给 AI 装个工具，得自己买 API、申请 AppCode、写胶水代码**。

去年为了给 Claude 装天气 + 快递 + 手机归属地三个工具，我折腾了 3 个晚上。

然后我想到：应该不止我一个人有这个痛点。

于是做了 **MCPCat**（mcpcat.cn），一个 MCP 能力聚合网关。

## 核心

- 一个 MCP URL = 135+ 个工具（天气、快递、手机归属、IP 归属、贵金属、发票验真、条码、火车票、油价、运营商三要素、携号转网、空气质量…）
- 0 代码，0 部署，5 分钟接入
- 平台币 MCoin 计费（1 元 = 100 MCoin）
- 失败自动退款

## 接入方式

在 claude_desktop_config.json 加：

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

去 https://www.mcpcat.cn 注册送 100 MCoin，够玩一周。

## 技术栈

- FastAPI + Streamable HTTP
- Next.js 14 控制台
- MySQL + Redis
- 三层 Adapter 架构（填配置 / 选模板 / 写代码）
- 热加载（Redis Pub/Sub）

## 文档

GitHub: https://github.com/haogegeya/mcpcat-docs
官网: https://www.mcpcat.cn

## 路线图

数据查询（当前） → 动作执行 → SaaS 集成 → AI 能力 → 私有自动化

短期计划上线：翻译、OCR、股票、地图、汇率。

## 提问

- 你们目前用 MCP 装了哪些工具？
- 觉得哪些场景最需要 MCP 化？
- 对"按次扣费"vs"订阅制"怎么看？

欢迎评论区讨论。

---

**update**: 刚推了 GitHub 文档站，star 一下：https://github.com/haogegeya/mcpcat-docs

---

## 📌 互动话术

- 有人问「和 mcp.so 收录站区别」→ MCPCat 是网关（直接能用），mcp.so 是收录站（告诉你有哪些 MCP 可用）
- 有人问「怎么盈利」→ 按调用收费（MCoin），1 元 100 币，免费工具有 4 个
- 有人问「凭什么比自建好」→ 自建要买 135+ 个 API、写 135+ 个 Adapter、处理 135+ 种错误、计费 135+ 次，MCPCat 全包
