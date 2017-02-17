### PostgreSQL with [BDR](https://2ndquadrant.com/en/resources/bdr/) B-Directional Replication in a docker.

[![CircleCI Build Status](https://img.shields.io/circleci/project/pozgo/docker-postgres-bdr/master.svg)](https://circleci.com/gh/pozgo/docker-postgres-bdr)
[![GitHub Open Issues](https://img.shields.io/github/issues/pozgo/docker-postgres-bdr.svg)](https://github.com/pozgo/docker-postgres-bdr/issues)
[![GitHub Stars](https://img.shields.io/github/stars/pozgo/docker-postgres-bdr.svg)](https://github.com/pozgo/docker-postgres-bdr)
[![GitHub Forks](https://img.shields.io/github/forks/pozgo/docker-postgres-bdr.svg)](https://github.com/pozgo/docker-postgres-bdr)  
[![Stars on Docker Hub](https://img.shields.io/docker/stars/polinux/postgres-bdr.svg)](https://hub.docker.com/r/polinux/postgres-bdr)
[![Pulls on Docker Hub](https://img.shields.io/docker/pulls/polinux/postgres-bdr.svg)](https://hub.docker.com/r/polinux/postgres-bdr)  
[![](https://images.microbadger.com/badges/version/polinux/postgres-bdr.svg)](http://microbadger.com/images/polinux/postgres-bdr)
[![](https://images.microbadger.com/badges/license/polinux/postgres-bdr.svg)](http://microbadger.com/images/polinux/postgres-bdr)
[![](https://images.microbadger.com/badges/image/polinux/postgres-bdr.svg)](http://microbadger.com/images/polinux/postgres-bdr)

[Docker Image](https://registry.hub.docker.com/u/polinux/postgres-bdr/) with PostgreSQL server with [BDR](https://2ndquadrant.com/en/resources/bdr/) support for database **Bi-Directional** replication. Based on [CentOS with Supervisor](https://hub.docker.com/r/million12/centos-supervisor/).

User can specify if database should work as `stand-alone` or `master/slave` mode. Even though BDR is more `master/master` solution we need to deploy first image which will create BDR setup inside of PostgreSQL. So for this purpose on `run` we need to specify one image to be so called master.

### Environmental Variables


| Variable     | Meaning     |
| :-----------:| :---------- |
|`POSTGRES_PASSWORD`|Self explanatory|
|`POSTGRES_USER`|Self explanatory|
|`POSTGRES_DB`|Self explanatory|
|`MODE`|Mode in which this image shoudl work. Options: `single/master/slave` (default=single)|
|`MASTER_ADDRESS`|Address of master node|
|`MASTER_PORT`|Master node port|
|`SLAVE_PORT`|Slave node port|


### Usage

#### Stand-Alone mode

    docker run \
      -d \
      --name postgres \
      -p 5432:5432 \
      polinux/postgres-bdr

#### Master + 2 slaves

Use `docker-compose.yml` exmple.

#### Deploy all at once from `docker-compose-yml` file.

    docker compose up

![All](https://raw.githubusercontent.com/pozgo/docker-postgres-bdr/master/images/all.gif)

#### Deploy master only

    docker compose up master

![Master](https://raw.githubusercontent.com/pozgo/docker-postgres-bdr/master/images/master.gif)

#### Deploy slave1 only

    docker compose up slave1

![Master](https://raw.githubusercontent.com/pozgo/docker-postgres-bdr/master/images/slave1.gif)

#### Deploy slave2 only

    docker compose up slave2

![Master](https://raw.githubusercontent.com/pozgo/docker-postgres-bdr/master/images/slave2.gif)

### Build

    docker build -t polinux/postgres-bdr .

Docker troubleshooting
======================

Use docker command to see if all required containers are up and running:
```
$ docker ps
```

Check logs of postgres-bdr server container:
```
$ docker logs postgres-bdr
```

Sometimes you might just want to review how things are deployed inside a running
 container, you can do this by executing a _bash shell_ through _docker's
 exec_ command:
```
docker exec -ti postgres-bdr /bin/bash
```

History of an image and size of layers:
```
docker history --no-trunc=true polinux/postgres-bdr | tr -s ' ' | tail -n+2 | awk -F " ago " '{print $2}'
```

## Author

Przemyslaw Ozgo (<linux@ozgo.info>)  
This work is also inspired by [agios](https://github.com/agios)'s work on their [docker images](https://github.com/agios/docker-postgres-bdr). Many thanks!
