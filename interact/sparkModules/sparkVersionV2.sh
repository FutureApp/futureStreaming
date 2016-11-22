if [ -z != $1 ] && [ -z != $2  ]
	then 	
	echo
	printf  "${Blue}I'll run a spark2.0 cluster with $1 seperated docker container as master and $2 seperated docker container as workers${NC}"
	echo
	
	echo "--------"
	echo "Access points for spark2.0 cluster"
	echo "Port 90${x}0:8080"
	echo "Port 90${x}7:7077"
	echo "Port 90${x}6:6066"
	echo "--------"
	echo
	
	sudo docker run -d -p 90${x}0:8080 -p 90${x}7:7077 -p 90${x}6:6066 --name "spark2.0-master" -h  "spark2.0-master" -v /media/sf_VM_Dev/test-results-docker:/usr/local/test -m 512M --memory-swap 0M futureapplications/streaming-spark2.0-master 
	sudo docker exec "spark2.0-master" usr/local/spark/sbin/start-master.sh 
		echo "master is warming up"&& sleep 10

		x=$(( x+1 ))

 		while [ "$x" -le "$2"  ]
 		do
		sudo docker run -d --name "spark2.0-worker-${x}" -h  "spark2.0-worker-${x}" -v /media/sf_VM_Dev/test-results-docker:/usr/local/test -m 512M --memory-swap 0M futureapplications/streaming-spark-worker 
		ipadressOfMaster=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' spark-master)
		sleep 5
		sudo docker exec "spark2.0-worker-${x}" usr/local/spark/sbin/start-slave.sh spark://"${ipadressOfMaster}":7077
		sleep 5
  		x=$(( x+1 ))	
 		done
		exit 0
fi

echo "ERROR Nothing to do. $0"
exit 2
