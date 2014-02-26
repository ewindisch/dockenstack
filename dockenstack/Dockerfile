# Eric Windisch '2014
# Forked from code by original author: Paul Czarkowski

FROM ubuntu:raring
MAINTAINER Eric Windisch "ewindisch@docker.com"

EXPOSE 80 5000 8773 8774 8776 9292

# Install Docker
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9; \
    echo 'deb http://get.docker.io/ubuntu docker main' > /etc/apt/sources.list.d/docker.list; \
    apt-get update; \
    apt-get install -qqy lxc-docker

# Install utilities
RUN apt-get -qqy install git socat curl sudo apt-transport-https vim

# Configure and install MySQL
RUN echo 'mysql-server mysql-server/root_password password devstack' | debconf-set-selections; \
    echo 'mysql-server mysql-server/root_password_again password devstack' | debconf-set-selections; \
    apt-get -qqy install mysql-server

# Install RabbitMQ
RUN apt-get -qqy install rabbitmq-server

# Copy in docker images
RUN mkdir -m 755 -p /opt/dockenstack/images
WORKDIR /opt/dockenstack/images
RUN umask 022; \
    wget http://35d32e50e9d5a9dddd5f-7400ae4d3b198289837a7cdf652ffd5a.r94.cf1.rackcdn.com/cirros.img
RUN umask 022; \
    wget http://35d32e50e9d5a9dddd5f-7400ae4d3b198289837a7cdf652ffd5a.r94.cf1.rackcdn.com/registry.img

# Setup devstack user
RUN useradd devstack && usermod -a -G docker devstack
ADD devstack.sudo /etc/sudoers.d/devstack
RUN chown root:root /etc/sudoers.d/devstack

RUN mkdir -m 755 -p /opt/stack; \
    chown devstack:devstack /opt/stack

# Local scripts
ADD scripts /opt/dockenstack/bin
RUN chmod 755 /opt/dockenstack/bin/*

# Install devstack scripts
RUN git clone https://github.com/openstack-dev/devstack /devstack

# Patch devstack
RUN /bin/bash /opt/dockenstack/bin/devstack-patches

# Install prereq packages.
RUN /devstack/tools/install_prereqs.sh

# Pre-download all "NOPRIME" packages
RUN /bin/bash /opt/dockenstack/bin/apt-cache-devstack

# Requirements for pip-requirements
RUN apt-get install -qqy libffi-dev

# Install all pip requirements
RUN pip install -r https://github.com/openstack/requirements/commits/master/global-requirements.txt
RUN pip install -r https://raw2.github.com/openstack/tempest/master/requirements.txt

# Pre-checkout git repos
RUN su devstack -c '/bin/bash /opt/dockenstack/bin/openstack-git-checkout'

WORKDIR /devstack
ADD localrc /devstack/localrc
ADD localrc.d /devstack/localrc.d

# Fix ownership of all files
RUN chown -R devstack /devstack

CMD ["/opt/dockenstack/bin/start"]
