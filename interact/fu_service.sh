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


echo "------ Usage ------"
echo " 'top all container' > stops all running container"
echo "stop all container "

