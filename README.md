# libc-test for xkernel (aarch64)

## 配置

### 1. 复制配置模板
```bash
cp config.mak.def config.mak
```

### 2. 编辑 config.mak
根据您的工具链修改 `CROSS_COMPILE` 变量：

```makefile
# 如果使用 musl 工具链（在 PATH 中）
CROSS_COMPILE = aarch64-linux-musl-


# 如果工具链不在 PATH 中，使用完整路径
CROSS_COMPILE = /path/to/aarch64-linux-musl-cross/bin/aarch64-linux-musl-
```

## 编译

```bash
make clean
make -j$(nproc)
```


## 部署到 xkernel

### 自动部署（推荐）
```bash
# 确保 xkernel 的 disk.img 路径正确
# 默认路径：/home/yean/x-kernel/disk.img
# 如需修改，编辑 deploy.sh 中的 DISK_IMG 变量

./deploy.sh
```

### 手动部署
```bash
# 挂载 disk.img
sudo mkdir -p /tmp/xkernel-mount
sudo mount -o loop /path/to/xkernel/disk.img /tmp/xkernel-mount

# 创建目录
sudo mkdir -p /tmp/xkernel-mount/libc-test/src/{functional,math,regression,common}

# 复制测试文件
sudo cp src/functional/*.exe /tmp/xkernel-mount/libc-test/src/functional/
sudo cp src/math/*.exe /tmp/xkernel-mount/libc-test/src/math/
sudo cp src/regression/*.exe /tmp/xkernel-mount/libc-test/src/regression/
sudo cp src/common/runtest.exe /tmp/xkernel-mount/libc-test/src/common/
sudo cp run.sh /tmp/xkernel-mount/libc-test/run

# 设置权限
sudo chmod -R 755 /tmp/xkernel-mount/libc-test/

# 同步并卸载
sync && sudo sync
sudo umount /tmp/xkernel-mount
```

## 在 xkernel 中运行测试

### 启动 xkernel
```bash
cd /path/to/xkernel
make run
```

### 运行测试

**方法 1：单个测试**
```bash
cd /libc-test/src/functional
./string-static.exe && echo PASS || echo FAIL
./snprintf-static.exe && echo PASS || echo FAIL
```


**方法 2：使用 run 脚本**
```bash
cd /libc-test
./run src/functional/string-static.exe
```

## 测试分类

- **src/functional/** - 功能测试（70+ 个，字符串、I/O、线程等）
- **src/math/** - 数学函数测试（150+ 个，三角、指数、对数等）
- **src/regression/** - 回归测试（100+ 个，已知 bug 验证）

