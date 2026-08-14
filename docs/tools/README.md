# 🧰 工具市场

> MCPCat 当前所有可用工具的完整索引

## 📊 工具总览

**当前已上线 13 个工具**，覆盖 7 大场景。所有工具都支持 MCP 标准协议，AI Agent 可直接调用。

---

## 🗂️ 按场景分类

### 🌤️ [生活服务](lifestyle.md)
日常查询类工具，免费为主

| 工具 | 描述 | 定价 |
|------|------|------|
| [`weather_query`](lifestyle.md#weather_query) | 城市天气查询 | **免费** |
| [`air_quality_query`](lifestyle.md#air_quality_query) | 城市空气质量 | **免费** |

### 📦 [物流快递](express.md)
快递物流跟踪

| 工具 | 描述 | 定价 |
|------|------|------|
| [`express_query`](express.md#express_query) | 快递查询 | 3 MCoin/次 |
| [`express_query_v2`](express.md#express_query_v2) | 快递查询增强版 | 3 MCoin/次 |

### 📱 [通信查询](communication.md)
手机号相关

| 工具 | 描述 | 定价 |
|------|------|------|
| [`phone_attribution`](communication.md#phone_attribution) | 手机归属地 | 3 MCoin/次 |
| [`carrier_verify`](communication.md#carrier_verify) | 运营商三要素 | 5 MCoin/次 |
| [`number_portability`](communication.md#number_portability) | 携号转网 | 3 MCoin/次 |

### 🌐 [网络工具](network.md)
IP 地址相关

| 工具 | 描述 | 定价 |
|------|------|------|
| [`ip_location`](network.md#ip_location) | IP 归属地 | 3 MCoin/次 |

### 💰 [金融行情](finance.md)
实时行情

| 工具 | 描述 | 定价 |
|------|------|------|
| [`precious_metals`](finance.md#precious_metals) | 贵金属行情 | 5 MCoin/次 |
| [`oil_price`](finance.md#oil_price) | 全国油价 | 3 MCoin/次 |

### ✅ [验证核验](verification.md)
数据真实性核验

| 工具 | 描述 | 定价 |
|------|------|------|
| [`invoice_verify`](verification.md#invoice_verify) | 发票验真 | 10 MCoin/次 |
| [`barcode_query`](verification.md#barcode_query) | 条码查询 | 5 MCoin/次 |

### 🚄 [出行查询](travel.md)
交通票务

| 工具 | 描述 | 定价 |
|------|------|------|
| [`train_query`](travel.md#train_query) | 火车票查询 | 5 MCoin/次 |

---

## 💡 快速选择

### 我想快速体验
推荐勾选：
- ✅ `weather_query`（免费）
- ✅ `phone_attribution`（3 MCoin，查询自己的手机号）

**成本**：0 - 3 MCoin

### 我要做 Agent
推荐勾选：
- ✅ `weather_query`（免费，日常高频）
- ✅ `express_query`（3 MCoin，物流查询）
- ✅ `phone_attribution`（3 MCoin，归属地）
- ✅ `air_quality_query`（免费）

**成本**：约 6 MCoin / 20 次调用

### 我要做企业服务
推荐勾选：
- ✅ `invoice_verify`（10 MCoin）
- ✅ `carrier_verify`（5 MCoin）
- ✅ `express_query_v2`（3 MCoin）
- ✅ `phone_attribution`（3 MCoin）

**成本**：每次调用约 5-10 MCoin

---

## 🔧 如何启用

1. 登录 [MCPCat 控制台](https://mcpcat.cn/console)
2. 进入「[工具市场](https://mcpcat.cn/console/tools)」
3. 勾选想启用的工具
4. 点击「保存」
5. 立即生效，无需重启客户端

> ⚠️ 用户**未勾选**的工具，AI Agent 看不到也调不到。

---

## 📈 工具更新

工具持续扩充中，关注：

- 🔔 [GitHub Releases](https://github.com/haogegeya/mcpcat-docs/releases) — 文档更新通知
- 📝 [更新日志](../../CHANGELOG.md) — 工具变更记录
- 📮 邮件订阅 — 重要工具上线通知

### 计划中的工具

- 🗓️ **翻译** — 多语言翻译（中英日韩等）
- 🗺️ **地图查询** — POI 搜索、路径规划
- 📊 **股票行情** — A 股 / 港股 / 美股
- 💱 **汇率换算** — 实时汇率
- 🔍 **邮编查询** — 邮政编码反查
- 🆔 **身份证 OCR** — 识别身份证信息
- 💳 **银行卡验证** — 银行卡四要素验证
- 📷 **图片 OCR** — 通用文字识别
- 🎤 **语音转文字** — 音频转写
- 📧 **发短信** — 发送验证码/通知短信

---

## 📚 相关文档

- [快速开始](../getting-started/quickstart.md) — 5 分钟接入
- [API 参考](../api/README.md) — 完整 API 文档
- [计费规则](../api/billing.md) — MCoin 计费
- [客户端接入](../guides/README.md) — 配置 MCP 客户端

---

> 🐱 13 个工具只是开始，万物皆可 MCP
