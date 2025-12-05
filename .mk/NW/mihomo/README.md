## config.ymal 配置文件层级

```bash
/config/
├── main.yaml                 # 主配置
└── providers.yaml            # 机场订阅
├── groups.yaml               # 代理分组
├── rules.yaml                # 规则与顺序
├── rule-providers.yaml       # rule-providers 列表
```

### 合并成一个完整配置文件

```bash
cat main.yaml proxy-providers.yaml proxy-groups.yaml rules.yaml rule-providers.yaml > mihomo_full.yaml
```
