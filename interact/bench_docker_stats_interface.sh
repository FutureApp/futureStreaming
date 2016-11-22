#!/bin/bash



if [ "$1" == "worker 2" ] && [ -z != $2 ] && [ -z != $3 ] 
	then 	
	echo "starts to listen on docker-stats with params <$1> <$2> <$3>"
	while [ true  ]
	do
	sudo docker stats --no-stream $3-master $3-worker-1 $3-worker-2 kafka emit zookeeper >> $2/dockermonitor.txt
	sleep 1

	done
	exit 
fi
if [ "$1" == "worker 3" ] && [ -z != $2 ] && [ -z != $3 ] 
	then 	
	echo "starts to listen on docker-stats with params <$1> <$2> <$3>"
	while [ true  ]
	do
	sudo docker stats --no-stream $3-master $3-worker-1 $3-worker-2 $3-worker-3 kafka emit zookeeper >> $2/dockermonitor.txt
	sleep 1

	done
	exit 
fi