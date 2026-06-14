## 1. 开启promisc 混杂模式 : 让网卡/虚拟网卡接收不一定发给自己的二层帧.

场景1:

```plain
手机 / 电脑 → UTM : ImmortalWrt → 主路由 → 外网
```

如果 ImmortalWrt 是虚拟机, 并且使用桥接网络, 宿主机和虚拟网卡需要允许 VM 处理局域网设备的流量.
否则可能出现:ImmortalWrt 自己能上网, 手机指向 ImmortalWrt 后不通.

检查PROMISC是否开启:

`ip link show`

临时开启:

```bash
ip link set eth0 promisc on
ip link set br-lan promisc on
```

UTM 网络设置:

- 网络模式: Bridged / 桥接
- 允许混杂模式: 开启

## 2. IP forwarding(转发): 让系统把收到的 IP 包继续转给下一跳.

例如:

```plain
手机: 10.10.10.132
ImmortalWrt: 10.10.10.6
主路由: 10.10.10.1
```

手机网关指向 ImmortalWrt 后:

`手机 → 10.10.10.6 → 10.10.10.1 → 外网`

ImmortalWrt 要做中间转发, 就必须开启 IP forwarding.

查看:

`sysctl net.ipv4.ip_forward`

正常应该是:

`net.ipv4.ip_forward = 1`

临时开启:

```
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv6.conf.all.forwarding=1
```

## 3. 单臂旁路由还需要 NAT

如果 ImmortalWrt 只有一个 LAN 口, 和手机、主路由都在同一个网段:

```
手机: 10.10.10.132
ImmortalWrt: 10.10.10.6
主路由: 10.10.10.1
```

这就是典型 单臂旁路由.

这时建议开启 LAN 区域 NAT, 否则可能出现回程绕路、连接异常.

常用配置:

```
uci set firewall.@defaults[0].forward='ACCEPT'
uci set firewall.@zone[0].masq='1'
uci set firewall.@zone[0].mtu_fix='1'
uci set firewall.@zone[0].forward='ACCEPT'
uci commit firewall
/etc/init.d/firewall restart
```

### 4. ImmortalWrt 自身网关要指向主路由

主路由是: `10.10.10.1`
ImmortalWrt LAN 是: `10.10.10.6`
则设置:

```bash
uci set network.lan.gateway='10.10.10.1'
uci set network.lan.dns='10.10.10.1'
uci commit network
/etc/init.d/network restart
```

如果 DNS 交给 Nikki / sing-box, 也可以让 DNS 指向自己:
`uci set network.lan.dns='10.10.10.6'`

## 5. 最小可用条件

你的 UTM ImmortalWrt 要当旁路由, 至少满足:

1. UTM 使用 Bridged / 桥接网络
2. 虚拟网卡允许 promisc 混杂模式
3. ImmortalWrt 开启 ip_forward
4. ImmortalWrt 默认网关指向主路由 / iKuai
5. 防火墙允许 forward
6. 单臂旁路由开启 masq / NAT
7. 手机网关指向 ImmortalWrt
8. 手机 DNS 指向 ImmortalWrt 或一个可用 DNS
9. 一句话总结
   promisc 解决"虚拟机能不能收到局域网设备的包"
   ip_forward 解决"收到后能不能继续转出去"
   masq/NAT 解决"单臂旁路由回程会不会乱"

所以你排查顺序可以按这个来:

```bash
ip link show
sysctl net.ipv4.ip_forward
ip route
uci show firewall | grep -E "forward|masq|zone|network"
```

你最终想看到:

```bash
br-lan / eth0 有 PROMISC
net.ipv4.ip_forward = 1
default via 10.10.10.1 dev br-lan
LAN zone masq='1'
forward='ACCEPT'
```
