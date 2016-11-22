#!/bin/bash 
# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")

if [ "$1" == "build all images" ] 
	then
	printf  "${Blue}I'll build all streaming-technolgies images${NC}"
	echo
	sudo docker build -t futureapplications/streaming-basis $0/../../images/basis/. 
	
	sudo docker build -t futureapplications/streaming-spark2.0-master $0/../../images/spark2.0/master/.
	sudo docker build -t futureapplications/streaming-spark2.0-worker $0/../../images/spark2.0/worker/.
		
	sudo docker build -t futureapplications/streaming-kafka $0/../../images/kafka/.

	sudo docker build -t futureapplications/streaming-zookeeper $0/../../images/zookeeper/.
	exit 0
fi
current_dir=$(pwd)
script_dir=$(dirname $0)
exit 2
