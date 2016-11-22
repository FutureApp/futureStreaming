if [ "$1" == "zookeeper&kafa" ]
	then 	
		echo
		printf "${LBlue}Here are your services: zookeeper and kafka ${NC}"
		echo 
		echo "----"
		echo "IP_ADDRESS of ZOOKEEPER   : " $(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' "zookeeper")
		echo "IP_ADDRESS of KAFKA	  : " $(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' "kafka")
		echo "----"
		echo 
		exit 0		
fi

echo "ERROR Nothing to do. $0"
exit 1