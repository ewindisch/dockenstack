# Eric Windisch '2014
# Forked from code by original author: Paul Czarkowski

FROM ewindisch/dockenstack-base
MAINTAINER Eric Windisch "ewindisch@docker.com"

#
# The below images will need to be regenerated periodically
# as they are dynamic dependencies.
#

# Setup devstack user
RUN useradd devstack && usermod -a -G docker devstack
ADD devstack.sudo /etc/sudoers.d/devstack

# Local scripts
ADD scripts /opt/dockenstack/bin

# Install devstack scripts
RUN git clone https://github.com/openstack-dev/devstack /devstack

# Install prereq packages.
RUN /devstack/tools/install_prereqs.sh

# Pre-download all "NOPRIME" packages
RUN /opt/dockenstack/bin/apt-cache-devstack

# Requirements for pip-requirements
RUN apt-get install -qqy libffi-dev

# Install all pip requirements
RUN pip install -r https://raw2.github.com/openstack/requirements/master/global-requirements.txt
RUN pip install -r https://raw2.github.com/openstack/tempest/master/requirements.txt

# Copy in docker images
RUN mkdir -p /opt/dockenstack/images
ADD http://get.docker.io/images/openstack/docker-ut.tar.gz /opt/dockenstack/images/busybox.tar.gz
# Comment this out until we can update the registry image!
#ADD http://get.docker.io/images/openstack/docker-registry.tar.gz /opt/dockenstack/images/registry.tar.gz
RUN chmod 644 /opt/dockenstack/images/*

ADD localrc /devstack/localrc
ADD localrc.d /devstack/localrc.d

# Fix ownership of all files
RUN chown -R devstack /devstack

CMD ["/usr/local/bin/start-devstack"]
