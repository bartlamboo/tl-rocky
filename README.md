# ThinLinc Demo Instance

This is a docker based instance of ThinLinc. Running under docker its default
behavior is to suffer from complete amnesia after each restart. As such
it requires some minimal configuration after startup to accept your logins.

It's a modified version of https://github.com/oposs/tl-docker/ specifically
for Rocky 9.

## Startup

First you have to install docker. If you are running ubuntu, docker will be
available as a package for installation. If you are on windows or macos you
can go to docker.com to download docker for your os. If you are on RedHat,
install `podman-docker` to get a docker compatible cli for podman.

Normally a docker image will run a single application.  Often only a single
process.  In order to demo ThinLinc we get docker to run an entire linux
system for us.  For this to work, docker needs to run in `--privileged` mode.

The ThinLinc client uses html to communicate with its server, with the
`--publish` option you map the html port of the ThinLinc demo server to a
port, accessible from the outside.  Keep the docker attached to the terminal
`-t` to see all the messages it outputs to the console.

```console
docker build --tag tl-rocky:latest .
docker run -d --privileged --name tl-rocky --publish 300:300 --cgroupns=host --tmpfs /tmp --tmpfs /run  -v /sys/fs/cgroup:/sys/fs/cgroup tl-rocky:latest
```

Alternatively, you can also use docker compose to start the container.
An example docker compose script is also in the repository.

```console
docker compose -f thinlinc-rocky.yaml up -d
```

## Configuration

Before you can login, the ThinLinc server requires some minimal configuration

First add a user account. Either with a password

```console
docker exec tl-rocky tlcfg add-user myuser mypassword
```

Seeing that this thinlinc instance is made available over the internet via
https you might your own certificates. (self signed are available by
default)
You can also use the volume mounts for these certificates as can be seen by
the example in the docker compose file. (thinlinc-rocky.yaml)

```console
docker cp mydomain.com.crt tl-rocky:/opt/thinlinc/etc/tlwebaccess/server.crt
docker cp mydomain.com.key tl-rocky:/opt/thinlinc/etc/tlwebaccess/server.key
```

Second, let the ThinLinc server know under what hostname it is reachable
from the client.  This is a very important step, as ThinLinc uses a
load-balancing system where it will tell your client to connect to the the
ThinLinc server with the lowest load in your ThinLinc cluster.

In this example we tell the ThinLinc server that it can be reached from the
local machine.  But you can also set the public IP or the dns name of your
machine to make your demo instance available on your network.

```console
docker exec tl-rocky tlcfg set-hostname 127.0.0.1
```

## Cleanup

When you are done testing, you can get rid of your ThinLinc demo server very easily:

```console
docker kill tl-rocky
docker rm tl-rocky
```

Note that this will also get rid of anything you have done on the ThinLinc demo server
while logged in with your demo user

## Debugging

If you want to have a peak inside the ThinLinc server while it is running, try this

```console
docker exec -ti tl-rocky bash
```

## Support

If you have questions in connection with ThinLinc in general or
thinlinc-demo-in-a-docker head over to the [ThinLinc Community](https://community.thinlinc.com/tag/docker).

*EOF*
