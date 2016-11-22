if [ "$1" == "kafka" ]
	then 	
	echo
    printf  "${LBlue}I'll run a docker container with kafka inside${NC}"
    
    echo
    sudo docker run -d -p 9092:9092 --name "kafka" -h  "kafka" -m 512M --memory-swap 0M futureapplications/streaming-kafka
    
    ipZookeeper=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' "zookeeper")	
    ipKafka=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' "kafka")
    
    
    # Get the current real host ID. Case: virtual machine
    echo $(ifconfig | grep 192.168.1 | awk '{print $2}') >ip
    sed -i "s/Adresse://" ip
    sed -i "s/addr://" ip
    hostRealAdress=$(cat ip)	
    rm ip		
    
    echo "I'll set the ZOOKEEPER_IP. This will be set <$ipZookeeper>"	
    sudo docker exec "kafka" sed -i "s/#IPADDRESS_ZOOKEEPER#/$ipZookeeper/" /usr/local/kafka/config/server.properties
    sudo docker exec "kafka" sed -i "s/#IPADDRESS_REALHOST#/$hostRealAdress/" /usr/local/kafka/config/server.properties
    
    sudo docker exec -d kafka /usr/local/kafka/bin/kafka-server-start.sh /usr/local/kafka/config/server.properties 
    
    echo 
    exit 0			
fi

echo "ERROR Nothing to do. $0"
exit 2