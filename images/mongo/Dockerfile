FROM futureapplications/streaming-basis
MAINTAINER Michael Czaja


RUN echo 'y' | sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
RUN echo 'y' | apt-get update
RUN apt-get install -y mongodb-org

ADD default.ini /etc/mongod.conf

EXPOSE 27017

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"