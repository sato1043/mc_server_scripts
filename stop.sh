#!/bin/bash

. ./settings.sh

if pgrep -u $USERNAME -f $SERVICE > /dev/null
then
  echo "shutting down minecraft($SERVICE) in after 30 seconds..."
else
  echo "minecraft($SERVICE) is not runnning."
  exit 0
fi

screen -p 0 -S $SCNAME -X eval 'stuff "say THE SERVER WILL SHUTDOWN IN 30 SECONDS..."\015'
screen -p 0 -S $SCNAME -X eval 'stuff "say NOW YOUR CONNECTION WILL AUTO-SAVE THEN LOST.,"\015'
screen -p 0 -S $SCNAME -X eval 'stuff "memory"\015'

sleep 30s

screen -p 0 -S $SCNAME -X eval 'stuff "save-all"\015'

sleep 5s

screen -p 0 -S $SCNAME -X eval 'stuff "stop"\015'

PID=`pgrep -u $USERNAME -f $SERVICE | head -1`
if [ -n $PID ]; then
  while ps -p $PID > /dev/null; do sleep 3s; done
fi

echo "stopped."

#__END__
