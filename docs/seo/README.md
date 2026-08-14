# 🎯 MCPCat 百度收录完整方案

> 14 天内让 www.mcpcat.cn 被百度收录并获得初始排名。

## 📁 目录

- [快速开始（5 分钟）](#快速开始)
- [完整 14 天计划](#完整-14-天计划)
- [关键文件](#关键文件)

---

## 🚀 快速开始

### 5 分钟搞定的 4 件事

1. **注册百度站长**：https://ziyuan.baidu.com
2. **验证站点**：HTML 标签（贴个 meta 标签）
3. **提交 sitemap**：`https://www.mcpcat.cn/sitemap.xml`
4. **跑第一次推送**：
   ```bash
   cd /home/two/Desktop/projects/mcpcat-docs
   cp scripts/.env.baidu.example scripts/.env.baidu
   # 编辑 .env.baidu 填入从百度站长后台拿到的 token
   nano scripts/.env.baidu
   bash scripts/baidu_push.sh
   ```

---

## 📅 完整 14 天计划

### Day 1（今天）
- [x] 扫死链（4 个 404：`/blog` `/help` `/about` `/privacy`）
- [ ] 注册百度站长平台
- [ ] 验证站点（HTML 标签或文件）
- [ ] 跑第一次 `bash baidu_push.sh`
- [ ] 修 `next.config.js` 加 301 重定向
- [ ] 建 `/privacy` 页面（合规）

### Day 2-3
- [ ] 每天跑一次推送
- [ ] 发布 5 篇软文（知乎/掘金/V2EX/即刻/CSDN），文末带 mcpcat.cn 链接
- [ ] 给 5-10 个 GitHub 仓库 README 加友链

### Day 4-7
- [ ] 每天跑一次推送
- [ ] 再发 3-5 篇带外链的软文
- [ ] 看百度站长后台：抓取频次、索引量、外链数
- [ ] 注册 Bing 站长、Google Search Console（顺手）

### Day 8-14
- [ ] 持续每天推送
- [ ] 在知乎/掘金/百度知道回答「MCP 工具」相关问题，每条带 mcpcat.cn
- [ ] 找 3-5 个 AI 站点做友链交换
- [ ] 监控「百度站长 → 索引量」变化

---

## 🎯 预期里程碑

| 时间 | 预期表现 |
|------|---------|
| Day 1-2 | 站长后台显示「已抓取 1」 |
| Day 3-5 | 搜索 site:mcpcat.cn 有结果 |
| Day 5-10 | 搜索「MCP 工具」「MCPCat」能搜到 |
| Day 10-14 | 搜索「MCP 聚合网关」「MCP 网关」有排名 |
| Day 30 | 搜索「MCP 网关」首页前 3 页 |

---

## 📁 关键文件

### 本目录

- `baidu-submission-guide.md` — 百度站长平台验证详细教程
- `dead-links-fix.md` — 死链修复方案
- `external-links-guide.md` — 外链建设方案
- `articles/zhihu-article-with-links.md` — 知乎软文（带外链）
- `articles/juejin-article-with-links.md` — 掘金软文
- `articles/v2ex-post-with-links.md` — V2EX 软文
- `articles/jike-post-with-links.md` — 即刻软文
- `articles/csdn-article-with-links.md` — CSDN 软文

### scripts/ 目录

- `baidu_push.sh` — 百度主动推送脚本
- `.env.baidu.example` — token 配置模板
- `robots.txt.proposed` — 优化版 robots.txt
- `sitemap.xml.proposed` — 优化版 sitemap.xml

---

## ⚠️ 关键提醒

1. **备案号**：站内已写「京ICP备2026046950号-1」，确认跟备案系统对得上
2. **canonical**：现在是 `https://mcpcat.cn`（没 www），如果你想统一到 www，所有外链都用 www 版本
3. **HTTPS**：✅ 已全站 HTTPS
4. **内容质量**：百度偏爱**持续更新 + 原创内容**，博客每周至少 1 篇
5. **不要作弊**：买外链、群发垃圾、站群互链 = 100% 被惩罚

---

## 🆘 常见问题

### Q: 多久能被收录？
A: 备案 + 主动推送 + 外链 = 3-7 天。无备案纯靠外链 = 1-3 个月。

### Q: 为什么只提交了 5 个 URL？
A: console/* 需要登录才能访问，推给百度也爬不到。营销页 + 法律页 + docs 共 5 个，能被爬的就是这 5 个。

### Q: console 页怎么收录？
A: 百度有「登录态爬虫」，但只对大站开放。小站不指望。把 console 页 Disallow 掉（robots.txt 已设）。

### Q: sitemap 多久更新一次？
A: 你站点每次有内容更新就重新生成并提交。Next.js 用 `next-sitemap` 插件自动生成。

### Q: 推送配额用完了怎么办？
A: 每天 2000-5000 条配额（看你站点的百度权重），用完等第二天。

---

## 🛠️ 自动化

### 配 cron 每天自动推送

```bash
# 编辑 crontab
crontab -e

# 加这一行（每天早上 9 点推送）
0 9 * * * cd /home/two/Desktop/projects/mcpcat-docs && bash scripts/baidu_push.sh >> scripts/push.log 2>&1
```

### 配 sitemap 自动生成（Next.js）

```bash
cd /home/two/Desktop/projects/mcpcat
npm install -D next-sitemap

# next-sitemap.config.js
cat > next-sitemap.config.js << 'EOF'
module.exports = {
  siteUrl: 'https://www.mcpcat.cn',
  generateRobotsTxt: true,
  changefreq: 'daily',
  priority: 0.7,
  robotsTxtOptions: {
    policies: [
      { userAgent: '*', allow: '/', disallow: ['/console', '/admin', '/api'] }
    ]
  }
}
EOF

# package.json 加 script
"postbuild": "next-sitemap"
```

---

## 🎁 额外加分手册

### 微信公众号（百度特别偏爱）
1. 注册「MCPCat」公众号
2. 每周发 1 篇技术文章，文末带阅读原文链接到 mcpcat.cn
3. 微信里的外链百度爬得到（虽然慢）

### 百度知道 / 百度经验
1. 搜「MCP 工具」「MCP 协议」「MCPCat」
2. 自问自答，回答里带 mcpcat.cn 链接
3. ⚠️ 不要太广告化，答的专业点

### 短视频平台
1. B站/抖音发 1-2 分钟教程
2. 视频简介带 mcpcat.cn
3. 百度短视频搜索能搜到

### 小程序（加分项）
1. 做个「MCPCat 工具市场」小程序
2. 百度小程序能被快速收录

---

## 📞 需要我帮你做的

- [ ] 配 cron 每天自动推送
- [ ] 写 next.config.js 的 301 重定向代码
- [ ] 写 /privacy 页面内容
- [ ] 写 5 篇博客内容（持续 SEO 营养）
- [ ] 写 sitemap 自动生成脚本

挑你想要的，回我就开干。
