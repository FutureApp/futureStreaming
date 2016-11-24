FROM futureapplications/streaming-basis
MAINTAINER Michael Czaja

#add passless key to ssh
RUN ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 777 ~/.ssh/*
RUN echo "root:root" | chpasswd

##zookeeper-3.4.8 Installation
###Download:
RUN mkdir ~/downloads && cd ~/downloads && \
    wget -q -O - http://apache.lauf-forum.at/zookeeper/stable/zookeeper-3.4.9.tar.gz | tar -zxvf - -C /usr/local/

RUN cd /usr/local && ln -s ./zookeeper-3.4.8 zookeeper 


ENV ZK_HOME /usr/local/zookeeper
ENV PATH $PATH:$ZK_HOME/bin

ADD zookeeper.ini /usr/local/zookeeper/conf/zoo.cfg

EXPOSE 2181

CMD exec /bin/bash -c "bash /usr/local/zookeeper/bin/zkServer.sh start;trap : TERM INT; sleep infinity & wait"






