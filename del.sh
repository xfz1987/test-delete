#!/bin/bash

# 设置目标日期
TARGET_DATE="2024-10-30"

branches_to_delete=$(git for-each-ref --sort=committerdate --format '%(refname:short) %(committerdate:short)' refs/remotes/ \
    | awk -v target_date="$TARGET_DATE" '$2 < target_date && $1 !~ /good/ && $1 !~ /master/' \
    | awk '{print $1}' \
    | sed 's#^origin/##')  # 去掉 'origin/' 前缀

# 统计要删除的分支数量
count=$(echo "$branches_to_delete" | wc -l)

# 输出要删除的分支名称
if [ $count -gt 0 ]; then
    echo "要删除的分支有："
    echo "$branches_to_delete"
    
    # 执行删除操作：慎重啊
    echo "$branches_to_delete" | xargs -I {} git push origin --delete {}
else
    echo "没有要删除的分支。"
fi

# 输出删除的分支数量
echo "一共删除了 $count 个分支"