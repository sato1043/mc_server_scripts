#! /bin/bash

. ./settings.sh

CHK_GEN=$(ls -1 $LOGS_TGT_FILE | wc -l)
DEL_LIST=$(ls -1 -t ${LOGS_TGT_FILE} | tail -n ${LOGS_TAIL_GEN})
if [[ ${CHK_GEN} -gt $LOGS_BK_GEN ]]; then
  rm -f ${DEL_LIST}
fi

#__END__
