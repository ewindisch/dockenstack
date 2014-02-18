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
RUN chown root:root /etc/sudoers.d/devstack

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
#
# Patch requirements to exclude pyghmi 0.5.9.1 pending merge:
# BUG(ewindisch): https://review.openstack.org/#/c/74246/
RUN mkdir -p /opt/dockenstack/cache
WORKDIR /opt/dockenstack/cache
RUN git clone https://github.com/openstack/requirements
RUN sed -i '/pyghmi.*/{ d; }' requirements/global-requirements.txt
RUN pip install -r requirements/global-requirements.txt
RUN pip install -r https://raw2.github.com/openstack/tempest/master/requirements.txt

# Pre-checkout git repos
RUN /bin/bash /opt/dockenstack/bin/openstack-git-checkout

# Copy in docker images
RUN mkdir -p /opt/dockenstack/images
WORKDIR /opt/dockenstack/images
RUN wget http://35d32e50e9d5a9dddd5f-7400ae4d3b198289837a7cdf652ffd5a.r94.cf1.rackcdn.com/cirros.img
RUN wget http://35d32e50e9d5a9dddd5f-7400ae4d3b198289837a7cdf652ffd5a.r94.cf1.rackcdn.com/registry.img
RUN chmod 644 /opt/dockenstack/images/*

WORKDIR /devstack
ADD localrc /devstack/localrc
ADD localrc.d /devstack/localrc.d

# Fix ownership of all files
RUN chown -R devstack /devstack

CMD ["/usr/local/bin/start"]
