if [ "$1" == "run zookeeper" ]
	then 	
		echo
		printf  "${LBlue}I'll run a docker container with zookeeper inside${NC}"
		echo
		 docker run -d -p 2181:2181 --name "zookeeper" -h  "zookeeper" -m 512M --memory-swap 0M futureapplications/streaming-zookeeper
		echo 
		exit 0		
fi

echo "ERROR Nothing to do. $0"
exit 2