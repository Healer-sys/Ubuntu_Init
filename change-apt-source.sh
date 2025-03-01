#!/bin/bash

# 获取 Ubuntu 版本号
UBUNTU_VERSION=$(lsb_release -rs)

# 清华大学 APT 源
TSINGHUA_SOURCE="http://mirrors.tuna.tsinghua.edu.cn/ubuntu"

# 备份原有 sources.list
BACKUP_FILE="/etc/apt/sources.list.bak"
if [ ! -f "$BACKUP_FILE" ]; then
    sudo cp /etc/apt/sources.list "$BACKUP_FILE"
    echo "已备份原来的 sources.list 到 $BACKUP_FILE"
fi

# 写入新的软件源
echo "正在更新 Ubuntu $UBUNTU_VERSION 的 APT 软件源..."
sudo tee /etc/apt/sources.list > /dev/null <<EOF
deb $TSINGHUA_SOURCE $(lsb_release -sc) main restricted universe multiverse
deb $TSINGHUA_SOURCE $(lsb_release -sc)-updates main restricted universe multiverse
deb $TSINGHUA_SOURCE $(lsb_release -sc)-backports main restricted universe multiverse
deb $TSINGHUA_SOURCE $(lsb_release -sc)-security main restricted universe multiverse

# 源码仓库（可选）
# deb-src $TSINGHUA_SOURCE $(lsb_release -sc) main restricted universe multiverse
# deb-src $TSINGHUA_SOURCE $(lsb_release -sc)-updates main restricted universe multiverse
# deb-src $TSINGHUA_SOURCE $(lsb_release -sc)-backports main restricted universe multiverse
# deb-src $TSINGHUA_SOURCE $(lsb_release -sc)-security main restricted universe multiverse
EOF

# 更新 APT 软件包索引
echo "更新 APT 软件包索引..."
sudo apt update

echo "APT 软件源已成功修改为清华大学源！"

