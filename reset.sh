#! /bin/bash

source ./settings.sh

cd $SH_PATH

./halt.sh
./start.sh

screen -rd

#__END__
