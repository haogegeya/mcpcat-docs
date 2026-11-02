#!/bin/bash
# 构建静态站点
#
# 依赖一律来自仓库根的 requirements.txt（与 CI / Deploy Docs 同一份清单）。
# 2026-08-14 部署失败就是因为在别处 pip install 时漏了 mkdocs-minify-plugin，
# 这里别再手写包名清单。
#
# 环境选择：按本机约定优先用 conda 环境 mcpcat-docs（不用 venv）。
set -e

cd "$(dirname "$0")/.."

CONDA_BIN="${CONDA_BIN:-$HOME/miniconda3/bin/conda}"
ENV_NAME="${MCPCAT_DOCS_ENV:-mcpcat-docs}"

if [ -x "$CONDA_BIN" ] && "$CONDA_BIN" env list | grep -qE "^$ENV_NAME([[:space:]]|$)"; then
    PY="$("$CONDA_BIN" run -n "$ENV_NAME" which python)"
    echo "🐍 使用 conda 环境: $ENV_NAME"
else
    PY="${PYTHON:-python3}"
    echo "🐍 未找到 conda 环境 $ENV_NAME，回退到 $PY（首次需先装依赖，见下面提示）"
fi

if ! "$PY" -c "import mkdocs" 2>/dev/null; then
    echo "❌ 当前 Python 没装 mkdocs。先建环境并装依赖："
    echo "   conda create -y -n $ENV_NAME python=3.11"
    echo "   conda run -n $ENV_NAME pip install -r requirements.txt"
    exit 1
fi

echo "🔨 构建（--strict：警告即失败，别指望 CI 兜底）..."
"$PY" -m mkdocs build --strict

echo "✅ 构建完成！输出目录: site/"
echo ""
echo "🚀 部署选项："
echo "  - GitHub Pages: git push origin main（Deploy Docs workflow 自动构建并发布）"
echo "  - 本地查看: $PY -m http.server -d site/ 8000"
