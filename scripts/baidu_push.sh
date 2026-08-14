#!/bin/bash
# 百度主动推送脚本
# 用法: bash baidu_push.sh
# 配置: 在 .env 里填你的百度站长 token
# 行为: 每天 cron 跑 1 次，把站点所有重要 URL 推给百度

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="${SCRIPT_DIR}/.env.baidu"

# ===== 加载 token =====
if [ -f "$ENV_FILE" ]; then
  source "$ENV_FILE"
fi

if [ -z "$BAIDU_PUSH_TOKEN" ]; then
  echo "❌ 未配置 BAIDU_PUSH_TOKEN"
  echo "   1. 去 https://ziyuan.baidu.com 登录"
  echo "   2. 站点管理 → 选中 www.mcpcat.cn → 普通收录 → 推送接口"
  echo "   3. 复制 token 写到 .env.baidu: BAIDU_PUSH_TOKEN=你的token"
  exit 1
fi

# ===== 配置 =====
SITE="https://www.mcpcat.cn"
API="https://data.zz.baidu.com/urls?site=${SITE}&token=${BAIDU_PUSH_TOKEN}"

# ===== 重要 URL 列表（按优先级）=====
# - 主要营销页（首页、注册、登录）
# - 控制台主要功能页（不需要登录就能看的部分）
# - 法律页
# 注意：console/* 内部页需要登录，推了也爬不到，浪费配额
URLS=$(cat <<'EOF'
https://www.mcpcat.cn/
https://www.mcpcat.cn/register
https://www.mcpcat.cn/login
https://www.mcpcat.cn/terms
https://www.mcpcat.cn/docs
EOF
)

# ===== 推送 =====
echo "=== 百度主动推送 ==="
echo "时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "站点: $SITE"
echo "URL 数: $(echo "$URLS" | wc -l)"
echo ""

RESP=$(curl -sS -X POST "$API" \
  -H "Content-Type: text/plain" \
  --data-binary "$URLS" \
  --max-time 15 2>&1)

echo "百度响应:"
echo "$RESP" | head -3
echo ""

# ===== 解析响应 =====
# 成功响应: {"remain":2999,"success":5}
# 错误响应: {"error":401,"message":"token is wrong"}
if echo "$RESP" | grep -q '"success"'; then
  SUCCESS=$(echo "$RESP" | grep -oE '"success":[0-9]+' | cut -d: -f2)
  REMAIN=$(echo "$RESP" | grep -oE '"remain":[0-9]+' | cut -d: -f2)
  echo "✅ 推送成功: ${SUCCESS} 条, 剩余配额: ${REMAIN}"
  # 写日志
  echo "$(date '+%Y-%m-%d %H:%M:%S') success=${SUCCESS} remain=${REMAIN}" >> "${SCRIPT_DIR}/push.log"
  exit 0
else
  echo "❌ 推送失败"
  echo "$RESP"
  echo "$(date '+%Y-%m-%d %H:%M:%S') FAIL: $RESP" >> "${SCRIPT_DIR}/push.log"
  exit 1
fi
