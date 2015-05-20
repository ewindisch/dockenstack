# Openstack on Docker

Dockenstack builds an image for running OpenStack's devstack development and testing environment inside of a Docker container. This image currently supports running the docker and libvirt-lxc virtualization drivers for Nova. KVM/Qemu support is being tested.

Using dockenstack, developers may quickly iterate changes in a container and locally invoke functional tests without needing to first submit their changes for code-review.

The quick iteration cycle of dockenstack versus other local environments (such as devstack-vagrant) is accomplished by precaching and preinstalling most or all network resources and OS packages. This speeds up running the container and, when running many, eliminates the problems that might result from offline or rate-limited apt and pip services.

Users may expect dockenstack to take 2-4 minutes on a fast machine from "docker run" through having an operational OpenStack installation.

# Build & Run

## Quickstart: Using Docker Compose

```
$ git clone https://github.com/ewindisch/dockenstack.git
$ cd dockenstack
$ docker-compose up
```

This will automatically build a Dockenstack image and run OpenStack.

The first run will take a long time due to the length process of
building the Docker image (~60m). Subsequent runs of this image will be
quicker (~5m). Even faster, of course, is restarting a container.

## Alternative Install: Building Manually

The following is the process undertaken by Docker Compose.
Building the image may take approximately 60 minutes.

```
git clone https://github.com/ewindisch/dockenstack.git
cd dockenstack
docker build -t ewindisch/dockenstack dockenstack
docker build -t ewindisch/dockenstack-tempest dockenstack-tempest
docker run --privileged -t -i ewindisch/dockenstack
```

# Using OpenStack

If you've started dockenstack interactively without extra arguments, you'll end up with a shell and can run these steps immediately.

```
source /devstack/openrc
nova boot --image busybox --flavor 1 test
nova list
docker ps
```

A future version of this README will explain how to use the OpenStack installation from outside of the dockenstack container.

# Running Tempest

Launch the container as such:

```
docker run --privileged -t -i ewindisch/dockenstack-tempest
```

Running Tempest in Dockenstack may take approximately 30 minutes.

Arguments to run-tempest may be passed, the arguments are the same as run_tempest.sh (see Tempest documentation / source)

# Configuration

Dockenstack should understand all of the devstack environment variables
passed as enviroment variables to 'docker run'. If using Docker Compose,
these environment variables may be added to the fig.yml file.

# Notes

* Requires Docker 1.3.3 or later.
* AUFS / Volumes - Using AUFS and nested-docker, one may need to mount /var/lib/docker as a volume or a bind-mount. (pass '-v /var/lib/docker' to 'docker run')
* Libvirt guests may need kernel modules loaded. Libvirt/Qemu support is neither tested nor complete.

# Authors

* Eric Windisch <ewindisch@docker.com>
* Paul Czarkowski

# License

Apache2 - see `LICENSE`
