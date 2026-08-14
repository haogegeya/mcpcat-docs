# MCPCat 文档

MCPCat 官方文档仓库。

## 🚀 本地预览

### 使用 mkdocs（推荐）

```bash
# 安装 mkdocs
pip install mkdocs mkdocs-material pymdown-extensions

# 启动本地预览
mkdocs serve

# 浏览器打开 http://localhost:8000
```

### 使用 Docker

```bash
docker run --rm -it -p 8000:8000 -v ${PWD}:/docs squidfunk/mkdocs-material serve -a 0.0.0.0:8000
```

## 📦 构建静态站点

```bash
mkdocs build
```

输出在 `site/` 目录，可部署到任何静态托管服务。

## 🌐 部署

### GitHub Pages

推送到 `main` 分支后会自动部署（见 `.github/workflows/deploy.yml`）。

### Vercel

```bash
# 安装 vercel cli
npm i -g vercel

# 部署
vercel --prod
```

### Netlify

将 `site/` 目录拖到 Netlify 即可。

## 📁 目录结构

```
mcpcat-docs/
├── README.md              # 项目说明
├── LICENSE
├── CONTRIBUTING.md        # 贡献指南
├── CHANGELOG.md           # 更新日志
├── mkdocs.yml             # mkdocs 配置
├── docs/                  # 文档内容
│   ├── getting-started/   # 快速开始
│   ├── guides/            # 客户端接入
│   ├── api/               # API 参考
│   ├── tools/             # 工具列表
│   ├── assets/            # 静态资源
│   ├── pricing.md
│   ├── examples.md
│   ├── faq.md
│   └── roadmap.md
├── .github/               # GitHub 配置
│   ├── workflows/         # CI/CD
│   └── ISSUE_TEMPLATE/    # Issue 模板
└── scripts/               # 辅助脚本
```

## 🤝 贡献

详见 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 📄 许可证

[MIT](LICENSE)
