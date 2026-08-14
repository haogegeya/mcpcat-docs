#!/bin/bash
# 构建静态站点
set -e

echo "📦 构建 MCPCat 文档站点..."

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

# 构建
echo "🔨 构建..."
mkdocs build

echo "✅ 构建完成！"
echo "📁 输出目录: site/"
echo ""
echo "🚀 部署选项："
echo "  - GitHub Pages: git push origin main"
echo "  - Vercel: vercel --prod"
echo "  - Netlify: 拖拽 site/ 目录"
echo "  - 本地查看: python3 -m http.server -d site/"
