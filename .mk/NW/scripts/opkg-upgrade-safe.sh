#!/bin/sh
# 安全升级 OpenWrt 已安装的软件包(跳过核心组件)

# 不建议升级的关键包
SKIP_PACKAGES="base-files busybox dnsmasq dropbear firewall fstools kernel libc libgcc libpthread librt mtd netifd opkg procd uci uclient-fetch urandom-seed urngd"

echo "[INFO] 更新软件源..."
opkg update

echo "[INFO] 获取可升级列表..."
UPGRADABLE=$(opkg list-upgradable | cut -f 1 -d ' ')

if [ -z "$UPGRADABLE" ]; then
    echo "[INFO] 没有可升级的软件包. "
    exit 0
fi

for pkg in $UPGRADABLE; do
    skip=false
    for s in $SKIP_PACKAGES; do
        if [ "$pkg" = "$s" ]; then
            echo "[SKIP] 跳过核心包: $pkg"
            skip=true
            break
        fi
    done
    if [ "$skip" = false ]; then
        echo "[UPGRADE] 正在升级: $pkg"
        opkg upgrade "$pkg"
    fi
done

echo "[INFO] 软件包升级完成. "
