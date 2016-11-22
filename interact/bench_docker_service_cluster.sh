iHome="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LBlue='\033[1;34m'
NC='\033[0m' # No Color

x=0

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

if [ "$1" == "createTopicAndProducer" ]
	then 	
		echo
		printf  "${LBlue}I'll run createTopicAndProducer ${NC}"

		bash /usr/local/kafka/bin/kafka-topics.sh --create --topic test --zookeeper 172.17.0.3:2181 --partitions 1 --replication-factor 1
		bash /usr/local/kafka/bin/kafka-console-producer.sh --topic test --broker-list 172.17.0.2:9092
		bash /usr/local/kafka/bin/kafka-console-consumer.sh --topic test --zookeeper 172.17.0.3:2181
				
		echo 
		exit		
fi

		


if [ "$1" == "run kafka" ]
	then 	
		echo
		printf  "${LBlue}I'll run a docker container with kafka inside${NC}"
		echo
		
		
		sudo docker exec -d flink-master /usr/local/kafka/bin/kafka-server-start.sh /usr/local/kafka/config/server.properties 
		

		echo 
		exit		
fi



if [ "$1" == "run zookeeper" ]
	then 	
		echo
		printf  "${LBlue}I'll run a docker container with zookeeper inside${NC}"
		echo
		
		sudo docker run -d -p 2181:2181 --name "zookeeper" -h  "zookeeper" -m 512M --memory-swap 0M futureapplications/streaming-zookeeper
		
		echo 
		exit		
fi

if [ "$1" == "build kafka-image" ]
	then 	
		echo
		printf "${LBlue}I'll build the kafka image${NC}"
		sudo docker build -t futureapplications/streaming-kafka $iHome/../kafka/.
		
		echo 
		exit		
fi


if [ "$1" == "restart kafka" ]
	then 	
		echo
		printf  "${LBlue}I'll run a docker container with kafka inside${NC}"

		sudo bash ./bench_docker_cluster_interface.sh "kill container" "kafka"
		sudo bash ./bench_docker_service_cluster.sh "build kafka-image"
		sudo bash ./bench_docker_service_cluster.sh "run kafka"
		
		echo 
		exit		
fi

if [ "$1" == "restart zookeeper" ]
	then 	
		echo
		printf  "${LBlue}I'll run a docker container with zookeeper inside${NC}"
		sudo bash ./bench_docker_cluster_interface.sh "kill container" "zookeeper"
		sudo bash ./bench_docker_service_cluster.sh "build zookeeper-image"
		sudo bash ./bench_docker_service_cluster.sh "run zookeeper"
		
		echo 
		exit		
fi


if [ "$1" == "build zookeeper-image" ]
	then 	
		echo
		printf "${LBlue}I'll build the zookeeper image${NC}"
		echo
		
		sudo docker build -t futureapplications/streaming-zookeeper $iHome/../zookeeper/.
		
		echo 
		exit		
fi


if [ "$1" == "set topic" ] && [ -z != $2 ]
	then 	
		echo
		printf "${LBlue}I'll set the topic $2 on kafka${NC}"
		echo 
			
			
		zookeeper=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' "zookeeper")	
		sudo docker exec -it kafka /usr/local/kafka/bin/kafka-topics.sh --create --topic "$2" --zookeeper $zookeeper:2181 --partitions 1 --replication-factor 1
				
		echo 
		exit		
fi

if [ "$1" == "connect to kafka" ]
	then 	
		echo
		printf "${LBlue}I'll connect you to the container named kafka${NC}"
		sudo docker exec -it kafka bash
		
		echo 
		exit		
fi

if [ "$1" == "start result-listener" ]  && [ -z != $2 ]
then 	
		echo
		printf "${LBlue}Start to collect data from topic results on kafka in kafka${NC}"
		ipZookeeper=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' "zookeeper")	
		#sudo docker exec -it kafka bash /usr/local/results/startListenerAndSaveResults.sh 172.17.0.2 res 
		sudo docker exec -d kafka bash /usr/local/results/startListenerAndSaveResults.sh $ipZookeeper $2 
			
		echo 
		exit		
fi


if [ "$1" == "restart redis" ]
	then 	
		echo
		printf  "${LBlue}I'll run a docker container with redis inside${NC}"
		echo
		
		sudo bash ./bench_docker_cluster_interface.sh "kill container" "redis"
		sudo bash ./bench_docker_service_cluster.sh "build redis-image"
		sudo bash ./bench_docker_service_cluster.sh "run redis"
		
		echo 
		exit		
fi

		
if [ "$1" == "run redis" ]
	then 	
		echo
		printf  "${LBlue}I'll run a docker container with redis inside${NC}"
		echo
		#sudo docker run -d -p 6379:6379 --name "redis" -h  "redis" futureapplications/streaming-redis
		
		echo 
		exit		
fi
if [ "$1" == "run emit" ]
	then 	
		echo
		printf  "${LBlue}I'll run a docker container with emit inside${NC}"
		echo
		sudo docker run -d --name "emit" -h  "emit" -m 512M --memory-swap 0M futureapplications/streaming-emit
		
		echo 
		exit		
fi


if [ "$1" == "start to emit data" ] && [ -z != $2 ] && [ -z != $3 ] && [ -z != $4 ] && [ -z != $5 ] && [ -z != $6 ] 
	then 	
		echo
		printf "${LBlue}I'll start to emit the data for testreason${NC}"
		echo 
			
			
		kafka=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' "kafka")	
		home=/usr/local/emit
		
		sudo docker exec -d emit java -jar $home/emitDataToKafka.jar $2 $3 $home/$4 $5 $home/$6
				
		echo 
		exit		
fi	



if [ "$1" == "build redis-image" ]
	then 	
		echo
		printf "${LBlue}I'll build the redis image${NC}"
		sudo docker build -t futureapplications/streaming-redis $iHome/../redis/.
		
		echo 
		exit		
fi

if [ "$1" == "connect to redis" ]
	then 	
		echo
		printf "${LBlue}I'll connect you to the container named redis${NC}"
		echo 
		sudo docker exec -it redis bash
		
		echo 
		exit		
fi


if [ "$1" == "connect to" ] && [ -z != $2 ]
	then 	
		echo
		printf "${LBlue}I'll connect you to the container named $2${NC}"
		echo 
		sudo docker exec -it $2 bash
		
		echo 
		exit		
fi

if [ "$1" == "connect producer" ]
	then 	
		echo
		printf "${LBlue}I'll run up the producer for kafka on kafka-container${NC}"
		echo 
			
			
		kafka=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' "kafka")	
		sudo docker exec -it kafka /usr/local/kafka/bin/kafka-console-producer.sh --topic test --broker-list $kafka:9092
				
		echo 
		exit		
fi	

	if [ "$1" == "connect consumer" ]
	then 	
		echo
		printf "${LBlue}I'll run up the consumer for kafka on kafka-container${NC}"
		echo 
			
			
		zookeeper=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' "zookeeper")	
		sudo docker exec -it kafka /usr/local/kafka/bin/kafka-console-consumer.sh --topic test --zookeeper  $zookeeper:2181	
		echo 
		exit		
fi	
			
if [ "$1" == "print IP_ADRESSES" ]
	then 	
		echo
		printf "${LBlue}Here are your services: zookeeper,kafka and redis${NC}"
		echo 
		echo "----"
			
		echo "IP_ADDRESS of ZOOKEEPER   : " $(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' "zookeeper")
		echo "IP_ADDRESS of KAFKA	  : " $(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' "kafka")
		echo "IP_ADDRESS of REDIS	  : " $(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' "redis")
		
		echo "----"
		echo 
		exit		
fi







