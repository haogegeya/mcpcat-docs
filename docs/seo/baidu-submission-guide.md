# 百度站长平台验证 Meta 标签

## 方式 A：HTML 标签验证（推荐，5 分钟搞定）

1. 登录 https://ziyuan.baidu.com
2. 站点管理 → 添加站点 → `https://www.mcpcat.cn`
3. 选「HTML 标签验证」
4. 百度会给你一段 meta 标签，类似：
   ```html
   <meta name="baidu-site-verification" content="xxxxxxxxxxxx" />
   ```
5. 把这段 meta 标签粘到你**首页 `<head>`** 里的任意位置
6. 点百度后台的「完成验证」按钮

### 验证位置

放这都行：
- Next.js 的 `app/layout.tsx` 里 `<head>` 块
- 或者直接放 `<head>` 顶层

---

## 方式 B：HTML 文件验证（更简单）

1. 选「文件验证」
2. 下载百度的验证文件（类似 `baidu_verify_xxxx.html`）
3. 上传到网站**根目录**：`https://www.mcpcat.cn/baidu_verify_xxxx.html`
4. 点「完成验证」

---

## 方式 C：DNS 验证（最稳，但需要改 DNS）

1. 选「CNAME 验证」
2. 百度会给你一个 CNAME 记录值
3. 去你域名服务商（阿里云/腾讯云/Cloudflare）加解析
4. 等几分钟生效后点「完成验证」

---

## 验证通过后，必须做的 3 件事

### 1. 提交 sitemap
- 资源提交 → sitemap → 添加 `https://www.mcpcat.cn/sitemap.xml`

### 2. 第一次普通收录 API 推送
- 资源提交 → 普通收录 → 推送接口
- 复制 token 填到 `scripts/.env.baidu` 里
- 跑 `bash scripts/baidu_push.sh`

### 3. 提交死链（重要）
- 死链提交 → 添加死链文件
- 我已经帮你扫到 4 个 404：`/blog` `/help` `/about` `/privacy`
- 提交格式：
  ```
  https://www.mcpcat.cn/blog
  https://www.mcpcat.cn/help
  https://www.mcpcat.cn/about
  https://www.mcpcat.cn/privacy
  ```

---

## 验证后每天的日常

| 时间 | 动作 |
|------|------|
| 早 9 点 | 跑推送脚本（自动） |
| 晚上 | 看百度后台数据 |
| 周一 | 提一次新内容 |

---

## Bing / Google 站长（顺手也注册）

- **Google Search Console**：https://search.google.com/search-console/
- **Bing Webmaster**：https://www.bing.com/webmasters

MCPCat 主要是国内市场，但 Bing/Google 也能给你带些流量。

---

## 预期时间线

| 阶段 | 时间 | 表现 |
|------|------|------|
| Day 1-3 | 提交后 | 后台显示「已抓取」「已收录」首页 |
| Day 4-7 | 持续推送 | 注册/登录/docs 都被收录 |
| Day 8-14 | 有外链后 | 搜索「MCP 工具」能搜到 |
| Day 15-30 | 持续运营 | 搜索「MCP 聚合」「MCP 网关」有排名 |
