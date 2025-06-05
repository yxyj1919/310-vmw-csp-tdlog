#!/bin/bash
#
# ========================================
# FRAG 文件合并工具 - v1.1
# 作者: changw
# 日期: 2025-06-05
# 描述: 将当前目录下的 *.txt.FRAG-* 文件按顺序合并为原始的 .txt 文件
# 功能:
#   - 自动识别并合并所有相同前缀的 FRAG 文件
#   - 按编号顺序（如 0001, 0002, ...）合并
#   - 合并完成后自动删除原始 FRAG 文件
# ========================================

shopt -s nullglob  # 防止无匹配时保留原模式字符串

# 获取所有匹配的 FRAG 文件
files=( *.txt.FRAG-* )
if [ ${#files[@]} -eq 0 ]; then
    echo "当前目录下没有匹配的 *.txt.FRAG-* 文件"
    exit 1
fi

# 提取所有唯一的 base 文件前缀
prefixes=$(for f in "${files[@]}"; do echo "${f%.FRAG-*}"; done | sort -u)

# 对每个前缀进行处理
for base in $prefixes; do
    echo "合并文件前缀: $base → $base"

    # 清空目标合并文件
    > "$base"

    # 找到并排序所有对应的 FRAG 文件
    frag_files=( $(ls "${base}.FRAG-"* 2>/dev/null | sort -V) )

    for frag in "${frag_files[@]}"; do
        echo "  追加: $frag"
        echo -e "\n===== 合并文件片段: $frag =====\n" >> "$base"
        cat "$frag" >> "$base"
        rm -f "$frag"
    done
done

echo "所有 FRAG 文件已成功合并！"
