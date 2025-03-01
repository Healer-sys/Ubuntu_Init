#!/bin/bash

echo "=============================="
echo "  Ubuntu Linux 开发环境安装"
echo "=============================="

# 选择安装的工具
echo "请选择要安装的组件（输入编号，用空格分隔，如：1 2 3）："
echo "1) 基础开发工具（GCC, Make, CMake, Git, Vim）"
echo "2) 交叉编译工具链（ARM GCC）"
echo "3) 嵌入式开发工具（U-Boot, DTC, Libncurses）"
echo "4) 调试工具（GDB, Strace, Ltrace, Valgrind）"
echo "5) SSH 免密登录配置"
echo "6) 全部安装"
read -p "请输入选项: " choices

# 检测是否输入了 "6"（全选）
if [[ $choices =~ (^|[[:space:]])6($|[[:space:]]) ]]; then
    choices="1 2 3 4 5"
fi

# 更新系统
echo "更新系统..."
sudo apt update && sudo apt upgrade -y

# 1️⃣ 安装基础开发工具
if [[ $choices =~ (^|[[:space:]])1($|[[:space:]]) ]]; then
    echo "安装基础开发工具..."
    sudo apt install -y build-essential gcc g++ make cmake git vim \
                        python3 python3-pip python3-venv \
                        pkg-config automake autoconf tree screen \
						htop net-tools
    echo "✅ 基础开发工具安装完成！"
fi

# 2️⃣ 安装交叉编译工具链
if [[ $choices =~ (^|[[:space:]])2($|[[:space:]]) ]]; then
    CROSS_COMPILE_DIR="/opt/toolchains"
    mkdir -p $CROSS_COMPILE_DIR
    if [ ! -d "$CROSS_COMPILE_DIR/gcc-arm-none-eabi" ]; then
        echo "安装 ARM 交叉编译工具链..."
        cd /tmp
        wget -q https://developer.arm.com/-/media/Files/downloads/gnu-rm/10-2020q4/gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2
        tar -xjf gcc-arm-none-eabi-10-2020-q4-major-x86_64-linux.tar.bz2 -C $CROSS_COMPILE_DIR
        echo "✅ ARM 交叉编译工具链安装完成！"
    fi

    echo "配置交叉编译环境变量..."
    echo "export PATH=$CROSS_COMPILE_DIR/gcc-arm-none-eabi/bin:\$PATH" >> ~/.bashrc
    echo "export CROSS_COMPILE=arm-none-eabi-" >> ~/.bashrc
    echo "export ARCH=arm" >> ~/.bashrc
    echo "export CROSS_COMPILE_DIR=$CROSS_COMPILE_DIR" >> ~/.bashrc
fi

# 3️⃣ 安装嵌入式开发工具
if [[ $choices =~ (^|[[:space:]])3($|[[:space:]]) ]]; then
    echo "安装嵌入式开发工具..."
    sudo apt install -y libncurses-dev u-boot-tools device-tree-compiler flex bison libssl-dev libwebsockets-dev libjson-c-dev libcurl4-openssl-dev
    echo "✅ 嵌入式开发工具安装完成！"
fi

# 4️⃣ 安装调试工具
if [[ $choices =~ (^|[[:space:]])4($|[[:space:]]) ]]; then
    echo "安装调试工具..."
    sudo apt install -y gdb strace ltrace valgrind
    echo "✅ 调试工具安装完成！"
fi

# 5️⃣ 配置 SSH 免密登录
if [[ $choices =~ (^|[[:space:]])5($|[[:space:]]) ]]; then
    if [ ! -f ~/.ssh/id_rsa ]; then
        echo "生成 SSH 密钥..."
        ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
        echo "✅ SSH 密钥已生成！请将以下公钥添加到目标设备的 ~/.ssh/authorized_keys："
        cat ~/.ssh/id_rsa.pub
    else
        echo "✅ 你已经有 SSH 密钥，无需重新生成！"
    fi
fi

# 重新加载 .bashrc 使环境变量生效
source ~/.bashrc

echo "=============================="
echo "✅ Linux 开发环境配置完成！"
echo "如果安装了交叉编译工具链，请重新登录终端以使环境变量生效。"
echo "=============================="
