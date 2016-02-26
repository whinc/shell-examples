E_BADARGS=85

print_progress() {
    declare -i MIN=1
    declare -i MAX=100
    declare -i cur=$MIN
    declare -i target=$1

    if [[ -z $1 ]];then
        echo "error($LINENO):need a progress number"
        exit E_BADARGS
    fi

    if [[ -n $2 ]]; then
        MAX=$2
    fi

    if [[ -n $3 ]]; then
        MIN=$3
    fi

    if [[ "$target" -lt "$MIN" || "$target" -gt "$MAX" ]];then
        echo "error($LINENO):invalid argument:$target, must between $MIN-$MAX"
        exit E_BADARGS
    fi

    echo -ne "\r"
    while [[ "$cur" -le "$target" ]]
    do
        echo -n "="
        let "cur+=1"
    done
    echo -n " $target/$MAX "
    return
}

target=$1
max=$2
min=$3
cur=1

if [[ "$#" -eq 0 ]];then
    echo "$(basename $0) - print progress."
    echo -e "Usage: \v$(basename $0) progress [max [min]]"
fi

if [[ -n "$min" ]];then
    cur=$min
fi

while [[ "$cur" -le "$target" ]]
do
    print_progress $cur $max $min
    let "cur+=1"
    sleep 1
done
