# aes

请使用install.sh进行使用

环境安装
entOS / RHEL / Rocky Linux
yum install -y sysstat pciutils curl
Ubuntu / Debian
apt update && apt install -y sysstat pciutils curl
依赖说明：
- sysstat：提供 iostat 磁盘IO检测工具
- pciutils：提供 lspci 硬件信息读取工具
- curl：用于获取服务器公网IP
