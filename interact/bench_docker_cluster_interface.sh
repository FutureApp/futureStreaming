iHome="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

Blue='\033[0;34m'
NC='\033[0m' # No Color

sudo echo
#echo $1
#echo $2
#echo $3
echo 
x=0


if [ "$1" == "stop all container" ]
	then
	sudo docker stop `sudo docker ps -aq`
	exit
fi

if [ "$1" == "pause container" ] && [ -z != $2 ] 
	then
	echo "send container $2 to sleep"
	sudo docker pause $2
	exit
fi

if [ "$1" == "unpause container" ] && [ -z != $2 ] 
	then
	echo "wake up container $2 "
	sudo docker pause $2
	sudo docker exec -it $2 bash
	exit
fi

if [ "$1" == "kill all container" ]
	then
	sudo docker stop `sudo docker ps -aq`
	sudo docker rm `sudo docker ps -aq`
	exit
fi

if [ "$1" == "kill container" ] && [ -n "$2" ]
	then
	sudo docker stop $2
	sudo docker rm $2
	exit
fi

if [ "$1" == "kill everything" ] 
	then
	sudo docker stop `sudo docker ps -aq`
	sudo docker rm `sudo docker ps -aq`
	sudo docker rmi $(sudo docker images)
	exit
fi

if [ "$1" == "connect to" ] && [ -z != $2 ] 
	then
	echo 
	sudo docker exec -it $2 bash
	
	exit
fi

if [ "$1" == "build all images" ] 
	then
	printf  "${Blue}I'll build all streaming-technolgies images${NC}"
	echo
	sudo docker build -t futureapplications/streaming-basis $iHome/../basis/. 
	
	sudo docker build -t futureapplications/streaming-flink-master $iHome/../flink/master/.
	sudo docker build -t futureapplications/streaming-flink-worker $iHome/../flink/worker/.

	sudo docker build -t futureapplications/streaming-spark-master $iHome/../spark/master/.
	sudo docker build -t futureapplications/streaming-spark-worker $iHome/../spark/worker/.
		
	sudo docker build -t futureapplications/streaming-spark2.0-master $iHome/../spark2.0/master/.
	sudo docker build -t futureapplications/streaming-spark2.0-worker $iHome/../spark2.0/worker/.

	sudo docker build -t futureapplications/streaming-storm-master $iHome/../storm/master/.
	sudo docker build -t futureapplications/streaming-storm-worker $iHome/../storm/worker/.
		
	sudo docker build -t futureapplications/streaming-kafka $iHome/../kafka/.
	sudo docker build -t futureapplications/streaming-zookeeper $iHome/../zookeeper/.
	sudo docker build -t futureapplications/streaming-redis $iHome/../redis/.
		
			
	sudo docker build -t futureapplications/streaming-emit $iHome/../emit/.
	sudo docker build -t futureapplications/streaming-leecher $iHome/../leecher/.
		
	exit
fi

if [ "$1" == "push all images" ] 
	then
	printf  "${Blue}I'll push all streaming-technolgies images to docker-hub${NC}"
	
	sudo docker push futureapplications/streaming-basis 
	sudo docker push futureapplications/streaming-flink-master
	sudo docker push futureapplications/streaming-flink-worker

	sudo docker push futureapplications/streaming-spark-master
	sudo docker push futureapplications/streaming-spark-worker
	
			sudo docker push futureapplications/streaming-spark2.0-master
	sudo docker push futureapplications/streaming-spark2.0-worker

	sudo docker push futureapplications/streaming-storm-master
	sudo docker push futureapplications/streaming-storm-worker
		
	sudo docker push futureapplications/streaming-basis 
	
	sudo docker pushfutureapplications/streaming-flink-master 
	sudo docker push futureapplications/streaming-flink-worker 


	sudo docker push futureapplications/streaming-storm-master  
	sudo docker push futureapplications/streaming-storm-worker  
		
	sudo docker push futureapplications/streaming-kafka  
	sudo docker push futureapplications/streaming-zookeeper  
	sudo docker push futureapplications/streaming-redis 
		
			
	sudo docker push futureapplications/streaming-emit 
	sudo docker push futureapplications/streaming-leecher 	
		
	exit
fi


if [ "$1" == "run cluster flink" ] && [ -z != $2 ] && [ -z != $3  ]
	then
	echo
	printf  "${Blue}I'll run a flink cluster with $2 seperated docker container as master and $3 seperated docker container as workers${NC}"
	echo

	echo > slaves
	#activate if ssh is working
	#echo "localhost" > slaves 
	sudo docker run -d -p 90${x}0:8081 -p 90${x}1:6132 -p 90${x}2:22 --name "flink-master" -h  "flink-master" -v /media/sf_VM_Dev/test-results-docker:/usr/local/test -m 512M --memory-swap 0M futureapplications/streaming-flink-master
	
	#sudo docker run -it -p 9000:8081 -p 9001:6132 -p 9002:22 --name "flink-master" -h  "flink-master" futureapplications/streaming-flink-master bash 
	ipadressOfMaster=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' flink-master)

	sudo docker exec "flink-master" sed -i "s/#IPADDRESS_MASTER#/$ipadressOfMaster/" /usr/local/flink/conf/flink-conf.yaml 
	sudo docker exec "flink-master" bash /usr/local/flink/bin/start-cluster.sh
	sudo docker exec "flink-master" service ssh restart
	echo "warm up time for master wait 5s" && sleep 5
	x=$(( x+1 ))

 		while [ "$x" -le "$3"  ]
 		do
		sudo docker run -d --name "flink-worker-${x}" -h  "flink-worker-${x}" -v /media/sf_VM_Dev/test-results-docker:/usr/local/test -m 512M --memory-swap 0M futureapplications/streaming-flink-worker 
		ipWorkerX=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' flink-worker-${x})		
		
		sudo docker exec "flink-worker-${x}" sed -i "s/#IPADDRESS_MASTER#/$ipadressOfMaster/" /usr/local/flink/conf/flink-conf.yaml
		sudo docker exec "flink-worker-${x}" service ssh restart
		sudo docker exec "flink-worker-${x}" bash /usr/local/flink/bin/taskmanager.sh start
		
		#activate if ssh is working
		#echo "${ipWorkerX}" >> slaves 
		echo "waiting for flink-worker -> flink-master connection 5s" && sleep 5
  		x=$(( x+1 ))	
 		done

		sudo docker cp slaves flink-master:/usr/local/flink/conf/slaves
		rm slaves

		#After finish you need to start the service manualy and accept all requirements ->
		#sudo docker exec -it flink-master bash
		#bash /usr/local/flink/bin/start-cluster.sh
		#--- now accept all questions by shell and your cluster will run

		echo "every master and worker should be connected"
		exit
fi

if [ "$1" == "connect flink-worker" ] && [ -z != $2 ] 
	then
	echo
	printf  "${Blue}Start flink instance${NC}"
	echo	
	ipadressOfMaster2=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' flink-master)

		sudo docker run -d --name "flink-worker-$2" -h  "flink-worker-$2" -v /media/sf_VM_Dev/test-results-docker:/usr/local/test -m 512M --memory-swap 0M futureapplications/streaming-flink-worker 
		
		sudo docker exec "flink-worker-${2}" sed -i "s/#IPADDRESS_MASTER#/$ipadressOfMaster2/" /usr/local/flink/conf/flink-conf.yaml
		sudo docker exec "flink-worker-${2}" bash /usr/local/flink/bin/taskmanager.sh start

		#After finish you need to start the service manualy and accept all requirements ->
		#sudo docker exec -it flink-master bash
		#bash /usr/local/flink/bin/start-cluster.sh
		#--- now accept all questions by shell and your cluster will run
		exit
fi





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


if [ "$1" == "run cluster storm" ] && [ -z != $2 ] && [ -z != $3  ] 
	then 
		echo
		printf  "${Blue}I'll run a strom cluster with $2 seperated docker container as master and $3 seperated docker container as workers${NC}"
		echo

		sudo docker run -d -p 90${x}0:8080 --name "storm-master" -h  "storm-master" -m 512M --memory-swap 0M futureapplications/streaming-storm-master
		ipadressOfMaster=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' storm-master)
		ipadressZookeeper=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' zookeeper)


		sudo docker exec -d storm-master sed -i "s/@masterIp@/${ipadressOfMaster}/" /usr/local/storm/conf/storm.yaml 
		
	 	#Replace $ipadressZookeeper with $ipadressOfMaster if you want to run zookeeper on the same machine
		sudo docker exec -d storm-master sed -i "s/@zookeeperIp@/${ipadressZookeeper}/" /usr/local/storm/conf/storm.yaml 

		#Enable this if you want to start zookeeper and storm-master on the same machine
		#sudo docker exec -d storm-master /usr/local/zookeeper/bin/zkServer.sh start 
		
		sudo docker exec -d storm-master /usr/local/storm/bin/storm nimbus 
		sudo docker exec -d storm-master /usr/local/storm/bin/storm ui
		

		x=$(( x+1 ))
 		while [ "$x" -le "$3"  ]
 		do
		sudo docker run -d --name "storm-worker-${x}" -h  "storm-worker-${x}" -m 512M --memory-swap 0M futureapplications/streaming-storm-worker 
		
			
		sudo docker exec -d "storm-worker-${x}" sed -i "s/@masterIp@/${ipadressOfMaster}/" /usr/local/storm/conf/storm.yaml
		sudo docker exec -d "storm-worker-${x}" sed -i "s/@zookeeperIp@/${ipadressZookeeper}/" /usr/local/storm/conf/storm.yaml 
		sudo docker exec -d "storm-worker-${x}" /usr/local/storm/bin/storm supervisor

  		x=$(( x+1 ))	
 		done
		
		echo 
		printf  "${Blue}Pleas wait several minutes before you try to access the web-ui of the storm cluster( at least 2 min.).${NC}"
		echo
		exit
fi



echo "This operations are possible"
echo
echo "stop all container | stops all container"
echo
echo "kill all container | removes all container"
echo
echo "kill everything    | stops-removes all docker containers"
echo
echo "build all images   | builds all streaming-technologies images based on the Dockerfile" 
echo
echo "push all images    | pushs all images to the docker-hub. Destination -> futureapplications"
echo
echo "run cluster flink #numberOfMasters #numberOfWorkers | starts a flink cluster |- Right now only one master supported"
echo
echo "run cluster spark #numberOfMasters #numberOfWorkers | starts a spark cluster |- Right now only one master supported"
echo
echo "run cluster storm #numberOfMasters #numberOfWorkers | starts a storm cluster |- Right now only one master supported"




