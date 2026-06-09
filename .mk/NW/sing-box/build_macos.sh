#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$HOME/.mk/NW/sing-box/config-macos"
OUTPUT_DIR="$HOME/MK/sing-box"
OUTPUT_PREFIX="sing-boxConf_MACOS"
# TIMESTAMP=$(date +"%Y%m%d%H%M%S")
# OUTPUT_FILE="${OUTPUT_DIR}/${OUTPUT_PREFIX}_${TIMESTAMP}.json"
OUTPUT_FILE="${OUTPUT_DIR}/${OUTPUT_PREFIX}.json"

# 检查目录
if [ ! -d "$SOURCE_DIR" ] || [ ! -d "$OUTPUT_DIR" ]; then
    echo "Error: SOURCE_DIR or OUTPUT_DIR does not exist."
    exit 1
fi

# 1. 从 Sub-Store 拉取节点

# SUB_URL="http://127.0.0.1:3001/2cXaAxRGfddmGz2yx1wA/download/SSRDOG?target=sing-box"

# curl -L "$SUB_URL" -o "${OUTPUT_DIR}/substore_nodes.json"

# 2. 整理节点
jq '
.outbounds as $nodes |

[
  {
    "tag": "🇭🇰 香港手动",
    "type": "selector",
    "outbounds": (
      $nodes
      | map(select(.tag | test("香港|HK|Hong Kong"; "i")))
      | map(.tag)
    )
  },

  {
    "tag": "🇯🇵 日本手动",
    "type": "selector",
    "outbounds": (
      $nodes
      | map(select(.tag | test("日本|JP|Japan"; "i")))
      | map(.tag)
    )
  },

  {
    "tag": "🇸🇬 狮城手动",
    "type": "selector",
    "outbounds": (
      $nodes
      | map(select(.tag | test("新加坡|狮城|SG|Singapore"; "i")))
      | map(.tag)
    )
  },

  {
    "tag": "🇺🇲 美国手动",
    "type": "selector",
    "outbounds": (
      $nodes
      | map(select(.tag | test("美国|US|USA|United States"; "i")))
      | map(.tag)
    )
  },

  {
    "tag": "🐸 手动选择",
    "type": "selector",
    "outbounds": (
      $nodes | map(.tag)
    )
  },

  {
    "tag": "♻️ 自动选择",
    "type": "urltest",
    "outbounds": (
      $nodes | map(.tag)
    ),
    "url": "https://www.gstatic.com/generate_204",
    "interval": "5m"
  }
]
' "${OUTPUT_DIR}/substore_nodes.json" > "${OUTPUT_DIR}/selectors.json"

# 3. 合并配置，并把 Sub-Store 节点追加到 outbounds 末尾

jq -n \
  --slurpfile dns "${SOURCE_DIR}/dns.json" \
  --slurpfile inbounds "${SOURCE_DIR}/inbounds.json" \
  --slurpfile outbounds "${SOURCE_DIR}/outbounds.json" \
  --slurpfile route "${SOURCE_DIR}/route.json" \
  --slurpfile experimental "${SOURCE_DIR}/experimental.json" \
  --slurpfile log "${SOURCE_DIR}/log.json" \
  --slurpfile nodes "${OUTPUT_DIR}/substore_nodes.json" \
  --slurpfile selectors "${OUTPUT_DIR}/selectors.json" \
'{
  experimental: $experimental[0],
  log: $log[0],
  dns: $dns[0],
  inbounds: $inbounds[0],
  route: $route[0],
  outbounds: ($outbounds[0] + $selectors[0] + $nodes[0].outbounds)
}' > "$OUTPUT_FILE"

echo "生成完成:"
echo "$OUTPUT_FILE"
