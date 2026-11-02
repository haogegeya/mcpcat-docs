# MCPCat 文档

MCPCat 官方文档仓库。

## 🚀 本地预览

### 建环境（按本机约定用 conda，不用 venv）

```bash
conda create -y -n mcpcat-docs python=3.11
conda run -n mcpcat-docs pip install -r requirements.txt
```

`requirements.txt` 是唯一依赖来源，本地、CI、Deploy Docs 三处共用同一份。
**别在别处手写 `pip install mkdocs mkdocs-material`** —— 2026-08-14 那次部署失败
就是这么漏掉了 `mkdocs-minify-plugin`，`mkdocs.yml` 里声明了 `plugins: minify`
却没装它，build 直接 abort。

### 启动预览

```bash
bash scripts/preview.sh          # 等价于 conda run -n mcpcat-docs mkdocs serve
```

浏览器打开 <http://localhost:8000>

## 📦 构建静态站点

```bash
bash scripts/build.sh            # 内部执行 mkdocs build --strict
```

**务必带 `--strict`**：它把警告当错误。断链、nav 里指向不存在的文件、锚点失效
都会在这里暴露，而不是等 CI 红了才发现。

改 `mkdocs.yml` 的 `plugins` / `markdown_extensions` 时，记得同步 `requirements.txt`。

## 🔍 推送前三项检查

```bash
conda run -n mcpcat-docs mkdocs build --strict        # 站点构建（零警告）
markdownlint '**/*.md' --ignore node_modules --ignore site   # Markdown 规范
lychee --offline 'docs/**/*.md' README.md             # 内部链接
```

三条命令与 `.github/workflows/ci.yml` 的三个 job 一一对应，本地全绿再 push。

## 🌐 部署

推送到 `main` 后由 `.github/workflows/deploy.yml` 自动构建并发布到 GitHub Pages。
站点地址见 `mkdocs.yml` 的 `site_url`。

`docs/seo/` 与 `docs/assets/*.md` 是内部运营手册（含本机路径与推送流程），
通过 `mkdocs.yml` 的 `exclude_docs` 排除发布，文件仍保留在仓库里。

## 📁 目录结构

```text
mcpcat-docs/
├── README.md              # GitHub 仓库页（不进站点）
├── LICENSE
├── mkdocs.yml             # mkdocs 配置
├── requirements.txt       # 构建依赖（本地/CI/Deploy 共用）
├── .markdownlint.json     # markdownlint 规则（关掉对中文不适用的风格规则）
├── docs/                  # 文档内容 = 站点全部页面
│   ├── index.md           # 站内首页（nav 的「首页」）
│   ├── getting-started/   # 快速开始
│   ├── guides/            # 客户端接入
│   ├── api/               # API 参考
│   ├── tools/             # 工具列表
│   ├── CHANGELOG.md       # 更新日志（需在 nav 里才进站）
│   ├── CONTRIBUTING.md    # 贡献指南
│   ├── pricing.md / examples.md / faq.md / roadmap.md
│   ├── assets/            # 发布文案（exclude_docs 排除，不公开）
│   └── seo/               # 百度收录手册（exclude_docs 排除，不公开）
├── .github/               # GitHub 配置
│   ├── workflows/         # ci.yml + deploy.yml
│   └── ISSUE_TEMPLATE/    # Issue 模板
└── scripts/               # 辅助脚本（build/preview/baidu 推送）
```

## 🤝 贡献

详见 [CONTRIBUTING.md](../docs/CONTRIBUTING.md)。

## 📄 许可证

[MIT](../LICENSE)
