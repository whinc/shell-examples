ERR_INVALID_ARGS=85

if [[ $# -ne 2 ]];then
    echo "Usage: $(basename $0) first-number second-number"
    exit $ERR_INVALID_ARGS
fi

gcd () {
    dividend=$1
    divisor=$2
    reminder=1

    while [[ reminder -ne 0 ]]
    do
        let "reminder=$dividend % $divisor"
        dividend=$divisor
        divisor=$reminder
    done
}

gcd $1 $2

echo "Greatest common divisor of $1 and $2 is $dividend"
exit 0
