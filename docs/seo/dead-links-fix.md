# 🚨 死链修复清单

> 扫 www.mcpcat.cn 时发现的 404 页面，建议**立刻修复**否则影响百度权重。

## 当前状态（2026-08-14 扫）

| URL | 状态 | 来源 | 优先级 | 处理方式 |
|-----|------|------|--------|----------|
| `/blog` | 404 | 无站内链接 | 中 | 短期：301 到 `/docs`，长期：建博客 |
| `/help` | 404 | 无站内链接 | 低 | 直接 301 到 `/docs` |
| `/about` | 404 | 无站内链接 | 低 | 直接 301 到 `/` |
| `/privacy` | 404 | 无站内链接 | 中 | **必建**（合规要求） |

---

## 处理方式 1：直接 301 重定向（最快）

如果你不想建这 4 个页面，在 Next.js 的 `next.config.js` 里加：

```js
async redirects() {
  return [
    {
      source: '/blog',
      destination: '/docs',
      permanent: true,  // 301
    },
    {
      source: '/help',
      destination: '/docs',
      permanent: true,
    },
    {
      source: '/about',
      destination: '/',
      permanent: true,
    },
  ]
}
```

⚠️ `/privacy` 建议**真建一个页面**（法规要求，避免法律风险）

---

## 处理方式 2：真建页面（推荐）

### 优先级 P0：**隐私政策 `/privacy`**（必建）

法律要求所有备案网站必须展示《隐私政策》。

模板：

```markdown
# 隐私政策

最近更新：2026-08-14

## 我们收集什么
- 账号信息（手机号/邮箱）
- 使用记录（API 调用日志，保留 30 天）
- Cookie（仅必要项）

## 用来干什么
- 提供核心服务
- 计费
- 防止滥用

## 你的权利
- 随时查看/导出/删除你的数据
- 注销账号
- 联系 privacy@mcpcat.cn

## 联系方式
北京闪码科技有限公司
邮箱：privacy@mcpcat.cn
```

### 优先级 P1：**博客 `/blog`**（SEO 杀手锏）

百度**极度偏爱博客内容**。建议每周发 1-2 篇：

- 《MCP 协议入门》
- 《5 个让 Agent 飞起来的 MCP 工具》
- 《Cursor + MCPCat 配置指南》
- 《如何用 MCPCat 调快递查询》
- 《MCPCat 路线图 v0.5》

每篇博客 = 1 个 SEO 长尾词入口 = 持续流量。

### 优先级 P2：**关于 `/about`**（增加信任）

简单写一下公司、团队、愿景。1 页 A4 纸就够。

### 优先级 P3：**帮助中心 `/help`**（可选）

如果 FAQ 多（你 `docs/faq.md` 已经有内容），可以把 FAQ 整理到这里。

---

## 现在就做的 3 步

### 1. 修 `next.config.js`（5 分钟）
把上面 `处理方式 1` 的代码加进去

### 2. 提交死链到百度站长（1 分钟）
```bash
# 用死链提交接口，需要从百度站长后台拿 token
# 1. 死链提交 → 文件地址
# 2. 把下面这个文件上传到网站根目录

cat > /tmp/deadlinks.txt << 'EOF'
https://www.mcpcat.cn/blog
https://www.mcpcat.cn/help
https://www.mcpcat.cn/about
https://www.mcpcat.cn/privacy
EOF

# 上传到 https://www.mcpcat.cn/deadlinks.txt
# 然后到死链提交页面填 https://www.mcpcat.cn/deadlinks.txt
```

### 3. 立刻建 `/privacy`（30 分钟）
法律合规要求，必做。

---

## 长期建议

| 频率 | 动作 |
|------|------|
| 每月 | 扫一次死链（`bash scan_deadlinks.sh`） |
| 每周 | 发 1-2 篇博客 |
| 每天 | 跑百度推送 |

---

## 验证修复完成

修完后跑：

```bash
bash scripts/scan_deadlinks.sh
```

应该看到所有 URL 都是 200/301，没有 4xx/5xx。
