#!/bin/bash

# a 目录：mihomo 配置
A_DIR="$HOME/.mk/NW/mihomo/config"

# b 目录：proxy-providers.yaml 所在 & 输出目录
B_DIR="$HOME/MK"

# 输出文件前缀
OUTPUT_PREFIX="mihomo_config"

# 检查目录
if [ ! -d "$A_DIR" ] || [ ! -d "$B_DIR" ]; then
    echo "Error: A_DIR or B_DIR does not exist."
    exit 1
fi

# 获取当前日期
DATE=$(date +"%Y%m%d%H%M")

# 输出文件
OUTPUT_FILE="$B_DIR/${OUTPUT_PREFIX}_${DATE}.yaml"

# 清空文件
> "$OUTPUT_FILE"

# 写入头部信息
echo "# =============================" >> "$OUTPUT_FILE"
echo "# Auto-merged configuration" >> "$OUTPUT_FILE"
echo "# Date: $DATE" >> "$OUTPUT_FILE"
echo "# =============================" >> "$OUTPUT_FILE"
echo -e "\n" >> "$OUTPUT_FILE"

# 1️⃣ 合并 b 目录的 proxy-providers.yaml
if [ -f "$B_DIR/proxy-providers.yaml" ]; then
  echo "# ==== proxy-providers.yaml ====" >> "$OUTPUT_FILE"
  cat "$B_DIR/proxy-providers.yaml" >> "$OUTPUT_FILE"
  echo -e "\n" >> "$OUTPUT_FILE"
else
  echo "Warning: proxy-providers.yaml not found in $B_DIR"
fi

# 2️⃣ 合并 a 目录的其他 YAML 文件
for file in "$A_DIR"/*.yaml; do
  filename=$(basename "$file")
  if [ "$filename" != "proxy-providers.yaml" ]; then
    echo "# ==== $filename ====" >> "$OUTPUT_FILE"
    cat "$file" >> "$OUTPUT_FILE"
    echo -e "\n" >> "$OUTPUT_FILE"
  fi
done

echo "✅ Merge complete: $OUTPUT_FILE"
