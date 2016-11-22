if [ "$1" == "start services" ]
	then 	
		echo
		printf "${LBlue}I'll start all services for the streaming-cluster. This includes zookeeper,kafka and redis${NC}"
		echo 
		sudo bash ./bench_docker_service_cluster.sh "run zookeeper"
		sudo bash ./bench_docker_service_cluster.sh "run kafka"
		#sudo bash ./bench_docker_service_cluster.sh "run redis"			
		sudo bash ./bench_docker_service_cluster.sh "print IP_ADRESSES"
		echo 
		exit
fi


if [ "$1" == "restart services" ]
	then 	
		echo
		printf "${LBlue}I'll restart all services for the streaming-cluster. This includes zookeeper,kafka and redis${NC}"
		echo 
		sudo bash ./bench_docker_service_cluster.sh "restart zookeeper"
		sudo bash ./bench_docker_service_cluster.sh "restart kafka"
		#sudo bash ./bench_docker_service_cluster.sh "restart redis"
		sudo bash ./bench_docker_service_cluster.sh "print IP_ADRESSES"
		echo 
		exit		
fi

if [ "$1" == "run cluster spark2.0" ] && [ -z != $2 ] && [ -z != $3  ]
	then 	
	echo
	printf  "${Blue}I'll run a spark2.0 cluster with $2 seperated docker container as master and $3 seperated docker container as workers${NC}"
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
		echo "waiting for master to warm up 10s."&& sleep 10

		x=$(( x+1 ))

 		while [ "$x" -le "$3"  ]
 		do
		sudo docker run -d --name "spark2.0-worker-${x}" -h  "spark2.0-worker-${x}" -v /media/sf_VM_Dev/test-results-docker:/usr/local/test -m 512M --memory-swap 0M futureapplications/streaming-spark-worker 
		ipadressOfMaster=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' spark-master)
		
		sleep 5
		sudo docker exec "spark2.0-worker-${x}" usr/local/spark/sbin/start-slave.sh spark://"${ipadressOfMaster}":7077
		sleep 5
  		x=$(( x+1 ))	
 		done
		exit
fi