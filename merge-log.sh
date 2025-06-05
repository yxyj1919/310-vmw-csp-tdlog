#!/bin/bash
#
# 日志合并脚本 - v1.0
# 作者: changw
# 功能: 将以 vobd, vmkwarning, vmkernel, hostd, vpxa, vsanmgmt 为前缀的日志文件按时间顺序合并为 .all 文件
# 支持处理压缩文件 (.gz)，并在每个文件内容前添加分隔线

# 创建目标目录
mkdir -p ../../log/tdlog

# 定义前缀列表
prefixes=("vobd" "vmkwarning" "vmkernel" "hostd" "vpxa" "vsanmgmt")

# 遍历每个前缀
for prefix in "${prefixes[@]}"; do
    target_file="../../log/tdlog/${prefix}.all"
    > "$target_file"  # 清空目标文件

    echo "处理前缀: $prefix"

    # 处理 .7 到 .1 的日志文件
    for i in {7..1}; do
        for ext in ".${i}.gz" ".${i}"; do
            file="${prefix}${ext}"
            if [[ -f "$file" ]]; then
                echo "  追加: $file"
                echo -e "\n===== 开始合并文件: $file =====\n" >> "$target_file"
                if [[ "$file" == *.gz ]]; then
                    zcat "$file" >> "$target_file"
                else
                    cat "$file" >> "$target_file"
                fi
            fi
        done
    done

    # 最后处理当前日志文件 (.log / .log.gz)
    for ext in ".log.gz" ".log"; do
        file="${prefix}${ext}"
        if [[ -f "$file" ]]; then
            echo "  追加: $file"
            echo -e "\n===== 开始合并文件: $file =====\n" >> "$target_file"
            if [[ "$file" == *.gz ]]; then
                zcat "$file" >> "$target_file"
            else
                cat "$file" >> "$target_file"
            fi
        fi
    done
done

echo "所有日志文件已按前缀和时间顺序合并完成！"
