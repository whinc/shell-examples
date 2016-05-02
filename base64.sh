#! /usr/bin/sh 
# base64.sh - base64 encode/decode implementation.

read input

# BASE64 codes
BASE64=({A..Z} {a..z} {0..9} + /)
# Padding char
PAD="="

# 对字符串进行 base64 编码
# 用法：base64_encode string
# 结果输出到 stdout
base64_encode () 
{
    local str="$*"
    local len=${#str}
    local out=""
    local pad_count=0
    let pad_count="3 - $len % 3"
    for (( i = 0; i < $len; i += 3)); do
        # 每 3 个字节一组，b1 b2 b3 分别为 8 bit 
        let b1="$(printf "%d" "'${str:i:1}")"
        let b2="$(printf "%d" "'${str:$((i+1)):1}")"
        let b3="$(printf "%d" "'${str:$((i+2)):1}")"
#        echo "$b1 $b2 $b3"
        # 将一组 3 个字节转换为 4 个 6 bit 的Base64编码
        pos1=$((( b1 & 2#11111100) >> 2))
        pos2=$((((b1 & 2#00000011) << 4) | ((b2 & 2#11110000) >> 4)))
        pos3=$((((b2 & 2#00001111) << 2) | ((b3 & 2#11000000) >> 6)))
        pos4=$(( b3 & 2#00111111 ))
        # 查询BASE64编码表，替换为对应的字符
        c1=${BASE64[pos1]}
        c2=${BASE64[pos2]}
        c3=${BASE64[pos3]}
        c4=${BASE64[pos4]}
        out="${out}${c1}${c2}${c3}${c4}"
    done

#    echo "$out"
    # 对于字节数不是 3 的倍数时，结尾填充"="
    if (( pad_count == 1 )); then
        out="${out:0:${#out}-1}${PAD}"
    elif (( pad_count == 2 )); then
        out="${out:0:${#out}-2}${PAD}${PAD}"
    fi
    echo -n "$out"

    return 0
}

# 查找指定的 Base64 编码字符在 BASE64 编码表中的位置
# 用法: base64_index char
# 结果输出到 stdout
base64_index ()
{
    local index=-1
    local char="$1"
    for (( i = 0; i < ${#BASE64[@]}; ++i ));do
        if [[ "${BASE64[i]}" == "$char" ]]; then
            index=$i
            break
        fi
    done
    echo -n "$index"
    return 0
}

# 对 Base64 编码的字符串进行解码
# 用法：base64_decode base64_string
# 结果输出到 stdout
base64_decode ()
{
    local out=""
    local str="$*"
    local len=${#str}
    local pad_count=$(expr "$str" : "[^=]*")
    for (( i = 0; i < $len; i+=4 )); do
        # 4个base64编码字符为一组，查询每个字符在BASE64编码表中的位置
        pos1=$(base64_index "${str:i:1}")
        pos2=$(base64_index "${str:i+1:1}")
        pos3=$(base64_index "${str:i+2:1}")
        pos4=$(base64_index "${str:i+3:1}")
        (( pos1 < 0 )) && pos1=0
        (( pos2 < 0 )) && pos2=0
        (( pos3 < 0 )) && pos3=0
        (( pos4 < 0 )) && pos4=0
#        echo "pos:$pos1 $pos2 $pos3 $pos4"

        # 将每组4个 6 bit 的base64编码值转化为 3 个 8 bit 的字节
        b1=$((pos1 << 2 | (pos2 & 2#110000) >> 4))
        b2=$(((pos2 & 2#001111) << 4 | (pos3 & 2#111100) >> 2))
        b3=$(((pos3 & 2#000011) << 6 | pos4 ))

        # 将每组 3 个字节转换为对应的 ASCII 字符
        hex_b1=$(printf "%x" $b1)
        hex_b2=$(printf "%x" $b2)
        hex_b3=$(printf "%x" $b3)
#        echo "hex_b:$hex_b1 $hex_b2 $hex_b3"

        c1=$(printf "\x${hex_b1}")
        c2=$(printf "\x${hex_b2}")
        c3=$(printf "\x${hex_b3}")

        out="${out}${c1}${c2}${c3}"
    done
    echo -n "$out"
    return 0
}

#base64_encode "$input"
base64_decode "$input"
