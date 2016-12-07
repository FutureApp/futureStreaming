FROM futureapplications/streaming-basis
MAINTAINER Michael Czaja


RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' |  tee /etc/apt/sources.list.d/mongodb.list
RUN apt-get update
RUN apt-get install mongodb-10gen = 2.2.3
RUN service mongodb start

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"