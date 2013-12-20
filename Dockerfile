# Installs runit for service management
#
# Author: Paul Czarkowski
# Date: 10/20/2013


FROM paulczar/raring-cloud-img
MAINTAINER Paul Czarkowski "paul.czarkowski@rackspace.com"

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

RUN apt-get update
RUN apt-get install -qqy ca-certificates wget
RUN wget -qO- https://get.docker.io/gpg | apt-key add -
RUN echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-get update

RUN apt-get -qqy install git socat curl sudo apt-transport-https vim lxc-docker

RUN echo 'mysql-server mysql-server/root_password password devstack' | debconf-set-selections
RUN echo 'mysql-server mysql-server/root_password_again password devstack' | debconf-set-selections
RUN apt-get -qqy install mysql-server

RUN apt-get -qqy install rabbitmq-server

RUN useradd devstack && usermod -a -G docker devstack

ADD devstack.sudo /etc/sudoers.d/devstack

RUN chown root /etc/sudoers.d/devstack

ADD https://github.com/openstack-dev/devstack/archive/master.tar.gz /devstack.tgz

RUN cd / && tar xzvf devstack.tgz

RUN mv /devstack-master /devstack

ADD localrc /devstack/localrc
ADD wrapdocker /usr/local/bin/wrapdocker
ADD start /devstack/start
ADD prepare /devstack/prepare

RUN chmod +x /devstack/start /devstack/prepare /usr/local/bin/wrapdocker

RUN chown -R devstack /devstack

VOLUME /var/lib/docker


EXPOSE 80
EXPOSE 5000
EXPOSE 8773
EXPOSE 8774
EXPOSE 8776
EXPOSE 9292

CMD ["/devstack/start"]
