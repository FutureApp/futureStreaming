#get kafka
wget http://mirror.softaculous.com/apache/kafka/0.8.2.1/kafka_2.10-0.8.2.1.tgz

# unpack
tar xf kafka_2.10-0.8.2.1.tgz
cd kafka_2.10-0. 8.2.1

#BigOne
./bin/kafka-topics.sh --create --topic test --zookeeper localhost:2181 --partitions 1 --replication-factor 1


# start zookeeper server
./bin/zookeeper-server-start.sh ./config/zookeeper.properties

# start broker
bin/kafka-server-start.sh ./config/server.properties 

# create topic �test�
bin/kafka-topics.sh --create --topic test --zookeeper 172.17.0.2:2181 --partitions 1 --replication-factor 1
192.168.1.135:9092
# consume from the topic using the console producer
docker exec -it bash kafka-console-consumer.sh --topic test --zookeeper 172.17.0.2:2181
bash /usr/local/kafka/bin/kafka-console-consumer.sh --topic results --zookeeper 172.17.0.2:2181

# produce something into the topic (write something and hit enter)
./bin/kafka-console-producer.sh --topic test --broker-list localhost:9092