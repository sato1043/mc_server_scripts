#! /bin/bash

source ./settings.sh

if pgrep -u $USERNAME -f $SERVICE > /dev/null
then
  echo "minecraft($SERVICE) is already runnning."
  exit 0
else
  echo "starting minecraft($SERVICE)..."
fi

cd $SH_DIR

screen -UAmdS $SCNAME ./run_jar.sh

#__END__
