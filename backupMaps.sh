#! /bin/bash

. ./settings.sh

if pgrep -u $USERNAME -f $SERVICE > /dev/null
then
  echo "starting world backup of minecraft($SERVICE) ..."
else
  echo "minecraft($SERVICE) for on-time backup is not running."
  exit 0
fi

screen -p 0 -S $SCNAME -X eval 'stuff "say TIME TO BACKUP WORLDS..."\015'
screen -p 0 -S $SCNAME -X eval 'stuff "say NOW YOUR CONNECTION WILL AUTO-SAVE."\015'
screen -p 0 -S $SCNAME -X eval 'stuff "memory"\015'

screen -p 0 -S $SCNAME -X eval 'stuff "save-off"\015'

sleep 10s

screen -p 0 -S $SCNAME -X eval 'stuff "save-all"\015'

sleep 10s

echo "backing up..."

cd $MC_DIR
tar czf $MAPS_BK_NAME $MAPS_BK_FILE

screen -p 0 -S $SCNAME -X eval 'stuff "save-on"\015'

# 世代管理
CHK_GEN=$(ls -1 ${MAPS_TGT_FILE}|wc -l)
DEL_LIST=$(ls -1 -t ${MAPS_TGT_FILE}|tail -n ${MAPS_TAIL_GEN})
if [[ ${CHK_GEN} -gt $MAPS_BK_GEN ]]; then
    rm -f ${MAPS_BK_DIR}/${DEL_LIST}
fi

screen -p 0 -S $SCNAME -X eval 'stuff "say BACKING UP WORLDS IS DONE."\015'

echo "done ($MAPS_BK_NAME)."

#__END__
