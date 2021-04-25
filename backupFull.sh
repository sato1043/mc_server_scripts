#! /bin/bash

. ./settings.sh

WILL_RESTART=
if pgrep -u $USERNAME -f $SERVICE > /dev/null
then
  echo "waiting for full backup of minecraft($SERVICE) ..."
  WILL_RESTART=yes
else
  echo "minecraft($SERVICE) for backup is not running."
fi

if [ $WILL_RESTART ]; then
  screen -p 0 -S $SCNAME -X eval 'stuff "say TIME TO FULL BACKUP..."\015'
  screen -p 0 -S $SCNAME -X eval 'stuff "say AFTER BACKUP COMPLEATED, SERVER WILL START UP AGAIN."\015'
  
  cd $SH_DIR
  ./stop.sh
fi

echo "backing up database..."

cd $SH_DIR
./backupDB.sh

echo "backing up..."

cd $MC_DIR/..
tar czf $FULL_BK_NAME `basename $MC_DIR`

rm -f $DB_BK_NAME

# 世代管理
CHK_GEN=$(ls -1 ${FULL_TGT_FILE} | wc -l)
DEL_LIST=$(ls -1 -t ${FULL_TGT_FILE} | tail -n ${FULL_TAIL_GEN})
if [[ ${CHK_GEN} -gt $FULL_BK_GEN ]]; then
  rm -f ${DEL_LIST}
fi

echo "done ($FULL_BK_NAME)."


if [ $WILL_RESTART ]; then
  cd $SH_DIR
  ./start.sh
fi

#__END__
