# docker-dev
How to setup a docker development environment.



# Why use docker
1. to have nice clean environment to work on array of different projects without cluttering the main machine with a host of different conflicting dependancies.

2. An alternative is to use a bunch of VM's but they use a lot of memory, slower to startup and aren't as amenable to being run in production.


# Dev Time VS Run Time
- My personal feeling is that dev containers should be similar, but not actual production containers. So the end product, an uberjar or natively compiled binary and then can be packaged and deployed as desired.

- Basically dev time should have build tools, runtime should not
- Today I will be focusing on just the dev time setup


# Mac vs linux
The docker tools on mac take care of file permission issues.
Compose seems to work a bit better
On linux, my preference is for the make based startup.

# Latest Tooling
- docker has had major changes and updates recently. Please be sure to use the very latest tooling.


# The Dev Time Problems
1. Basic usage of docker
2. Remove old containers after they are run (use --rm)
3. Sharing the files on main computer with the container (volumes)
4. Mapping ports from the contain to the host
5. All files created by container are owned by root (linux)
6. Reloading of all app dependancies from repo on each container startup
7. Your editor/ide/debugger does not work correctly when not "inside" the container



# 1. Basic usage of docker

```bash
docker images
docker ps -a
```

Let's build a dev image

1. Choose a base image (https://hub.docker.com/_/openjdk/)
 		* I used openjdk:8-jdk instead of 8-jdk-alpine because I wanted terminal inside docker. probably would deploy uberjar on openjdk:8-alpine
2. Write a Dockerfile (see basic/Dockerfile)

```bash
docker build -t basicapp .
docker images
```

## Run a container
```bash
docker run -it basicapp
docker ps -a
```


## Remove containers automatically after they are run (use --rm option)
```bash
docker run -it basicapp
docker ps -a

docker rm the_container_name

docker run --rm -it basicapp
docker ps -a
```

## Sharing the files on main computer with the container (volumes)

Use the `-v` option

```bash
docker run --rm -it -v ~/work/meetup/docker-dev/basic/project:/project basicapp
```

## Mapping ports from the container to the host

- Even though you expose the container port you should also map it, otherwise docker will assign it a random port number on the host.

```bash
docker ps -a

docker run --rm -it -v ~/work/meetup/docker-dev/basic/project:/project -p 8080:8080 basicapp
```


# Problem: Files Owned By root on Linux
- doesn't seem to be an issue in windows/mac on recent versions, only an issue on linux
- we will inject your current user into the running container
- We will see a solution to this in the make-dev solution.


# Problem: Reloading of all app dependencies from repo on each container startup
- Store the dependencies on the host and share as a volume.
- For instance with java maven we have the .m2 folder which will shared as volume.


# Problem: Your editor/ide/debugger does not work correctly when not "inside" the container
- the solution is to use SSHFS
  * install ssh in the container
  * use SSHFS to mount to the root of the container
  * do some special simlink fixes
  * you should be able to use the file system as normal.
  * see reference links below for more details.
- I won't be attempting to show this today




# Docker Compose Example

Why compose? Because it can start up multiple linked containers easily.

- Go over compose-dev/docker-compose.yml
- Go over compose-dev/web/Dockerfile
```bash
cd compose-dev
docker-compose build
docker-compose up
```

Connect to web instance from another terminal
```bash
docker exec -it composedev_web_1 bash

lein version
lein new hello1
```

set the REPL options in project clj to listen on right port and host

```clojure
(defproject hello1 "0.1.0-SNAPSHOT"
  :dependencies [[org.clojure/clojure "1.8.0"]]

  :repl-options {:host "0.0.0.0" :port 9090})
```

start a REPL
```bash
lein repl
```

connect to the REPL inside the docker container from atom and execute some code

cmd + shift + p => search repl remote => enter port


Open a clojure source file and execute some expressions.
cmd + alt + b


shutdown the compose instances
```bash
docker-compose down
```





# Using make to setup a dev container

Why make instead of compose? Because it allows us more fine grained control and to pass current user information to containsers as environment variables. It doesn't however start up multiple containers. It should also work well with other container systems such as rocket.

- Go over make-dev/Dockerfile
- Go over make-dev/startup.sh
- Go over make-dev/Makefile

```bash
cd make-dev/web
docker build -t makedev_web .
docker images
make shell
```

We should now have a terminal with java/lein, and user should be host user.
```bash
lein new hello2
```

Set the REPL options
```clojure
(defproject hello2 "0.1.0-SNAPSHOT"
  :dependencies [[org.clojure/clojure "1.8.0"]]

  :repl-options {:host "0.0.0.0" :port 9090})
```

Now start a REPL
```bash
cd hello2
lein repl
```

connect to the REPL inside the docker container from atom and execute some code

cmd + shift + p => search repl remote => enter port

Open a clojure source file and execute some expressions.
cmd + alt + b




# Reference Links
https://github.com/markmandel/wrapping-clojure-tooling-in-containers
https://www.youtube.com/watch?v=FtkHgQSSb3c



xx
