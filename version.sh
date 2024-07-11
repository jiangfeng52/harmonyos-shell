#!/bin/bash

# 检查是否提供了版本参数
if [ -z "$1" ]; then
  echo "请提供版本号参数。"
  exit 1
fi

VERSION=$1

# 修改版本号
cd TaroWebContainer && \
  ohpm version $VERSION

# changelist
cd ..
# 获取直到以 chore(release): 开头的 commit 为止的所有 commit 信息
COMMITS=$(git log --pretty=format:"%s" | awk '/^chore\(release\):/{exit} {print}')

# 将 commit 信息写入临时文件
TEMP_FILE=$(mktemp)
{
  echo "## $VERSION"
  echo "$COMMITS" | while IFS= read -r line; do
    echo "- $line"
  done
  echo ""
  cat ./TaroWebContainer/CHANGELOG.md
} > "$TEMP_FILE"

# 将临时文件内容写入到 CHANGELOG.md 文件
mv "$TEMP_FILE" ./TaroWebContainer/CHANGELOG.md

# 提交更改
git add .
git commit -m "chore(release): publish $VERSION"

echo "version更新成功"