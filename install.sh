#!/bin/bash
# 系统信息检测脚本 - 输出完整系统软硬件状态
clear

# 定义颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # 关闭颜色

echo -e "${BLUE}=============================================${NC}"
echo -e "${GREEN}          Linux 系统详细信息检测报告         ${NC}"
echo -e "${BLUE}=============================================${NC}"

# 1. 系统版本与主机信息
echo -e "\n${YELLOW}[1] 系统基础信息${NC}"
echo "主机名:        $(hostname)"
echo "操作系统:      $(cat /etc/os-release | grep PRETTY_NAME | cut -d\" -f2)"
echo "内核版本:      $(uname -r)"
echo "系统架构:      $(uname -m)"
echo "运行时长:      $(uptime | awk '{print $3,$4}' | sed 's/,//')"
echo "当前用户:      $(whoami)"

# 2. CPU 信息
echo -e "\n${YELLOW}[2] CPU 处理器信息${NC}"
echo "CPU 型号:      $(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2 | sed -e 's/^ *//')"
echo "CPU 核心数:    $(grep -c '^processor' /proc/cpuinfo)"
echo "CPU 线程数:    $(grep 'siblings' /proc/cpuinfo | head -n1 | cut -d: -f2 | sed -e 's/^ *//')"
echo "CPU 负载(1/5/15分钟): $(uptime | awk '{print $8,$9,$10}' | sed 's/,//g')"

# 3. 内存与交换分区
echo -e "\n${YELLOW}[3] 内存 & 交换分区${NC}"
free -h | awk 'NR==1{print $0} NR==2{print $0} NR==3{print $0}'

# 4. 磁盘分区与使用率
echo -e "\n${YELLOW}[4] 磁盘分区 & 挂载信息${NC}"
df -hT | grep -v tmpfs | grep -v loop

# 5. 磁盘IO统计
echo -e "\n${YELLOW}[5] 磁盘IO状态${NC}"
iostat -d 1 1 | grep -v Device

# 6. 网络信息
echo -e "\n${YELLOW}[6] 网络信息${NC}"
echo "本机公网IP:    $(curl -s ifconfig.me 2>/dev/null || echo '获取失败')"
echo "网卡内网地址:"
ip -4 addr | grep inet | grep -v 127.0.0.1 | awk '{print $2}' | cut -d/ -f1
echo "网关地址:      $(ip route | grep default | awk '{print $3}')"

# 7. 监听端口
echo -e "\n${YELLOW}[7] 正在监听的端口${NC}"
ss -tulnp 2>/dev/null | grep -v State

# 8. 进程 TOP5（CPU占用）
echo -e "\n${YELLOW}[8] CPU 占用 TOP5 进程${NC}"
ps -aux --sort=-%cpu | head -n 6

# 9. 进程 TOP5（内存占用）
echo -e "\n${YELLOW}[9] 内存占用 TOP5 进程${NC}"
ps -aux --sort=-%mem | head -n 6

# 10. 硬件信息（主板/显卡）
echo -e "\n${YELLOW}[10] 硬件简要信息${NC}"
if command -v lspci &> /dev/null; then
    echo "显卡信息: $(lspci | grep -i vga | cut -d: -f3 | sed -e 's/^ *//')"
else
    echo "未检测到 lspci 工具，无法读取显卡信息"
fi

# 11. 环境变量 & Shell
echo -e "\n${YELLOW}[11] 运行环境${NC}"
echo "默认 Shell:    $SHELL"
echo "PATH 路径:     $PATH"

echo -e "\n${BLUE}=============================================${NC}"
echo -e "${GREEN}          系统信息检测完成                   ${NC}"
echo -e "${BLUE}=============================================${NC}"