LBlue='\033[1;34m'
NC='\033[0m' # No Color

if [ "$1" == "start eco-services" ]
	then 	
	if [ "$2" == "2.0" ]
		printf "${LBlue}Try to run spark-cluster with spark core $2, with $3 master/s and $4 worker/s"
		bash ../serviceInteraction/services.sh "start eco-services"
		exit 0 
fi

if [ "$1" == "run sparkCluster" ] && [ -z != $2 ] && [ -z != $3 ] && [ -z != $4  ]
	then 	
	if [ "$2" == "2.0" ]
		printf "${LBlue}Try to run spark-cluster with spark core $2, with $3 master/s and $4 worker/s"
		bash ./sparkModules/sparkVersionV2.sh $3 $4
		exit 0  
fi

echo "ERROR Nothing to do. $0"
exit 2