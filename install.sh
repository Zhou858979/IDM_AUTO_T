#!/bin/bash
# install.sh - 一键部署 IDM_AUTO_T 插件
# 自动检测 Klipper 路径，复制文件到 extras 根目录，重启服务

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
EXTRAS_DIR="$HOME/klipper/klippy/extras"
KENV="$HOME/klippy-env"
LOG_FILE="$HOME/printer_data/logs/klippy.log"

echo "=== IDM_AUTO_T Deploy ==="

# 1. 自动检测 Klipper 路径
if [ ! -d "$EXTRAS_DIR" ]; then
    echo "ERROR: Klipper extras not found at $EXTRAS_DIR"
    echo "Please install Klipper first."
    exit 1
fi

# 2. 检查 klippy-env
if [ ! -d "$KENV" ]; then
    echo "ERROR: klippy-env not found at $KENV"
    echo "Please install Klipper environment first."
    exit 1
fi

# 3. 安装 Python 依赖
echo "[1/3] Installing Python dependencies..."
"$KENV/bin/pip" install -r "$REPO_DIR/requirements.txt"

# 4. 复制 .so + 壳文件到 extras 根目录
echo "[2/3] Copying to $EXTRAS_DIR ..."

# 复制 .so 文件
cp "$REPO_DIR"/scanner*.so "$EXTRAS_DIR/" 2>/dev/null || true
cp "$REPO_DIR"/arg_fit*.so "$EXTRAS_DIR/" 2>/dev/null || true

# 复制壳文件
cp "$REPO_DIR"/scanner.py "$EXTRAS_DIR/"
cp "$REPO_DIR"/arg_fit.py "$EXTRAS_DIR/"

# 5. 清理缓存
echo "[3/3] Cleaning cache..."
rm -rf "$EXTRAS_DIR"/__pycache__/

# 6. 重启 Klipper
echo "Restarting Klipper..."
sudo systemctl restart klipper

# 7. 验证
sleep 3
if [ -f "$EXTRAS_DIR/scanner.cpython-310-aarch64-linux-gnu.so" ]; then
    echo ""
    echo "✅ Deploy successful!"
else
    echo ""
    echo "⚠️  Check logs: tail -n 20 $LOG_FILE"
fi

echo ""
echo "=== Done ==="
echo "Files in extras:"
ls -la "$EXTRAS_DIR"/scanner*.so "$EXTRAS_DIR"/arg_fit*.so "$EXTRAS_DIR"/scanner.py "$EXTRAS_DIR"/arg_fit.py 2>/dev/null || true