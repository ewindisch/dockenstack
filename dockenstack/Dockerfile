# Eric Windisch '2014
# Forked from code by original author: Paul Czarkowski

FROM ubuntu:raring
MAINTAINER Eric Windisch "ewindisch@docker.com"

EXPOSE 80
EXPOSE 5000
EXPOSE 8773
EXPOSE 8774
EXPOSE 8776
EXPOSE 9292

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

RUN apt-get update
RUN apt-get install -qqv software-properties-common python-software-properties

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN apt-add-repository 'deb http://get.docker.io/ubuntu docker main'
RUN apt-get update

RUN apt-get -qqy install git socat curl sudo apt-transport-https vim lxc-docker

RUN echo 'mysql-server mysql-server/root_password password devstack' | debconf-set-selections
RUN echo 'mysql-server mysql-server/root_password_again password devstack' | debconf-set-selections
RUN apt-get -qqy install mysql-server

RUN apt-get -qqy install rabbitmq-server

# Setup devstack user
RUN useradd devstack && usermod -a -G docker devstack
ADD devstack.sudo /etc/sudoers.d/devstack
RUN chown root /etc/sudoers.d/devstack

# Local scripts
ADD wrapdocker /usr/local/bin/wrapdocker
ADD devstack-init /usr/local/bin/devstack-init
ADD start /usr/local/bin/start-devstack
ADD tempest /usr/local/bin/run-tempest
RUN chmod +x /usr/local/bin/start-devstack /usr/local/bin/wrapdocker /usr/local/bin/run-tempest /usr/local/bin/devstack-init

# Shared volume
VOLUME /var/lib/docker

#
# The below images will need to be regenerated periodically
# as they are dynamic dependencies.
#

# Install devstack scripts
RUN git clone https://github.com/openstack-dev/devstack /devstack

# Install prereq packages.
RUN /devstack/tools/install_prereqs.sh

# Requirements for pip-requirements
RUN apt-get install -qqy libffi-dev

# Install all pip requirements
RUN pip install -r https://raw2.github.com/openstack/requirements/master/global-requirements.txt
RUN pip install -r https://raw2.github.com/openstack/tempest/master/requirements.txt

# Copy in docker images
ADD http://get.docker.io/images/openstack/docker-ut.tar.gz /devstack/files/docker-ut.tar.gz
ADD http://get.docker.io/images/openstack/docker-registry.tar.gz /devstack/files/docker-registry.tar.gz
RUN chmod 644 /devstack/files/docker*.gz

ADD localrc /devstack/localrc
ADD localrc.d /devstack/localrc.d

# Fix ownership of all files
RUN chown -R devstack /devstack

CMD ["/usr/local/bin/start-devstack"]
