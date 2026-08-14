# GitHub README 友链引导

> 在你的 haogegeya 账号下各个仓库的 README 里加 mcpcat.cn 链接。

## 已有的 haogegeya 仓库（可加外链）

去 https://github.com/haogegeya 查仓库列表，给每个活跃仓库的 README 加：

### README 模板（放在底部「相关项目」或「更多项目」区）

```markdown
---

## 🔗 作者的其他项目

- 🐱 **[MCPCat](https://www.mcpcat.cn)** — 一个 MCP 端点接入 135+ 个 AI 工具，让 Claude/Cursor 立刻能用
- 📚 **[MCPCat 文档](https://github.com/haogegeya/mcpcat-docs)** — MCPCat 官方文档
```

或者如果你只想要一行：

```markdown
[![MCPCat - 一个 MCP 端点接入 135+ 个 AI 工具](https://img.shields.io/badge/MCPCat-MCP_聚合网关-FF6B35)](https://www.mcpcat.cn)
```

---

## 操作步骤

### 1. 列你现有的活跃仓库
```bash
gh repo list haogegeya --limit 30 --source
```
（如果你没装 gh，用 https://github.com/haogegeya 浏览器看）

### 2. 选 5-10 个流量最大的仓库
优先选：
- ⭐ star 数最多的
- 🍴 fork 数最多的
- 📈 最近一年还有更新的

### 3. 每个仓库加链接

cd 到项目目录，编辑 README.md，底部加「相关项目」段：

```bash
cd ~/Desktop/projects/<某个项目>
nano README.md
# 底部粘贴上面的模板
git add README.md
git commit -m "docs: add related projects section"
git push
```

---

## 为什么这能帮百度收录？

百度计算外链权重时：
- **同账号外链**：⭐⭐（权重低，但有用，证明你站存在）
- **同 IP 外链**：⭐⭐⭐（权重中）
- **第三方站点外链**：⭐⭐⭐⭐⭐（权重高）

GitHub README 外链属于**第一/二类**，**只能保底**，**真正有效的是第三方**。

所以：GitHub 友链 + 知乎/掘金/V2EX/CSDN/即刻 文章外链 = 完整外链策略。

---

## 一次性快速加链接的脚本（如果你愿意用）

```bash
#!/bin/bash
# 给所有 haogegeya 仓库的 README 加 MCPCat 友链
# 用法: cd 到 haogegeya 仓库父目录，bash add_friend_links.sh

MCPCAT_LINK='[![MCPCat - 一个 MCP 端点接入 135+ 个 AI 工具](https://img.shields.io/badge/MCPCat-MCP_聚合网关-FF6B35)](https://www.mcpcat.cn)'

for dir in */; do
  cd "$dir" || continue
  if [ -f "README.md" ]; then
    # 检查是否已经加过
    if ! grep -q "mcpcat.cn" README.md; then
      echo "添加友链到: $dir"
      echo "" >> README.md
      echo "---" >> README.md
      echo "" >> README.md
      echo "## 🔗 相关项目" >> README.md
      echo "" >> README.md
      echo "$MCPCAT_LINK" >> README.md
    fi
  fi
  cd ..
done
```

⚠️ 跑之前先确认这是你自己的仓库集合。

---

## 第三方外链清单（5-10 条就够了）

按权重从高到低：

| 站点 | 类型 | 加链接难度 | 流量 |
|------|------|-----------|------|
| 知乎专栏 | 高权重 | 1 分钟 | 高 |
| 掘金 | 高权重 | 1 分钟 | 高 |
| CSDN | 高权重 | 1 分钟 | 中 |
| V2EX | 高权重 | 1 分钟 | 中 |
| 即刻 | 中权重 | 1 分钟 | 中 |
| SegmentFault | 中权重 | 1 分钟 | 中 |
| 博客园 | 中权重 | 1 分钟 | 低 |
| 微信公众号 | 高权重 | 难（需原创）| 高 |
| 36氪/极客公园 | 高权重 | 难（需审核）| 很高 |
| 友链交换 | 中权重 | 看对方 | 看对方 |

**最简方案**：你前面让我写的 5 篇软文（知乎/掘金/V2EX/即刻/CSDN），**文末加 mcpcat.cn 链接 = 一次性 5 条高质量外链**。

---

## 监控外链

百度站长后台 → 外链分析，能看到所有外链。

外链增长曲线 = 百度权重增长曲线。

---

## 时间表

| Day | 任务 |
|-----|------|
| Day 1 | 5 篇软文发布（带 mcpcat.cn 链接） |
| Day 1-2 | 10 个 GitHub 仓库 README 加友链 |
| Day 3 | 注册百度站长平台 |
| Day 4 | 提交 sitemap + 第一次 API 推送 |
| Day 7 | 看外链收录数 |
| Day 14 | 复盘：哪些外链有用 / 哪些没用 |

---

## 关键提醒

**别做这些（百度会惩罚）**：
- ❌ 买外链（黑帽）
- ❌ 群发垃圾评论带链接
- ❌ 站群互链
- ❌ 隐藏外链
- ❌ 跟无关站点交换友链

**应该做的**：
- ✅ 内容里自然带链接
- ✅ 友链站点主题相关
- ✅ 持续发高质量内容
- ✅ 站点备案 + ICP 合规
