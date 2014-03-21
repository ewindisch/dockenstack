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
RUN apt-get -qqy install git socat curl sudo apt-transport-https vim wget

# Extra requirements for pip-requirements
RUN apt-get install -qqy libffi-dev

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
    wget --progress=dot:mega \
         http://35d32e50e9d5a9dddd5f-7400ae4d3b198289837a7cdf652ffd5a.r94.cf1.rackcdn.com/cirros.img
RUN umask 022; \
    wget --progress=dot:mega \
    http://35d32e50e9d5a9dddd5f-7400ae4d3b198289837a7cdf652ffd5a.r94.cf1.rackcdn.com/registry.img

# Setup devstack user
RUN mkdir -p /opt; \
    useradd -m -s /bin/bash -d /opt/stack devstack && \
    usermod -a -G docker devstack
ADD devstack.sudo /etc/sudoers.d/devstack
RUN chown root:root /etc/sudoers.d/devstack

# Local scripts
ADD scripts /opt/dockenstack/bin
RUN chmod 755 /opt/dockenstack/bin/*

# Install devstack scripts
RUN git clone https://github.com/openstack-dev/devstack /devstack

# Last known-working version of Devstack (before Docker was removed)
RUN cd /devstack; git checkout 3c78e080864c9b202132d8ce0e493933f3d2ab36

# Patch devstack
RUN /bin/bash /opt/dockenstack/bin/devstack-patches

# Install prereq packages.
RUN /devstack/tools/install_prereqs.sh

# Pre-download all "NOPRIME" packages
RUN /bin/bash /opt/dockenstack/bin/apt-cache-devstack

# Install all pip requirements
RUN pip install -r https://raw.github.com/openstack/requirements/master/global-requirements.txt
RUN pip install -r https://raw2.github.com/openstack/tempest/master/requirements.txt

# Pre-checkout git repos
RUN su devstack -c '/bin/bash /opt/dockenstack/bin/openstack-git-checkout'

WORKDIR /devstack
ADD localrc /devstack/localrc
ADD localrc.d /devstack/localrc.d

# Fix ownership of all files
RUN chown -R devstack /devstack

CMD ["/opt/dockenstack/bin/start"]
