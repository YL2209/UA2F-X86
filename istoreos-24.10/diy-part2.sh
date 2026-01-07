#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# 修改 alpha 为默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-alpha/g' ./feeds/luci/collections/luci-light/Makefile
# sed -i 's/.nowrap:not(.td){white-space:nowrap}/.nowrap:not(.td){white-space:unset}/g' package/feeds/luci/luci-theme-argon/htdocs/luci-static/argon/css/cascade.css
# rm -rf package/feeds/luci/luci-theme-argon
git clone https://github.com/YL2209/luci-theme-alpha.git package/luci-theme-alpha
git clone https://github.com/YL2209/luci-app-alpha-config.git package/luci-app-alpha-config

rm -rf package/feeds/luci/luci-app-ua2f
# rm -rf package/feeds/luci/luci-app-appfilter
# rm -rf package/feeds/packages/open-app-filter
# git clone https://github.com/destan19/OpenAppFilter.git package/luci-app-appfilter
git clone https://github.com/YL2209/luci-app-ua2f.git package/luci-app-ua2f
git clone https://github.com/YL2209/luci-app-campus-network-login.git package/luci-app-campus-network-login

# 修改 UA2F 的版本
sed -i 's/^PKG_VERSION:=.*/PKG_VERSION:=4.9.2/' package/feeds/packages/ua2f/Makefile
sed -i 's/^PKG_HASH:=.*/PKG_HASH:=02a20e8fc5d7c3c6999ad6143c2d4496b40b5b85286211f2e2b975e9485b25f0/' package/feeds/packages/ua2f/Makefile

# 增加 UA2F 需要的从 CONFIG_NETFILTER_NETLINK_GLUE_CT=y
awk '/# Netfilter Extensions/{print; getline; if ($0 ~ /^\*/) {print; print "CONFIG_NETFILTER_NETLINK_GLUE_CT=y"} else {print $0; print "CONFIG_NETFILTER_NETLINK_GLUE_CT=y"}; next} 1' .config > .config.tmp && mv .config.tmp .config

git clone https://github.com/YL2209/luci-app-campus-network-mac.git package/luci-app-campus-network-mac
chmod 755 package/luci-app-campus-network-mac/luci-app-wan-mac/root/etc/init.d/wan_mac

#更改主机型号，支持中文。 
sed -i 's/model = "Xiaomi Mi Router CR6608"/model = "小米 CR6608 校园网专用"/g' target/linux/ramips/dts/mt7621_xiaomi_mi-router-cr6608.dts

# 修改主机名字（不能纯数字或者使用中文）
sed -i 's/ImmortalWrt/NAOKUO/g' package/base-files/files/bin/config_generate

# 修改默认 wifi 名称 ssid 为 NAOKUO
# sed -i 's/ssid=ImmortalWrt/ssid=NAOKUO/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# sed -i 's/ImmortalWrt/NaoKuo_cr6608/g' package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc
# 修改默认 wifi 加密模式
# sed -i 's/encryption=none/encryption=psk2/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# sed -i 's/encryption || "none"/encryption || "psk2"/g' package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc
# 修改默认 wifi 密码 key 为 12345678
# sed -i '/set wireless.default_${name}.encryption=psk2/a\			set wireless.default_${name}.key=12345678' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# sed -i 's/key || ""/key || "12345678"/g' package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc

# 修改版本名称
# sed -i 's/ImmortalWrt/编译时间 $(TZ=UTC-8 date "+%Y.%m.%d") @ NAOKUO/g' include/trusted-firmware-a.mk
sed -i 's/ImmortalWrt/NAOKUO/g' include/u-boot.mk
sed -i 's/ImmortalWrt/NAOKUO/g' include/version.mk

# 去除 SSH
cat /dev/null > package/network/services/dropbear/files/dropbear.config
