# OpenClaw 接入指南

> OpenClaw 个人 AI 助手接入 MCPCat

## 📋 前置准备

1. 已部署 OpenClaw（参考 OpenClaw 官方文档）
2. 已注册 [MCPCat](https://mcpcat.cn) 账号
3. 已创建 API Key

---

## ⚙️ 配置步骤

### Step 1：找到配置文件

OpenClaw 的 MCP 配置文件位置：

```
~/.openclaw/workspace/mcp.json
```

或在工作区根目录：

```
~/.openclaw/workspace-coder/mcp.json
```

### Step 2：创建/编辑 mcp.json

```bash
mkdir -p ~/.openclaw/workspace
nano ~/.openclaw/workspace/mcp.json
```

### Step 3：添加 MCPCat 配置

```json
{
  "mcpServers": {
    "mcpcat": {
      "url": "https://mcp.mcpcat.cn/v1/mcp",
      "headers": {
        "Authorization": "***"
      }
    }
  }
}
```

> ⚠️ 把 `mcpc_sk_xxxxx` 替换为你的真实 API Key。

### Step 4：重启 OpenClaw

```bash
# 如果用 systemd（用户级服务）
systemctl --user restart openclaw

# 如果用 systemd（系统级服务）
sudo systemctl restart openclaw

# 如果用 nohup
ps aux | grep openclaw
kill <pid>
nohup openclaw &
```

### Step 5：验证

在 OpenClaw 对话中说：

> "用 mcpcat 查北京今天天气"

如果返回了真实天气数据，说明配置成功。

---

## 💬 使用示例

### 基础查询

> "明天去北京出差，帮我查一下北京明天的天气"

OpenClaw 会调用 MCPCat 的 `weather_query` 工具。

### 组合查询

> "我有个顺丰快递 SF1234567890，帮我查一下到哪了。如果到了北京，顺便查一下北京今天的天气"

OpenClaw 会：
1. 调用 `express_query` 查快递
2. 根据结果判断是否需要调用 `weather_query`

### 定时任务集成

在 OpenClaw 配合 cron 做每日提醒：

> "每天早上 7 点用 MCPCat 查北京天气并播报"

（需结合 OpenClaw 的定时任务能力）

---

## 🎨 高级配置

### 多个 MCPCat 服务器

```json
{
  "mcpServers": {
    "mcpcat": {
      "url": "https://mcp.mcpcat.cn/v1/mcp",
      "headers": {"Authorization": "Bearer mcpc_sk_xxxxx"}
    },
    "mcpcat-test": {
      "url": "https://test.mcp.mcpcat.cn/v1/mcp",
      "headers": {"Authorization": "Bearer mcpc_sk_test_xxxxx"}
    }
  }
}
```

### 与 OpenClaw 其他能力组合

OpenClaw 通常已配置小爱音箱、邮件等能力，与 MCPCat 组合可以做：

- 定时查天气 → 推送到小爱音箱播报
- 收到邮件 → 自动调用 MCPCat 提取关键信息
- 文件变更 → 调用 MCPCat 相关工具处理

---

## 🆘 常见问题

### ❌ OpenClaw 没识别到 MCPCat？

1. 确认 `mcp.json` 路径正确
2. 确认 JSON 格式正确
3. 完全重启 OpenClaw（包括杀掉所有相关进程）
4. 查看 OpenClaw 日志

### ❌ 工具调用超时？

- 检查网络：`curl -I https://mcp.mcpcat.cn`
- 临时关闭代理
- 检查 API Key 余额

### ❌ 想用本地测试环境？

修改 URL 指向测试环境：

```json
{
  "mcpServers": {
    "mcpcat": {
      "url": "http://192.168.1.35:8015/v1/mcp",
      "headers": {"Authorization": "Bearer mcpc_sk_xxxxx"}
    }
  }
}
```

> ⚠️ 本地测试环境需要 OpenClaw 能访问 192.168.1.35 主机。

---

## 📚 相关文档

- [快速开始](../getting-started/quickstart.md) — 5 分钟接入
- [Claude Desktop](claude-desktop.md) — 另一个客户端
- [Cursor](cursor.md) — 另一个客户端
- [工具列表](../tools/README.md) — 全部可用工具

---

> 🐱 OpenClaw + MCPCat = 个人 AI 助理的瑞士军刀
