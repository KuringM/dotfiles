# UTM 中 ImmortalWrt 运行 Nikki 无法访问外网排查记录

## 1. 场景背景

环境:

```text
宿主机: macOS + UTM
虚拟机: ImmortalWrt
代理组件: Nikki / mihomo
ImmortalWrt IP: 10.10.10.8
上级网关: 10.10.10.1
TUN 接口: Meta
Nikki HTTP/mixed 代理端口: 7890
Nikki API 端口: 9090
Nikki DNS 端口: 1053
```

故障现象:

`curl -I https://www.baidu.com --max-time 10`

国内访问正常:

`HTTP/1.1 200 OK`

但是:

`curl -I https://www.google.com --max-time 10`

外网访问超时:

`curl: (28) Connection timed out`

同时手动指定 Nikki 代理端口却可以访问:

`curl -I -x http://127.0.0.1:7890 https://www.google.com --max-time 10`

返回:

`HTTP/2 200`

这说明:

- Nikki 核心正常
- 节点正常
- 代理端口正常
- 但普通流量没有被透明代理接管

## 2. 第一层: 确认 ImmortalWrt 基础网络

执行:

```bash
ip addr show
ip route
cat /etc/resolv.conf
```

当时结果:

```bash
br-lan: 10.10.10.8/24
default via 10.10.10.1 dev br-lan
nameserver 127.0.0.1
```

说明:

- ImmortalWrt 本身有 IP
- 默认网关正常
- DNS 指向本机 dnsmasq

继续测试:

```bash
ping -c 4 223.5.5.5
nslookup baidu.com
nslookup google.com
curl -I https://www.baidu.com --max-time 10
```

结果:

```bash
223.5.5.5 可 ping 通
baidu.com 可解析
google.com 可解析
baidu.com 可访问
```

结论:

- ImmortalWrt 基础网络正常
- 不是 UTM 网卡基础连通性问题
- 不是 DNS 完全失效

## 3. 第二层: 确认 Nikki 核心是否正常

查看进程:

`ps | grep -E 'mihomo|nikki|clash' | grep -v grep`

结果:

`/usr/bin/mihomo -d /etc/nikki/run`

查看端口:

`netstat -lnptu | grep -E '7890|7891|7892|9090|9095|53'`

关键结果:

```bash
:::7890 LISTEN mihomo
:::9090 LISTEN mihomo
:::1053 LISTEN mihomo
127.0.0.1:53 / 10.10.10.8:53 dnsmasq
```

说明:

- mihomo 核心已经运行
- 7890 代理端口已监听
- 9090 API 端口已监听
- 1053 DNS 端口已监听

## 4. 第三层: 确认节点是否可用

测试 HTTP 代理端口:

`curl -I -x http://127.0.0.1:7890 https://www.google.com --max-time 10`

结果:

```bash
HTTP/1.1 200 Connection established
HTTP/2 200
```

测试代理出口 IP:

`curl -x http://127.0.0.1:7890 https://ip.sb --max-time 10`

结果:

`5.34.216.xxx`

结论:

- 节点可用
- 订阅可用
- Nikki 代理端口可用
- 外网本身不是完全不通

## 5. 第四层: 确认普通流量是否被透明代理接管

普通访问:

`curl https://ip.sb --max-time 10`

最初返回:

`36.63.138.252`

这是本地公网 IP.

而指定代理:

`curl -x http://127.0.0.1:7890 https://ip.sb --max-time 10`

返回:

`5.34.216.xxx`

说明:

- 普通流量没有走 Nikki
- 手动代理流量才走 Nikki

结论:

- 问题不在节点
- 问题不在 mihomo 核心
- 问题在透明代理 / TUN / nft / ip rule 接管层

## 6. 第五层: 检查 nft 和 ip rule

检查 nft:

`nft list ruleset | grep -iE 'nikki|mihomo|tproxy|redirect|mark|7891|7892|1053' -n`

最初只看到:

`DNSMASQ HIJACK`

没有看到:

```bash
table inet nikki
redirect to :7891
mark 0x81
tproxy
```

检查 ip rule:

`ip rule show`

最初结果:

```bash
0: from all lookup local
32766: from all lookup main
32767: from all lookup default
```

没有看到:

`1025: from all fwmark 0x81/0xff lookup 81`

检查路由表:

`ip route show table 81`

最初结果:

`Error: ipv4: FIB table does not exist.`

结论:

- Nikki 没有成功生成透明代理规则
- nft table inet nikki 没有生成
- ip rule 没有生成
- table 81 没有生成

## 7. 第六层: 发现 yq 权限问题

重启 Nikki 时出现:

`/etc/init.d/nikki restart`

报错:

```bash
/etc/rc.common: line 337: yq: Permission denied
/etc/rc.common: line 338: yq: Permission denied
/etc/rc.common: line 339: yq: Permission denied
```

检查 yq:

```bash
type yq
command -v yq
ls -l /usr/bin/yq
```

确认路径:

`/usr/bin/yq`

修复权限:

`chmod 755 /usr/bin/yq`

测试:

`yq --version`

正常输出:

`yq version v4.52.5`

结论:

- yq 权限问题已修复
- 但透明代理仍未生效
- 说明还有下一层问题

## 8. 第七层: 继续检查 Nikki 运行配置

查看 Nikki UCI 配置:

`uci show nikki | grep -E 'mode|tun|redir|tproxy|dns|fake|mixin|proxy|lan|route'`

关键配置:

```bash
nikki.proxy.enabled='1'
nikki.proxy.tcp_mode='redirect'
nikki.proxy.udp_mode='tun'
nikki.proxy.router_proxy='1'
nikki.proxy.lan_proxy='1'
nikki.routing.tun_fw_mark='0x81'
nikki.routing.tun_route_table='81'
nikki.mixin.tun_enabled='1'
nikki.mixin.tun_device='nikki'
```

理论上应该启用:

```bash
TCP redirect
UDP tun
router proxy
lan proxy
fwmark 0x81
route table 81
```

但实际规则仍没有生成.

## 9. 第八层: 发现 tun.device 为 null

检查运行配置:

`yq -M '.tun.device' /etc/nikki/run/config.yaml`

结果:

`null`

查看 tun 块:

`sed -n '60,85p' /etc/nikki/run/config.yaml`

结果:

```bash
tun:
enable: true
stack: mixed
dns-hijack: ["any:53", "tcp://any:53"]
#device: nikki
auto-route: false
auto-redirect: false
auto-detect-interface: true
```

关键问题:

`#device: nikki`

device 被注释掉了.

而实际 TUN 接口是:

`ip link show`

结果中有:

`Meta: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP>`

真实接口名:

`Meta`

## 10. 第九层: 理解 Nikki 脚本为什么失败

Nikki 启动脚本中有:

`tun_device=$(yq -M "(.tun | select(.enable) | .device) // (.listeners[] | select(.name == \"$tun_listener_name\" and .type == \"tun\") | .device)" "$RUN_PROFILE_PATH")`

后面会用:

```bash
ip -4 route add unicast default dev "$tun_device" table "$tun_route_table"
ip -4 rule add pref "$tun_rule_pref" fwmark "$tun_fw_mark/$tun_fw_mask" table "$tun_route_table"
```

由于:

`tun_device = null`

所以无法正常创建:

```bash
table 81
ip rule fwmark 0x81
nft table inet nikki
```

这就是透明代理不生效的根因.

## 11. 正式修复方法

不能只改:

```bash
uci set nikki.mixin.tun_device='Meta'
uci commit nikki
```

因为最终 `/etc/nikki/run/config.yaml` 是由源配置生成的, 源配置里的 tun 块覆盖了 Nikki mixin.

需要修改源配置文件.

先查找源配置:

```bash
grep -R "device: nikki" /etc/nikki 2>/dev/null
grep -R "使用nikki" /etc/nikki 2>/dev/null
grep -R "#device: nikki" /etc/nikki 2>/dev/null
```

找到源文件后, 把:

`#device: nikki`

改成:

`device: Meta`

也就是去掉 #, 并改成真实 TUN 接口名.

修改后重启:

```bash
/etc/init.d/nikki restart
sleep 3
```

## 12. 修复后的验证结果

检查 TUN device:

`yq -M '.tun.device' /etc/nikki/run/config.yaml`

结果:

`Meta`

检查 ip rule:

`ip rule show`

结果:

```bash
0: from all lookup local
1025: from all fwmark 0x81/0xff lookup 81
32766: from all lookup main
32767: from all lookup default
```

检查 route table 81:

`ip route show table 81`

结果:

`default dev Meta scope link`

检查 nft:

`nft list ruleset | grep -iE 'nikki|tproxy|redirect|mark|7891|7892' -n`

关键结果:

```bash
table inet nikki
redirect to :1053
redirect to :7891
meta mark set ... 0x81
jump router_redirect
jump lan_redirect
```

测试 Google:

`curl -I https://www.google.com --max-time 10`

结果:

`HTTP/2 200`

测试普通出口 IP:

`curl https://ip.sb --max-time 10`

结果:

`5.34.216.xxx`

说明普通流量已经走代理.

## 13. 关于 407 错误

修复后执行:

`curl -x http://127.0.0.1:7890 https://ip.sb --max-time 10`

出现:

`curl: (56) CONNECT tunnel failed, response 407`

含义:

`407 = Proxy Authentication Required`

原因是 Nikki 开启了代理端口认证:

`nikki.mixin.authentication='1'`

这不是透明代理故障.

如果需要手动使用 7890 代理端口, 可以关闭认证:

```bash
uci set nikki.mixin.authentication='0'
uci commit nikki
/etc/init.d/nikki restart
```

如果只用透明代理, 可以不管 407.

## 14. 最终正常链路

修复后普通流量路径:

```plain
客户端 / ImmortalWrt 本机流量
→ nft table inet nikki
→ TCP redirect 到 7891
→ UDP / FakeIP / TUN 流量打 mark 0x81
→ ip rule fwmark 0x81 lookup table 81
→ table 81 default dev Meta
→ Meta TUN
→ mihomo / Nikki
→ 代理节点
→ 外网
```

## 15. 排查思路总结

遇到类似问题时, 不要一上来就改配置, 按层排查.

### 15.1 先确认基础网络

```bash
ip addr show
ip route
ping -c 4 223.5.5.5
nslookup baidu.com
curl -I https://www.baidu.com --max-time 10
```

如果国内都不通, 先查 UTM 网卡、网关、DNS.

### 15.2 再确认 Nikki 核心

```bash
ps | grep -E 'mihomo|nikki|clash' | grep -v grep
netstat -lnptu | grep -E '7890|7891|7892|9090|1053'
```

如果核心没跑或端口没监听, 先查 Nikki 服务.

### 15.3 再确认节点

```bash
curl -I -x http://127.0.0.1:7890 https://www.google.com --max-time 10
curl -x http://127.0.0.1:7890 https://ip.sb --max-time 10
```

如果 -x 7890 通, 说明节点和代理端口没问题.

### 15.4 再确认透明代理

```bash
curl https://ip.sb --max-time 10
curl -I https://www.google.com --max-time 10
```

如果普通流量还是本地 IP, 说明透明代理没接管.

### 15.5 查 nft 和 ip rule

```bash
nft list ruleset | grep -iE 'nikki|tproxy|redirect|mark|7891|7892|1053' -n
ip rule show
ip route show table 81
```

正常应看到:

```bash
table inet nikki
redirect to :7891
meta mark 0x81
1025: from all fwmark 0x81/0xff lookup 81
default dev Meta table 81
```

### 15.6 查 tun.device

```bash
yq -M '.tun.device' /etc/nikki/run/config.yaml
sed -n '60,85p' /etc/nikki/run/config.yaml
ip link show
```

如果:

`.tun.device = null`

但实际接口是:

`Meta`

就需要在源配置中写:

```bash
tun:
device: Meta
```

## 16. 本次故障一句话总结

本次问题不是 UTM 网络问题, 也不是 Nikki 节点问题, 而是源配置里的 TUN 设备名被注释:

`#device: nikki`

导致 Nikki 启动脚本读取到:

`tun.device = null`

从而无法生成 ip rule、table 81 和 nft table inet nikki, 普通流量没有进入透明代理. 将源配置改为:

`device: Meta`

后, 透明代理规则正常生成, Google 和外网访问恢复正常.

## 17. 最终确认命令

以后重启 Nikki 后, 可以用这一组快速确认是否正常:

```bash
echo "=== TUN DEVICE ==="
yq -M '.tun.device' /etc/nikki/run/config.yaml
echo "=== IP RULE ==="
ip rule show
echo "=== TABLE 81 ==="
ip route show table 81
echo "=== NFT ==="
nft list ruleset | grep -iE 'nikki|tproxy|redirect|mark|7891|7892|1053' -n
echo "=== TEST ==="
curl -I https://www.google.com --max-time 10
curl https://ip.sb --max-time 10
```

正常结果应该包含:

```txt
Meta
1025: from all fwmark 0x81/0xff lookup 81
default dev Meta scope link
table inet nikki
HTTP/2 200
代理出口 IP
```
