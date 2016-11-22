if [ "$1" == "start eco-services" ]
	then 	
		sudo bash ./services/zookeeper.sh "run zookeeper"
		sudo bash ./services/kafka.sh "run kafka"
		exit 0
fi

if [ "$1" == "print IPs" ]
	then 	
		sudo bash ./services/printIPAddresses.sh "zookeeper&kafka"
		exit 0
fi

echo "ERROR Nothing to do. $0"
exit 2

