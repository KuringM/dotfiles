#!/bin/bash

SOURCE_DIR="$HOME/.mk/NW/sing-box/config"
OUTPUT_DIR="$HOME/MK"
OUTPUT_PREFIX="sing-box_config"

TIMESTAMP=$(date +"%Y%m%d%H%M%S")

OUTPUT_FILE="${OUTPUT_DIR}/${OUTPUT_PREFIX}_${TIMESTAMP}.json"

# 检查目录
if [ ! -d "$SOURCE_DIR" ] || [ ! -d "$OUTPUT_DIR" ]; then
    echo "Error: SOURCE_DIR or OUTPUT_DIR does not exist."
    exit 1
fi

jq -n \
  --slurpfile providers "${OUTPUT_DIR}/providers.json" \
  --slurpfile dns "${SOURCE_DIR}/dns.json" \
  --slurpfile inbounds "${SOURCE_DIR}/inbounds.json" \
  --slurpfile outbounds "${SOURCE_DIR}/outbounds.json" \
  --slurpfile route "${SOURCE_DIR}/route.json" \
  --slurpfile experimental "${SOURCE_DIR}/experimental.json" \
  --slurpfile log "${SOURCE_DIR}/log.json" \
'{
  providers: $providers[0],
  dns: $dns[0],
  inbounds: $inbounds[0],
  outbounds: $outbounds[0],
  route: $route[0],
  experimental: $experimental[0],
  log: $log[0]
}' > "$OUTPUT_FILE"

echo "生成完成:"
echo "$OUTPUT_FILE"
