#! /bin/sh
# author:whinc

LOG_DIR="$(pwd)/log"

#if [ -f "${LOG_DIR}" ]; then
#    echo "${LOG_DIR} doesn't exit!"
#    exit -1
#fi

cat /dev/null > ${LOG_DIR}
echo "Cleanup ${LOG_DIR} successfully!"
exit 0
