LBlue='\033[1;34m'
NC='\033[0m' # No Color
iHome="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $iHome

if [ "$1" == "start eco-services" ]
	then 	
		bash ./serviceModules/zookeeper.sh "run zookeeper"
		bash ./serviceModules/kafka.sh "run kafka"
		exit 0
fi

if [ "$1" == "start spark-compose" ]
	then
	bash ./serviceModules/sparkVersionV2-compose.sh 
	exit 0
fi

if [ "$1" == "start sparkCluster" ] && [ -z != $2 ] && [ -z != $3 ] && [ -z != $4  ]
	then 	
	if [ $2 == "v2.0" ]
		then
		bash ./serviceModules/sparkVersionV2.0.sh $3 $4
		exit 0
	fi
	exit 0 
fi

if [ "$1" == "build image" ] && [ -z != $2 ]
	then 
	echo "building $2"
	docker build -t futureapplications/streaming-${2} ../../images/${2}/.
	exit 0
fi
if [ "$1" == "build all images" ]
	then 
	docker build -t futureapplications/streaming-basis ../../images/basis/. 
	docker build -t futureapplications/streaming-spark2.0-master ../../images/spark2.0/master/.
	docker build -t futureapplications/streaming-spark2.0-worker ../../images/spark2.0/worker/.
	docker build -t futureapplications/streaming-kafka ../../images/kafka/.
	docker build -t futureapplications/streaming-zookeeper ../../images/zookeeper/.
	#docker build -t futureapplications/streaming-mongo ../../images/mongo/.
	docker build -t futureapplications/spark-compose-2.0 ../../images/spark2.0-Compose/.
	exit 0
fi

if [ "$1" == "kill all container" ]
	then
	docker stop `docker ps -aq`
	docker rm `docker ps -aq`
	exit
fi
echo "ERROR Nothing to do. <$0>"
exit 2

