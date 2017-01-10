FROM futureapplications/streaming-basis
MAINTAINER Michael Czaja

#add passless key to ssh
RUN ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && chmod 777 ~/.ssh/*
RUN echo "root:root" | chpasswd

##Storm 1.0.2 Installation
###Download:
RUN mkdir ~/downloads && cd ~/downloads && \
    wget -q -O - http://archive.apache.org/dist/spark/spark-2.0.0/spark-2.0.0-bin-hadoop2.6.tgz | tar -zxvf - -C /usr/local/

RUN cd /usr/local && ln -s ./spark-2.0.0-bin-hadoop2.6 spark 



RUN cd ~/downloads && \
    wget -q -O - http://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.tgz | tar -zxvf - -C /usr/local/
RUN cd /usr/local && ln -s ./scala-2.11.8 scala 


ENV SCALA_HOME /usr/local/scala
ENV SPARK_HOME /usr/local/spark


ENV PATH $PATH:$SPARK_HOME/bin
ENV PATH $PATH:$SCALA_HOME/bin

EXPOSE

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"






