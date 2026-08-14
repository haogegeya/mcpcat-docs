# 贡献指南

> 感谢你愿意为 MCPCat 文档做出贡献！🎉

## 📋 文档范围

本仓库收录的内容包括：

- ✅ MCPCat 产品功能介绍
- ✅ API 参考文档
- ✅ 客户端接入指南（Claude Desktop / Cursor / Cline / OpenClaw 等）
- ✅ 工具使用说明
- ✅ 常见问题解答
- ✅ 实战案例

## 🐛 报告问题

**发现文档错误？**

请 [提交 Issue](https://github.com/haogegeya/mcpcat-docs/issues/new)，并包含：

- 文档文件路径
- 错误描述
- 建议修改内容（如有）

**有功能疑问？**

- 工具使用问题：加入 MCPCat 用户群
- 商务合作：support@mcpcat.cn

## ✏️ 提交修改

### 提交流程

1. **Fork** 本仓库
2. 创建特性分支：`git checkout -b feature/your-improvement`
3. 提交修改：`git commit -m "docs: 完善 XX 章节"`
4. 推送分支：`git push origin feature/your-improvement`
5. 提交 **Pull Request**

### 提交规范

提交信息采用 [Conventional Commits](https://www.conventionalcommits.org/)：

- `docs: xxx` — 文档修改
- `fix: xxx` — 文档错误修复
- `feat: xxx` — 新增文档章节
- `style: xxx` — 格式调整（不影响内容）
- `chore: xxx` — 杂项

示例：
```bash
git commit -m "docs: 补充 Claude Desktop 配置截图"
git commit -m "fix: 修正 weather_query 工具参数名"
```

### 文档规范

- **文件名**：使用小写 + 中划线，如 `claude-desktop.md`
- **标题层级**：每个文档从 `#` 一级标题开始
- **代码块**：标注语言，如 ` ```json `、` ```bash `
- **链接**：内部链接使用相对路径，如 `[快速开始](getting-started/quickstart.md)`
- **图片**：放在 `docs/assets/` 目录，使用相对路径引用
- **Emoji**：适度使用，提升可读性，避免过度

### 内容原则

- **准确性**：以实际产品功能为准，不夸大
- **可读性**：多用列表、表格、代码块，少用大段文字
- **实用性**：多给示例，少讲理论
- **可搜索**：关键术语首次出现时给完整解释

## 🔧 本地预览

### MkDocs（推荐）

```bash
pip install mkdocs mkdocs-material
mkdocs serve
```

访问 http://localhost:8000

### 直接查看

直接用 Markdown 编辑器（如 VSCode、Typora）打开 `docs/` 目录下的文件。

## 📦 目录结构

```
mcpcat-docs/
├── README.md              # 项目主入口
├── LICENSE
├── CONTRIBUTING.md        # 本文件
├── CHANGELOG.md           # 更新日志
├── docs/                  # 文档内容
│   ├── getting-started/   # 快速开始
│   ├── guides/            # 客户端接入
│   ├── api/               # API 参考
│   ├── tools/             # 工具列表
│   └── assets/            # 图片资源
├── .github/               # GitHub 配置
│   └── ISSUE_TEMPLATE/    # Issue 模板
└── scripts/               # 辅助脚本
```

## 📞 联系我们

- **GitHub Issues**：https://github.com/haogegeya/mcpcat-docs/issues
- **邮箱**：support@mcpcat.cn
- **官网**：https://mcpcat.cn

---

再次感谢你的贡献！每一份改进都会让 MCPCat 变得更好 🐱
