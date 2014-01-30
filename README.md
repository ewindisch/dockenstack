# Docker on Openstack on Docker

Running Openstack with the Docker driver in a priviledged Docker container using devstack.

This container takes some time to build as it precaches and preinstalls most or all network resources. This speeds up running the container and, when running many, eliminates the problems that might result from offline or rate-limited apt and pip services.

While this speeds up the execution of the container itself, it can still take 2-4 minutes on a fast machine from "docker run" through having an operational OpenStack installation.

# Build & Run

## Trusted Build from index.docker.io

This leverages our "Trusted Build" process and daily-build system.

```
docker run -privileged -lxc-conf=aa_profile=unconfined -t -i ewindisch/dockenstack
```

## Self built

WARNING: This takes a while.

```
git clone https://github.com/ewindisch/dockenstack.git
cd dockenstack
docker build -t ewindisch/dockenstack-base dockenstack
docker build -t ewindisch/dockenstack dockenstack
docker run -privileged -lxc-conf=aa_profile=unconfined -t -i dockenstack
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
docker run -privileged -lxc-conf=aa_profile=unconfined -t -i ewindisch/dockenstack /usr/local/bin/run-tempest
```

Running Tempest in Dockenstack may take approximately 30 minutes.

Arguments to run-tempest may be passed, the arguments are the same as run_tempest.sh (see Tempest documentation / source)

# Environment Variables

Dockenstack currently accepts the following environment variables, which are likely to be expanded:

GIT_BASE
NOVA_REPO
NOVA_BRANCH

# Authors

* Eric Windisch <ewindisch@docker.com>
* Paul Czarkowski

# License

Apache2 - see `LICENSE`
