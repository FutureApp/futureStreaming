
if [ "$1" == "run cluster spark" ] && [ -z != $2 ] && [ -z != $3  ]
	then 	
	echo
	printf  "${Blue}I'll run a spark cluster with $2 seperated docker container as master and $3 seperated docker container as workers${NC}"
	echo
	
	echo "--------"
	echo "Access points for spark cluster"
	echo "Port 90${x}0:8080"
	echo "Port 90${x}7:7077"
	echo "Port 90${x}6:6066"
	echo "--------"
	echo
	
	sudo docker run -d -p 90${x}0:8080 -p 90${x}7:7077 -p 90${x}6:6066 --name "spark-master" -h  "spark-master" -v /media/sf_VM_Dev/test-results-docker:/usr/local/test -m 512M --memory-swap 0M futureapplications/streaming-spark-master 
	sudo docker exec "spark-master" usr/local/spark/sbin/start-master.sh 
		echo "waiting for master to warm up 10s."&& sleep 10

		x=$(( x+1 ))

 		while [ "$x" -le "$3"  ]
 		do
		sudo docker run -d --name "spark-worker-${x}" -h  "spark-worker-${x}" -v /media/sf_VM_Dev/test-results-docker:/usr/local/test -m 512M --memory-swap 0M futureapplications/streaming-spark-worker 
		ipadressOfMaster=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' spark-master)
		
		sleep 5
		sudo docker exec "spark-worker-${x}" usr/local/spark/sbin/start-slave.sh spark://"${ipadressOfMaster}":7077
		sleep 5
  		x=$(( x+1 ))	
 		done
		exit
fi