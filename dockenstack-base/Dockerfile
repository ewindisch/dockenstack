# Eric Windisch '2014
# Forked from code by original author: Paul Czarkowski

FROM ubuntu:raring
MAINTAINER Eric Windisch "ewindisch@docker.com"

EXPOSE 80 5000 8773 8774 8776 9292

RUN apt-get update
RUN apt-get install -qqy software-properties-common

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN apt-add-repository 'deb http://get.docker.io/ubuntu docker main'
RUN apt-get update

RUN apt-get -qqy install git socat curl sudo apt-transport-https vim lxc-docker

RUN echo 'mysql-server mysql-server/root_password password devstack' | debconf-set-selections
RUN echo 'mysql-server mysql-server/root_password_again password devstack' | debconf-set-selections
RUN apt-get -qqy install mysql-server

RUN apt-get -qqy install rabbitmq-server
