LBlue='\033[1;34m'
NC='\033[0m' # No Color

if [ "$1" == "start sparkCluster" ] && [ -z != $2 ] && [ -z != $3 ] && [ -z != $4 ] 
	then
	bash ./fu_service_functions.sh "start eco-services"
	bash ./fu_service_functions.sh $1 $2 $3 $4
	exit 0
fi

if [ "$1" == "start spark-compose" ]  
	then
	bash ./fu_service_functions.sh $1
	exit 0
fi

#echo "------ System Commandos ------"
#echo "'run sparkcluster' #versionCore #numMasters #numWorkers >> This will starts a cluster with given parameters. Will start also 1 kafa-broker and 1 zookeeper instance." 
#
#echo 
#echo "------ Docker Commandos ------"
#echo "'connect to' #containerName 		  >> creates a connection to a specific container given by #containerName"  
#echo "'unpause container ' #containerName >> unpauses a specific container given by #containerName."  
#echo "'pause container' #containerName    >> pauses a specific container given by #containerName."  
#echo "'stop all container' 				  >> stops all running container."
#echo "'kill everything' 			      >> kills all running container and deletes all images"  
#echo "'kill all container' 				  >> kills all running container."  
#echo "'kill container' #containerName     >> kills a specific container given by #containerName."  