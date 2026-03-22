#!/bin/bash
# 一键部署 libc-test 到 xkernel disk.img

set -e

DISK_IMG="/home/yean/x-kernel/disk.img"
MOUNT_POINT="/tmp/xkernel-mount"

echo "=== 部署 libc-test 到 xkernel ==="

# 挂载
sudo mkdir -p "$MOUNT_POINT"
sudo mount -o loop "$DISK_IMG" "$MOUNT_POINT"

# 创建目录结构
sudo mkdir -p "$MOUNT_POINT/libc-test/src"/{functional,math,regression,common,musl}

# 复制测试文件
echo "复制测试文件..."
sudo cp src/functional/*.exe "$MOUNT_POINT/libc-test/src/functional/" 2>/dev/null || true
sudo cp src/functional/*.so "$MOUNT_POINT/libc-test/src/functional/" 2>/dev/null || true
sudo cp src/math/*.exe "$MOUNT_POINT/libc-test/src/math/" 2>/dev/null || true
sudo cp src/regression/*.exe "$MOUNT_POINT/libc-test/src/regression/" 2>/dev/null || true
sudo cp src/regression/*.so "$MOUNT_POINT/libc-test/src/regression/" 2>/dev/null || true
sudo cp src/musl/*.exe "$MOUNT_POINT/libc-test/src/musl/" 2>/dev/null || true
sudo cp src/common/runtest.exe "$MOUNT_POINT/libc-test/src/common/"

# 复制 run 脚本
sudo cp run.sh "$MOUNT_POINT/libc-test/run"

# 设置权限
sudo chmod -R 755 "$MOUNT_POINT/libc-test/"

# 统计
echo "已部署:"
echo "  functional: $(ls "$MOUNT_POINT/libc-test/src/functional/"*.exe 2>/dev/null | wc -l) 个"
echo "  math: $(ls "$MOUNT_POINT/libc-test/src/math/"*.exe 2>/dev/null | wc -l) 个"
echo "  regression: $(ls "$MOUNT_POINT/libc-test/src/regression/"*.exe 2>/dev/null | wc -l) 个"
echo "  musl: $(ls "$MOUNT_POINT/libc-test/src/musl/"*.exe 2>/dev/null | wc -l) 个"
# 同步并卸载
sync
sudo sync
sleep 4
sudo umount "$MOUNT_POINT"

echo "✓ 部署完成！"
echo ""
echo "使用方法:"
echo "  cd /home/yean/x-kernel && make run"
echo "  进入虚拟机后："
echo "    cd /libc-test"
echo "    ./run src/functional static"
