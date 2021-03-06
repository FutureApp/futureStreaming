LBlue='\033[1;34m'
NC='\033[0m' # No Color
iHome="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $iHome

if [ "$1" == "start eco-services" ]
	then 	
		printf "${LBlue}Try to start the eco-system.${NC}"
		bash ./service/iService.sh "start eco-services"
		echo "INFO - Starting eco-system - Finished!"
		exit 0
fi

if [ "$1" == "build all images" ]
	then 
	bash ./service/iService.sh "build all images"
	echo "INFO - Building all images - Finished!" 
	echo "$i < i"
	exit 0
fi

if [ "$1" == "build image" ] && [ -z != $2 ]
	then 
	bash ./service/iService.sh "build image" $2
	echo "INFO - Building image $2 - Finished"
	exit 0
fi

if [ "$1" == "kill all container" ]
	then
	bash ./service/iService.sh "$1"
	echo "INFO - Shutdown all Container - Finished "
	exit 0
fi

if [ "$1" == "start spark-compose" ]  
	then
	echo "INFO - Starting spark cluster with docker comopse"
	bash ./service/iService.sh $1
	echo "INFO - Starting spark-cluster v2.0  with docker compose - Finished"
	exit 0
fi

if [ "$1" == "start sparkCluster" ] && [ -z != $2 ] && [ -z != $3 ] && [ -z != $4  ]
	then 	
	if [ "$2" == "v2.0" ]
		then
		printf "${LBlue}Try to run spark-cluster with spark core $1; $3 master/s and $4 worker/s${NC}"
		bash ./service/iService.sh "$1" $2 $3 $4
		echo "INFO - Starting spark cluster v2.0 - Finished"
		exit 0
	fi  
fi




echo
echo "ERROR $0"
exit 2