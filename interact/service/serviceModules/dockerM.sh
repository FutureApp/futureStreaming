#!/bin/bash 
# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
iHome="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $iHome

if [ "$1" == "build all images" ] 
	then
		printf  "${Blue}Building all images ${NC}"
		echo
		docker build -t futureapplications/streaming-basis ../../../images/basis/. 

		docker build -t futureapplications/streaming-spark2.0-master ../../../images/spark2.0/master/.
		docker build -t futureapplications/streaming-spark2.0-worker ../../../images/spark2.0/worker/.
		
		docker build -t futureapplications/streaming-kafka ../../../images/kafka/.

		docker build -t futureapplications/streaming-zookeeper ../../../images/zookeeper/.
	exit 0
fi

exit 2
