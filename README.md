# Docker on Openstack on Docker on Vagrant

Running Openstack with the Docker driver in a Docker container.

running Docker in Docker requires running docker in privileged mode.  This means the meat of the install has to happen in the `docker run` rather than `docker build`.  This means it takes a long time to run,  but once it's finally done you'll have a fully working openstack running in the container.

Because so much stuff is going on here it can take some time to Build/Run.  I cheated a little bit with the `paulczar/dockenstack` container to help speed this up,  but can still take 2-3mins on a fast machine.

# Fetch

```
https://github.com/paulczar/dockenstack.git
cd dockenstack
```

# Ubuntu with Docker

## Build

```
docker build -t dockstack .
```

## Run

### Self built

This takes quite a long time... as it has to do a full devstack install.

```
docker run -privileged -lxc-conf=aa_profile=unconfined -t -i dockenstack
```

### From index.docker.io

This is quicker!

```
docker run -privileged -lxc-conf=aa_profile=unconfined -t -i paulczar/dockenstack
```

# Vagrant with Docker

## Requirements

* vagrant >= 1.3
* virtualbox

```
vagrant plugin install vagrant-omnibus
vagrant plugin install vagrant-berkshelf
```

## Build

```
vagrant up
cd /vagrant
docker build -t dockenstack .
```

## Run

```
vagrant up
vagrant ssh
sudo docker run -privileged -lxc-conf="aa_profile=unconfined" \
    -t -i [paulczar/dockenstack|dockenstack]
```

# Using

if you've started dockenstack interactively you'll end up with a shell and can run these steps immediately.   Otherwise you'll have to attach to the container once running.  ( or access via Horizon/APIs [not covered here])

```
source /devstack/openrc
nova boot --image docker-busybox:latest --flavor 1 test
nova list
docker ps
```


# Authors

* Paul Czarkowski

# License

Apache2 - see `LICENSE`
