FROM debian:wheezy

ENV FREESWITCH_PATH /opt/freeswitch
ENV FREESWITCH_SRC_PATH /usr/local/src/freeswitch

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y -qq update
RUN apt-get install -y --no-install-recommends autoconf automake devscripts gawk g++ wget git-core libjpeg-dev libncurses5-dev libtool make python-dev gawk pkg-config libtiff5-dev libperl-dev libgdbm-dev libdb-dev gettext libssl-dev libcurl4-openssl-dev libpcre3-dev libspeex-dev libspeexdsp-dev libsqlite3-dev libedit-dev libldns-dev libpq-dev
ENV DEBIAN_FRONTEND dialog

RUN GIT_SSL_NO_VERIFY=true git clone -b v1.4 https://stash.freeswitch.org/scm/fs/freeswitch.git ${FREESWITCH_SRC_PATH}
WORKDIR /usr/local/src/freeswitch
ADD conf/modules.conf .
RUN ./bootstrap.sh -j && ./configure --prefix=${FREESWITCH_PATH} && make && make install && export PATH=$PATH:${FREESWITCH_PATH}/bin

RUN dpkg --purge build-essential autoconf automake libtool libjpeg-dev libncurses5-dev libssl-dev libcurl4-openssl-dev python-dev libexpat1-dev libtiff4-dev libx11-dev libavcodec-dev libavdevice-dev libavfilter-dev libavformat-dev libavutil-dev libavbin-dev libsofia-sip-ua-dev libvpx-dev libfreetype6-dev libjpeg-turbo8-dev erlang-dev uuid-dev libgdbm-dev ladspa-sdk libflac-dev libvlc-dev gcj-jdk libyaml-dev pkg-config libssl-dev unixodbc-dev libpq-dev  python-dev erlang-dev doxygen uuid-dev libexpat1-dev libgdbm-dev libdb-dev bison  libogg-dev libasound2-dev libasound2-dev libx11-dev libpq-dev erlang-dev libsnmp-dev libflac-dev libogg-dev libvorbis-dev libvlc-dev default-jdk libperl-dev python-dev libyaml-dev libsqlite3-dev libpcre3-dev libspeex-dev libspeexdsp-dev libldns-dev libedit-dev libpq-dev libmemcached-dev python2.7-dev libgnutls-dev libidn11-dev comerr-dev librtmp-dev krb5-multidev libgnutls-dev libkrb5-dev &&\
   rm -fr ${FREESWITCH_SRC_PATH} && apt-get clean

env PATH /opt/freeswitch/bin:$PATH

RUN useradd --system --home-dir ${FREESWITCH_PATH} --comment "FreeSWITCH Voice Platform" --groups daemon freeswitch &&\
  chown -R freeswitch:daemon ${FREESWITCH_PATH} &&\
  chmod -R ug=rwX,o= ${FREESWITCH_PATH} &&\
  chmod -R u=rwx,g=rx ${FREESWITCH_PATH}/bin/*

WORKDIR /opt/freeswitch/conf
VOLUME ['/opt/freeswitch/conf']
EXPOSE 8021
CMD    /opt/freeswitch/bin/freeswitch -c
