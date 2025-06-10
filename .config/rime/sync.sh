#!/bin/bash

SRC_DIR="$(pwd)"
TARGET_DIR="$HOME/Library/Rime"

# 检查目标目录是否存在
if [ ! -d "$TARGET_DIR" ]; then
    echo "错误: '$TARGET_DIR' 不是一个有效的目录"
    exit 1
fi

echo "源目录: $SRC_DIR"
echo "目标目录: $TARGET_DIR"
echo

# 遍历源目录下所有文件（不递归）
for file in "$SRC_DIR"/*; do
    # 只处理非 .sh 后缀的普通文件
    if [ -f "$file" ] && [[ "$file" != *.sh ]]; then
        filename="$(basename "$file")"
        if [ -f "$TARGET_DIR/$filename" ]; then
            echo "替换: $TARGET_DIR/$filename"
        else
            echo "复制: $filename -> $TARGET_DIR/"
        fi
        cp -f -- "$file" "$TARGET_DIR/"
    fi
done

echo
echo "全部处理完成 ✅"


killall Squirrel
open /Library/Input\ Methods/Squirrel.app
echo "重新部署"
