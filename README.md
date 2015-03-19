# Openstack on Docker

Dockenstack builds an image for running OpenStack's devstack development and testing environment inside of a Docker container. This image currently supports running the docker and libvirt-lxc virtualization drivers for Nova. KVM/Qemu support is being tested.

Using dockenstack, developers may quickly iterate changes in a container and locally invoke functional tests without needing to first submit their changes for code-review.

The quick iteration cycle of dockenstack versus other local environments (such as devstack-vagrant) is accomplished by precaching and preinstalling most or all network resources and OS packages. This speeds up running the container and, when running many, eliminates the problems that might result from offline or rate-limited apt and pip services.

Users may expect dockenstack to take 2-4 minutes on a fast machine from "docker run" through having an operational OpenStack installation.

# Build & Run

## Trusted Build from index.docker.io

This leverages our "Trusted Build" process and daily-build system.

```
docker run -privileged -t -i ewindisch/dockenstack
```

## Self built

WARNING: This takes a while.

```
git clone https://github.com/ewindisch/dockenstack.git
cd dockenstack
docker build -t ewindisch/dockenstack dockenstack
docker run -privileged -t -i ewindisch/dockenstack
```

# Using OpenStack

If you've started dockenstack interactively without extra arguments, you'll end up with a shell and can run these steps immediately.

```
source /devstack/openrc
nova boot --image docker-busybox:latest --flavor 1 test
nova list
docker ps
```

A future version of this README will explain how to use the OpenStack installation from outside of the dockenstack container.

# Running Tempest

Launch the container as such:

```
docker run -privileged -t -i ewindisch/dockenstack /usr/local/bin/run-tempest
```

Running Tempest in Dockenstack may take approximately 30 minutes.

Arguments to run-tempest may be passed, the arguments are the same as run_tempest.sh (see Tempest documentation / source)

# Environment Variables

Dockenstack should understand all of the devstack environment variables.
 
# Notes

* Requires Docker 1.0 or later.
* AUFS / Volumes - Using AUFS and nested-docker, one may need to mount /var/lib/docker as a volume or a bind-mount. (pass '-v /var/lib/docker' to 'docker run')
* Libvirt guests may need kernel modules loaded. If these are not already loaded in the host, you may wish to bind-mount /lib/modules into the container using 'docker run -v /lib/modules:/lib/modules'

# Authors

* Eric Windisch <ewindisch@docker.com>
* Paul Czarkowski

# License

Apache2 - see `LICENSE`
