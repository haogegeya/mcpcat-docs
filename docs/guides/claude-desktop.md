# Claude Desktop 接入指南

> Anthropic 官方桌面客户端，原生支持 MCP 协议

## 📋 前置准备

1. 安装 [Claude Desktop](https://claude.ai/download)（macOS/Windows/Linux）
2. 已注册 [MCPCat](https://mcpcat.cn) 账号
3. 已创建 API Key（[获取方式](../getting-started/quickstart.md#step-2创建-api-key)）

---

## ⚙️ 配置文件位置

| 系统 | 路径 |
|------|------|
| **macOS** | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| **Windows** | `%APPDATA%\Claude\claude_desktop_config.json` |
| **Linux** | `~/.config/Claude/claude_desktop_config.json` |

---

## 🔧 配置步骤

### 1. 关闭 Claude Desktop

确保完全退出（macOS 右键 Dock 图标 → 退出）。

### 2. 打开配置文件

如果文件不存在则创建：

```bash
# macOS
mkdir -p ~/Library/Application\ Support/Claude
nano ~/Library/Application\ Support/Claude/claude_desktop_config.json

# Linux
mkdir -p ~/.config/Claude
nano ~/.config/Claude/claude_desktop_config.json
```

### 3. 添加 MCPCat 配置

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

如果你已有其他 MCP 服务器，可以并列添加：

```json
{
  "mcpServers": {
    "mcpcat": {
      "url": "https://mcp.mcpcat.cn/v1/mcp",
      "headers": {
        "Authorization": "***"
      }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/Users/you/Documents"]
    }
  }
}
```

### 4. 保存并重启

1. 保存文件
2. 启动 Claude Desktop
3. 等待几秒让 MCP 客户端初始化

### 5. 验证配置

- 点击左下角"设置"图标
- 进入"开发者"或"扩展"页面
- 应该能看到 **mcpcat** 服务器，状态为"已连接"
- 工具列表应包含你勾选的工具

---

## 💬 使用示例

在 Claude Desktop 中对话：

> "帮我查北京今天的天气"

Claude 会自动调用 MCPCat 的 `weather_query` 工具，返回结果：

> 北京今天晴，温度 18-26°C，东南风 2 级，空气质量良。

更多使用案例：

> "我有个顺丰快递 SF1234567890，帮我查一下到哪了"
>
> "13800138000 是哪个运营商的号"
>
> "查一下今天全国 92 号汽油的价格"

---

## 🎨 高级配置

### 配置多个 Key

为不同用途创建不同 Key，在配置中使用不同服务器名：

```json
{
  "mcpServers": {
    "mcpcat-personal": {
      "url": "https://mcp.mcpcat.cn/v1/mcp",
      "headers": {"Authorization": "***"}
    },
    "mcpcat-work": {
      "url": "https://mcp.mcpcat.cn/v1/mcp",
      "headers": {"Authorization": "mcpc_sk_work_xxxxx"}
    }
  }
}
```

### 自定义工具描述（可选）

Claude 会从 `tools/list` 拉取工具描述，无需手动配置。

### 启用调试日志

macOS：

```bash
tail -f ~/Library/Logs/Claude/mcp*.log
```

Windows：设置 → 开发者 → 日志

---

## 🆘 常见问题

### ❌ 配置后没看到 mcpcat 服务器？

- 确认 JSON 格式正确（用 https://jsonlint.com 校验）
- 确认 API Key 格式正确（`mcpc_sk_` 前缀，32 位字符）
- 完全退出 Claude Desktop 后重新启动
- 查看日志找错误：macOS `~/Library/Logs/Claude/`

### ❌ Claude 提示"无法连接到 mcpcat"？

- 检查网络能否访问 `mcp.mcpcat.cn`：
  ```bash
  curl -I https://mcp.mcpcat.cn
  ```
- 确认 URL 拼写正确：`https://mcp.mcpcat.cn/v1/mcp`（带 `/v1/mcp`）
- 临时关闭代理 / VPN 试试
- 检查系统代理设置

### ❌ 工具列表为空？

- 登录 [MCPCat 控制台](https://mcpcat.cn/console/tools)
- 确认已在「工具市场」勾选至少一个工具
- 等待几秒后 Claude Desktop 会重新拉取工具列表

### ❌ 工具调用失败？

- 查看 [错误码文档](../api/error-codes.md)
- 检查 API Key 余额：登录控制台 → 钱包
- 确认参数名正确（参考 [工具列表](../tools/README.md)）
- 联系 support@mcpcat.cn

### ❌ Claude 没有主动调用工具？

- 在对话中**明确说明需求**，如"用 mcpcat 查一下"
- 确认工具已勾选并被 Claude 看到
- 尝试更具体的描述，如"查北京天气，温度多少度"

---

## 📚 相关文档

- [快速开始](../getting-started/quickstart.md) — 5 分钟接入
- [认证说明](../getting-started/authentication.md) — API Key 管理
- [其他客户端](README.md) — Cursor / Cline / OpenClaw
- [工具列表](../tools/README.md) — 全部可用工具

---

> 🐱 Claude Desktop + MCPCat = 你的私人 AI 助理团队
