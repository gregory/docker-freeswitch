FROM debian:wheezy

ENV DEBIAN_FRONTEND noninteractive
RUN echo 'deb http://files.freeswitch.org/repo/deb/debian/ wheezy main' >> /etc/apt/sources.list.d/freeswitch.list
RUN gpg --keyserver pool.sks-keyservers.net --recv-key D76EDC7725E010CF
RUN gpg -a --export D76EDC7725E010CF | apt-key add -
RUN apt-get upgrade -y && apt-get update && apt-get install -y freeswitch-meta-vanilla && apt-get clean
RUN cp -a /usr/share/freeswitch/conf/vanilla/ /etc/freeswitch

WORKDIR /etc/freeswitch
VOLUME ['/etc/freeswitch/']
EXPOSE 8021
CMD ['/usr/bin/freeswitch', '-c']
