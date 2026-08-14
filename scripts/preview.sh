#!/bin/bash
# 本地预览文档
set -e

echo "🚀 启动 MCPCat 文档本地预览..."

# 检查 Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 未安装"
    exit 1
fi

# 创建虚拟环境（如果不存在）
if [ ! -d ".venv" ]; then
    echo "📦 创建虚拟环境..."
    python3 -m venv .venv
fi

# 激活虚拟环境
source .venv/bin/activate

# 安装依赖
echo "📥 安装依赖..."
pip install -q mkdocs mkdocs-material pymdown-extensions

# 启动预览
echo "✅ 启动预览服务..."
echo "🌐 浏览器打开: http://localhost:8000"
echo "⏹️  按 Ctrl+C 停止"
mkdocs serve
