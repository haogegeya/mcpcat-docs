# 💡 使用示例

> 实战案例：MCPCat 工具的真实使用场景

## 📑 案例分类

- [日常生活](#日常生活)
- [开发辅助](#开发辅助)
- [企业业务](#企业业务)
- [自动化任务](#自动化任务)

---

## 日常生活

### 案例 1：早上出门决策

**场景**：每天早上 7 点，问 AI"今天该穿什么？"

**提示词**：

> 查一下北京今天的天气和空气质量，告诉我穿什么衣服，要不要戴口罩

**AI 自动执行**：

```json
// 1. 调用天气工具
{"method": "tools/call", "params": {"name": "weather_query", "arguments": {"cityname": "北京"}}}

// 2. 调用空气质量工具
{"method": "tools/call", "params": {"name": "air_quality_query", "arguments": {"cityname": "北京"}}}
```

**AI 回复**：

> 北京今天 18-26°C，晴，东南风 2 级，建议穿薄外套。
> 空气质量 AQI 65（良），无需戴口罩。
> 紫外线中等，可涂防晒霜。

**成本**：0 MCoin（两个免费工具）

---

### 案例 2：等快递焦虑

**场景**：查快递进度

**提示词**：

> 我有 3 个快递到了吗？
> - 顺丰 SF1234567890
> - 圆通 YT9876543210
> - 中通 ZT1111111111

**AI 自动执行**：

```json
// 依次调用快递查询
[
  {"name": "express_query", "arguments": {"no": "SF1234567890", "com": "shunfeng"}},
  {"name": "express_query", "arguments": {"no": "YT9876543210", "com": "yuantong"}},
  {"name": "express_query", "arguments": {"no": "ZT1111111111", "com": "zhongtong"}}
]
```

**AI 回复**：

> 📦 你的 3 个快递状态：
>
> 1. **顺丰 SF1234** - 已到达【北京顺义中转站】，预计今天 18:00 送达
> 2. **圆通 YT9876** - 派送中，快递员李师傅（136****8888）正在派送
> 3. **中通 ZT1111** - 已签收
>
> 1 和 2 都在路上，3 已经签收 ✅

**成本**：3 × 3 = 9 MCoin

---

## 开发辅助

### 案例 3：API 测试助手

**场景**：开发中需要测试数据，但不想 mock

**提示词**：

> 我在开发一个天气应用，帮我测试这几个场景：
> 1. 北京
> 2. 上海
> 3. 不存在的城市 "xyz123"

**AI 自动执行**：

```json
[
  {"name": "weather_query", "arguments": {"cityname": "北京"}},
  {"name": "weather_query", "arguments": {"cityname": "上海"}},
  {"name": "weather_query", "arguments": {"cityname": "xyz123"}}
]
```

**AI 回复**：

> 帮你测了 3 个场景：
>
> ✅ 北京：18-26°C 晴
> ✅ 上海：22-28°C 多云
> ❌ xyz123：城市不存在（已自动退款，未扣费）
>
> 你的应用应该对第 3 种情况做友好的错误处理。

**成本**：2 × 0 = 0 MCoin（第 3 次失败退款）

---

### 案例 4：用户注册功能开发

**场景**：让 Cursor 帮你写一个完整的手机号归属地查询功能

**提示词（Cursor Composer）**：

> 用 Python Flask 写一个 API：用户输入手机号，返回归属地。
> 用 MCPCat 的 phone_attribution 工具实现。
> 要求：
> 1. 输入校验（11 位数字）
> 2. 调用 MCPCat（API Key 从环境变量读）
> 3. 错误处理
> 4. 加一个简单的 HTML 表单

**Cursor 自动完成**：

1. 创建项目结构
2. 编写 `app.py`（Flask 后端）
3. 编写 `templates/index.html`（表单）
4. 调用 `phone_attribution` 测试
5. 添加文档

**完整代码示例**（Cursor 输出）：

```python
# app.py
import os
import httpx
from flask import Flask, request, jsonify, render_template

app = Flask(__name__)

MCPCAT_API_KEY = os.getenv("MCPCAT_API_KEY")
MCPCAT_ENDPOINT = "https://mcp.mcpcat.cn/v1/mcp"

def query_phone_attribution(phone: str) -> str:
    """调用 MCPCat 查询手机归属地"""
    response = httpx.post(
        MCPCAT_ENDPOINT,
        headers={"Authorization": f"Bearer {MCPCAT_API_KEY}"},
        json={
            "jsonrpc": "2.0",
            "id": 1,
            "method": "tools/call",
            "params": {
                "name": "phone_attribution",
                "arguments": {"phone": phone}
            }
        },
        timeout=30
    )
    data = response.json()
    if "error" in data:
        raise Exception(data["error"]["message"])
    result = data["result"]
    if result.get("isError"):
        raise Exception(result["content"][0]["text"])
    return result["content"][0]["text"]

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/api/phone", methods=["POST"])
def api_phone():
    phone = request.json.get("phone", "").strip()
    
    # 校验
    if not phone or len(phone) != 11 or not phone.isdigit():
        return jsonify({"error": "请输入 11 位手机号"}), 400
    
    try:
        attribution = query_phone_attribution(phone)
        return jsonify({"success": True, "data": attribution})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True)
```

```html
<!-- templates/index.html -->
<!DOCTYPE html>
<html>
<head>
    <title>手机归属地查询</title>
    <style>
        body { font-family: sans-serif; max-width: 600px; margin: 50px auto; padding: 20px; }
        input { padding: 10px; width: 60%; font-size: 16px; }
        button { padding: 10px 20px; font-size: 16px; cursor: pointer; }
        #result { margin-top: 20px; padding: 15px; background: #f5f5f5; border-radius: 5px; white-space: pre-wrap; }
    </style>
</head>
<body>
    <h1>📱 手机归属地查询</h1>
    <p>Powered by MCPCat</p>
    <input id="phone" placeholder="输入 11 位手机号" maxlength="11" />
    <button onclick="query()">查询</button>
    <div id="result"></div>
    <script>
        async function query() {
            const phone = document.getElementById('phone').value;
            const resultDiv = document.getElementById('result');
            resultDiv.textContent = '查询中...';
            
            try {
                const res = await fetch('/api/phone', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({phone})
                });
                const data = await res.json();
                if (data.success) {
                    resultDiv.textContent = data.data;
                } else {
                    resultDiv.textContent = '❌ ' + data.error;
                }
            } catch (e) {
                resultDiv.textContent = '❌ 网络错误';
            }
        }
    </script>
</body>
</html>
```

**成本**：开发期调用约 10 次 = 30 MCoin

---

## 企业业务

### 案例 5：CRM 客户画像增强

**场景**：批量分析客户的手机号归属地分布

**提示词**：

> 我有一个 Excel 文件 customers.xlsx，有 5000 个客户的手机号。
> 帮我分析运营商分布和地域分布 TOP 10

**AI 自动执行**：

1. 读取 Excel
2. 批量调用 `phone_attribution`（5000 次）
3. 统计分布
4. 生成报告

**AI 回复**：

> 客户归属地分析报告（基于 5000 个样本）：
>
> 📡 运营商分布：
> - 中国移动：2300 (46%)
> - 中国联通：1500 (30%)
> - 中国电信：1100 (22%)
> - 虚拟运营商：100 (2%)
>
> 🌍 地域 TOP 10：
> 1. 北京 850 (17%)
> 2. 上海 600 (12%)
> 3. 广州 500 (10%)
> 4. 深圳 450 (9%)
> 5. 杭州 350 (7%)
> ...
>
> 详细数据已导出到 report.csv

**成本**：5000 × 3 = 15,000 MCoin = ¥150

> 💡 如需处理大量数据，建议先充 ¥500 包（送 10%）

---

### 案例 6：财务发票核验工作流

**场景**：每月报销季，批量核验员工提交的发票

**提示词**：

> 我有一批发票信息需要核验（每条格式：发票号、代码、金额、日期），
> 帮我逐个验证，输出哪些是真实的、哪些是异常的

**AI 自动执行**：

```json
[
  {"name": "invoice_verify", "arguments": {"invoice_no": "12345678", "invoice_code": "011002100311", "amount": "100.00", "invoice_date": "2026-08-14"}},
  // ... 100 条
]
```

**AI 回复**：

> 100 张发票核验结果：
>
> ✅ 真实有效：92 张
> ❌ 异常：8 张
>   - 5 张：金额不匹配
>   - 2 张：发票不存在
>   - 1 张：已重复报销
>
> ⚠️ 异常发票明细已导出到 abnormal_invoices.csv
> 建议财务重点核查

**成本**：100 × 10 = 1,000 MCoin = ¥10

---

## 自动化任务

### 案例 7：每日天气推送

**场景**：每天早上 7 点，自动查天气并发送邮件给自己

**实现**（配合 cron / OpenClaw 定时任务）：

```python
# daily_weather.py
import httpx
import smtplib
from email.mime.text import MIMEText
from datetime import datetime

def get_weather(city: str) -> str:
    response = httpx.post(
        "https://mcp.mcpcat.cn/v1/mcp",
        headers={"Authorization": f"Bearer {os.getenv('MCPCAT_API_KEY')}"},
        json={
            "jsonrpc": "2.0",
            "id": 1,
            "method": "tools/call",
            "params": {
                "name": "weather_query",
                "arguments": {"cityname": city}
            }
        },
        timeout=30
    )
    return response.json()["result"]["content"][0]["text"]

def send_email(to: str, subject: str, body: str):
    msg = MIMEText(body, "plain", "utf-8")
    msg["Subject"] = subject
    msg["From"] = "weather@example.com"
    msg["To"] = to
    
    with smtplib.SMTP("smtp.example.com", 587) as server:
        server.starttls()
        server.login("weather@example.com", "password")
        server.send_message(msg)

if __name__ == "__main__":
    weather = get_weather("北京")
    today = datetime.now().strftime("%Y-%m-%d")
    send_email(
        "you@example.com",
        f"🌤️ {today} 北京天气",
        weather
    )
    print(f"已发送 {today} 天气邮件")
```

**crontab 配置**：

```bash
# 每天早上 7 点执行
0 7 * * * /usr/bin/python3 /path/to/daily_weather.py
```

**成本**：1 × 0 = 0 MCoin/天（天气免费）

---

### 案例 8：批量贵金属价格监控

**场景**：每 10 分钟查一次贵金属价格，跌 5% 时报警

**Python 脚本**：

```python
import httpx
import time
import os

API_KEY = os.getenv("MCPCAT_API_KEY")
ALERT_THRESHOLD = -0.05  # 跌 5% 报警

def get_metals():
    response = httpx.post(
        "https://mcp.mcpcat.cn/v1/mcp",
        headers={"Authorization": f"Bearer {API_KEY}"},
        json={
            "jsonrpc": "2.0",
            "id": 1,
            "method": "tools/call",
            "params": {"name": "precious_metals", "arguments": {}}
        },
        timeout=30
    )
    return response.json()["result"]["content"][0]["text"]

# 实际实现需要解析文本中的涨跌百分比
# 这里简化为示例
prev_change = 0
while True:
    metals = get_metals()
    # 解析 metals 文本，提取涨跌
    # ... (略)
    
    # 触发报警逻辑
    # if change < ALERT_THRESHOLD:
    #     send_alert(...)
    
    time.sleep(600)  # 10 分钟
```

**成本**：144 × 5 = 720 MCoin/天 = ¥7.2/天

---

## 🎯 组合调用

### 案例 9：智能出行助手

**场景**：完整出行决策支持

**提示词**：

> 我明天从北京去上海出差，帮我做完整的出行准备：
> 1. 北京和上海的天气
> 2. 北京机场到火车站的交通
> 3. 上海当天的空气质量
> 4. 推荐穿衣

**AI 自动执行**：

```json
[
  {"name": "weather_query", "arguments": {"cityname": "北京"}},
  {"name": "weather_query", "arguments": {"cityname": "上海"}},
  {"name": "air_quality_query", "arguments": {"cityname": "上海"}}
]
```

**AI 回复**：

> 出行准备清单：
>
> 🌤️ **北京**（出发地）
> - 温度：18-26°C，晴
> - 建议：穿薄外套
>
> 🌤️ **上海**（目的地）
> - 温度：22-28°C，多云转阵雨
> - 建议：带伞，穿短袖 + 薄外套
> - 空气质量 AQI 75（良）
>
> 📋 **准备清单**：
> - [ ] 薄外套（两地通用）
> - [ ] 雨伞（上海可能下雨）
> - [ ] 身份证（火车票）
> - [ ] 充电宝
> - [ ] 口罩（备用）

**成本**：2 × 0 + 1 × 0 = 0 MCoin（全部免费工具）

---

### 案例 10：企业级批量分析

**场景**：分析 100 个商家的 IP 归属地 + 运营商分布

**提示词**：

> 我有 100 个商家的注册 IP 和联系电话，
> 帮我分析：
> 1. 这些商家的地域分布
> 2. 联系人的运营商分布
> 3. 异地注册的有几家（IP 归属地与电话归属地不一致）

**AI 自动执行**：

```json
// 200 次调用（100 IP + 100 手机）
[
  // 100 个 ip_location
  {"name": "ip_location", "arguments": {"ip": "1.2.3.4"}},
  // ...
  // 100 个 phone_attribution
  {"name": "phone_attribution", "arguments": {"phone": "13800138000"}},
  // ...
]
```

**AI 回复**：

> 商户批量分析报告：
>
> 🌍 **地域分布**（基于 IP）：
> - 北京：30%
> - 上海：20%
> - 广东：25%
> - 其他：25%
>
> 📡 **运营商分布**（基于手机号）：
> - 移动：45%
> - 联通：30%
> - 电信：25%
>
> ⚠️ **异地注册**：8 家
>   建议人工核查

**成本**：100 × 3 + 100 × 3 = 600 MCoin = ¥6

---

## 💡 最佳实践

### 1. 组合调用

- 免费 + 付费工具组合，控制成本
- 一次提示完成多步任务

### 2. 失败处理

- 上游异常自动退款，放心调用
- 客户端做好错误捕获

### 3. 缓存策略

- 变动不大的数据本地缓存
- 减少 API 调用 = 省钱

### 4. 批量任务

- 大量数据用脚本批处理
- 比让 AI 一次一次问便宜

### 5. 监控用量

- 定期看账单
- 设置用量告警

---

## 📚 相关文档

- [工具列表](tools/README.md) — 全部可用工具
- [API 参考](api/README.md) — 完整 API 文档
- [定价说明](pricing.md) — 价格表
- [客户端接入](guides/README.md) — 配置 MCP 客户端

---

> 💡 MCPCat 的威力，来自于把这些工具组合起来用
