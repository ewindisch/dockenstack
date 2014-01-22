# Installs runit for service management
#
# Author: Paul Czarkowski
# Date: 10/20/2013


FROM paulczar/raring-cloud-img
MAINTAINER Paul Czarkowski "paul.czarkowski@rackspace.com"

EXPOSE 80
EXPOSE 5000
EXPOSE 8773
EXPOSE 8774
EXPOSE 8776
EXPOSE 9292

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

RUN apt-get update
RUN apt-get install -qqv software-properties-common

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
ADD start /usr/local/bin/start-devstack
ADD tempest /usr/local/bin/run-tempest
RUN chmod +x /usr/local/bin/start-devstack /usr/local/bin/wrapdocker /usr/local/bin/run-tempest

# Shared volume
VOLUME /var/lib/docker

#
# The below images will need to be regenerated periodically
# as they are dynamic dependencies.
#

# Extracted from devstack
RUN apt-get install -qqy bridge-utils pylint python-setuptools screen unzip wget psmisc git lsof openssh-server openssl vim-nox locate python-virtualenv python-unittest2 iputils-ping wget curl tcpdump euca2ools tar python2.7 gcc libxml2-dev python-dev python-eventlet python-routes python-greenlet python-sqlalchemy python-wsgiref python-pastedeploy python-xattr python-iso8601 python-dev python-lxml python-pastescript python-pastedeploy python-paste sqlite3 python-pysqlite2 python-sqlalchemy python-mysqldb python-webob python-greenlet python-routes libldap2-dev libsasl2-dev python-dateutil msgpack-python dnsmasq-base dnsmasq-utils kpartx parted iputils-arping python-mysqldb python-xattr python-lxml gawk iptables ebtables sqlite3 sudo libjs-jquery-tablesorter vlan curl genisoimage socat python-mox python-paste python-migrate python-gflags python-greenlet python-libxml2 python-routes python-numpy python-pastedeploy python-eventlet python-cheetah python-carrot python-tempita python-sqlalchemy python-suds python-lockfile python-m2crypto python-boto python-kombu python-feedparser python-iso8601 nbd-client lvm2 open-iscsi genisoimage sysfsutils sg3-utils tgt lvm2 qemu-utils libpq-dev python-dev open-iscsi python-numpy python-beautifulsoup python-dateutil python-paste python-pastedeploy python-anyjson python-routes python-xattr python-sqlalchemy python-webob python-kombu pylint python-eventlet python-nose python-sphinx python-mox python-kombu python-coverage python-cherrypy3 python-migrate libxslt1-dev

# Requirements for pip-requirements
RUN apt-get install -qqy libffi-dev

# Install all pip requirements
RUN pip install -r https://raw2.github.com/openstack/requirements/master/global-requirements.txt

# Install devstack scripts
RUN git clone https://github.com/openstack-dev/devstack /devstack

# Copy in docker images
ADD http://get.docker.io/images/openstack/docker-ut.tar.gz /devstack/files/docker-ut.tar.gz
ADD http://get.docker.io/images/openstack/docker-registry.tar.gz /devstack/files/docker-registry.tar.gz
RUN chmod 644 /devstack/files/docker*.gz

# Fix ownership of all files
RUN chown -R devstack /devstack

ADD localrc /devstack/localrc

CMD ["/usr/local/bin/start-devstack"]
