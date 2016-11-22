FROM futureapplications/streaming-basis
MAINTAINER Michael Czaja

#add passless key to ssh
RUN ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 777 ~/.ssh/*
RUN echo "root:root" | chpasswd

###Download:
RUN mkdir ~/downloads && cd ~/downloads && \
    wget -q -O - http://apache.mirror.digionline.de/kafka/0.8.2.2/kafka_2.11-0.8.2.2.tgz | tar -zxvf - -C /usr/local/

RUN cd /usr/local && ln -s ./kafka_2.11-0.8.2.2 kafka 
RUN mkdir /usr/local/results


ENV KAFKA_HOME /usr/local/kafka
ENV PATH $PATH:$KAFKA_HOME/bin

ADD kafka.ini /usr/local/kafka/config/server.properties

EXPOSE 9092

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"






