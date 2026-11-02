#!/bin/bash
# 本地预览文档
#
# 与 build.sh 用同一个 conda 环境和同一份 requirements.txt，
# 保证「本地看到的」和「CI 构建出来的」是同一套依赖。
set -e

cd "$(dirname "$0")/.."

CONDA_BIN="${CONDA_BIN:-$HOME/miniconda3/bin/conda}"
ENV_NAME="${MCPCAT_DOCS_ENV:-mcpcat-docs}"

if [ -x "$CONDA_BIN" ] && "$CONDA_BIN" env list | grep -qE "^$ENV_NAME([[:space:]]|$)"; then
    PY="$("$CONDA_BIN" run -n "$ENV_NAME" which python)"
    echo "🐍 使用 conda 环境: $ENV_NAME"
else
    PY="${PYTHON:-python3}"
    echo "🐍 未找到 conda 环境 $ENV_NAME，回退到 $PY"
fi

if ! "$PY" -c "import mkdocs" 2>/dev/null; then
    echo "❌ 当前 Python 没装 mkdocs。先建环境并装依赖："
    echo "   conda create -y -n $ENV_NAME python=3.11"
    echo "   conda run -n $ENV_NAME pip install -r requirements.txt"
    exit 1
fi

echo "✅ 启动预览服务..."
echo "🌐 浏览器打开: http://localhost:8000"
echo "⏹️  按 Ctrl+C 停止"
"$PY" -m mkdocs serve
