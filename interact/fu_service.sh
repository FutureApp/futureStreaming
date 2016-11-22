LBlue='\033[1;34m'
NC='\033[0m' # No Color

if [ "$1" == "stop all container" ]
	then
	sudo docker stop `sudo docker ps -aq`
	printf "${LBlue}all containers are stopped${NC}"
	exit
fi

if [ "$1" == "pause container" ] && [ -z != $2 ] 
	then
	sudo docker pause $2
	printf "${LBlue}container $2 is sleeping now${NC}"
	exit
fi

if [ "$1" == "unpause container" ] && [ -z != $2 ] 
	then
	sudo docker exec -it $2 bash
	printf "${LBlue}container $2 now running again ${NC}"
	exit
fi

if [ "$1" == "kill all container" ]
	then
	sudo docker stop `sudo docker ps -aq`
	sudo docker rm `sudo docker ps -aq`
	printf "${LBlue}All containers are offline now${NC}"
	exit
fi

if [ "$1" == "kill container" ] && [ -n "$2" ]
	then
	sudo docker stop $2
	sudo docker rm $2
	printf "${LBlue}All  containers are dead, now.${NC}"
	exit
fi

if [ "$1" == "kill everything" ] 
	then
	sudo docker stop `sudo docker ps -aq`
	sudo docker rm `sudo docker ps -aq`
	sudo docker rmi $(sudo docker images)
	printf "${LBlue}All containers and images are removed.${NC}"
	exit
fi

if [ "$1" == "connect to" ] && [ -z != $2 ] 
	then
	sudo docker exec -it $2 bash
	exit
fi

if [ "$1" == "'run sparkcluster" ] && [ -z != $2 ] && [ -z != $3 ] 
	then
	printf "${LBlue}Will start a spark-cluster with $2 master/s and $3 woker/s ${NC}"
	sudo docker exec -it $2 bash
	exit
fi


echo "------ System Commandos ------"
echo "'run sparkcluster' #numMasters #numWorkers >> This will starts a cluster with given parameters. In this context, the method will start 1 kafa-broaker and 1 zookeeper instance" 

echo 
echo "------ Docker Commandos ------"
echo "'connect to' #containerName 		  >> creates a connection to a specific container given by #containerName"  
echo "'unpause container ' #containerName >> unpauses a specific container given by #containerName."  
echo "'pause container' #containerName    >> pauses a specific container given by #containerName."  
echo "'stop all container' 				  >> stops all running container."
echo "'kill everything' 			      >> kills all running container and deletes all images"  
echo "'kill all container' 				  >> kills all running container."  
echo "'kill container' #containerName     >> kills a specific container given by #containerName."  




