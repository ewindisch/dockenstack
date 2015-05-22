# Eric Windisch '2014
# Forked from code by original author: Paul Czarkowski

FROM ubuntu:trusty
MAINTAINER Eric Windisch "ewindisch@docker.com"

EXPOSE 80 5000 8773 8774 8776 9292
# Set DEBIAN_FRONTEND to avoid warning like "debconf: (TERM is not set, so the dialog frontend is not usable.)"
ENV DEBIAN_FRONTEND="noninteractive"
# Install Docker
RUN apt-get install -qqy apt-transport-https; apt-key adv --keyserver "hkp://keyserver.ubuntu.com:80" --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9; \
    echo 'deb http://get.docker.io/ubuntu docker main' > /etc/apt/sources.list.d/docker.list; \
    apt-get update; \
    apt-get install -qqy lxc-docker

# Install utilities
RUN apt-get -qqy install git socat curl sudo vim wget net-tools

# Install apparmor
RUN apt-get -qqy install apparmor

# Extra requirements for pip-requirements
RUN apt-get install -qqy libffi-dev libkrb5-dev libev-dev libvirt-dev libsqlite3-dev libxml2-dev libxslt-dev \ 
    libpq-dev libssl-dev libyaml-dev


# Configure and install MySQL
RUN echo 'mysql-server mysql-server/root_password password devstack' | debconf-set-selections; \
    echo 'mysql-server mysql-server/root_password_again password devstack' | debconf-set-selections; \
    apt-get -qqy install mysql-server

# Install RabbitMQ
RUN apt-get -qqy install rabbitmq-server

# Copy in docker images
RUN docker -d -b none -s vfs & sleep 1; docker pull cirros

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

# Install prereq packages.
RUN /devstack/tools/install_prereqs.sh

# Pre-download all "NOPRIME" packages
RUN /bin/bash /opt/dockenstack/bin/apt-cache-devstack

# Install/configure dbus for libvirt (only needed if using libvirt drivers, not docker)
# creates symlink to /usr/bin due to bug in saucy's init script for dbus.
RUN apt-get install -q -y dbus; \
    ln -s /bin/dbus-daemon /usr/bin/dbus-daemon

# Mask python-six because the apt package can conflict with the pypi version.
RUN apt-get remove -q -y python-six

# python-pip just became collatoral damage.  reinstall it.
RUN apt-get install -q -y python-pip

# Install six from pip before getting from global-requirements (due to bugs...)
RUN pip install six

# Install all pip requirements
RUN pip install -r https://raw.github.com/openstack/requirements/master/global-requirements.txt
RUN pip install -r https://raw.github.com/openstack/tempest/master/requirements.txt

# Pre-checkout git repos
RUN su devstack -c '/bin/bash /opt/dockenstack/bin/openstack-git-checkout'

RUN git clone https://github.com/stackforge/nova-docker /opt/stack/nova-docker
WORKDIR /opt/stack/nova-docker
RUN cp contrib/devstack/extras.d/70-docker.sh /devstack/extras.d/; \
    cp contrib/devstack/lib/nova_plugins/hypervisor-docker /devstack/lib/nova_plugins/;

WORKDIR /devstack
ADD localrc /devstack/localrc
ADD localrc.d /devstack/localrc.d

WORKDIR /
# Fix ownership of all files
RUN chown -R devstack /devstack

CMD ["/opt/dockenstack/bin/start"]
