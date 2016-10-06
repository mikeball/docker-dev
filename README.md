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

** and these are the hard ones **

5. All files created by container are owned by root (linux)
6. Reloading of all app dependancies from repo on each container startup
7. Your editor/ide/debugger does not work correctly when not "inside" the container



# 1. Basic usage of docker

docker images
docker ps -a

build a dev image
 a. Choose a base image (https://hub.docker.com/_/openjdk/)
 		- used openjdk:8-jdk instead of 8-jdk-alpine because I wanted terminal inside docker. probably would deploy uberjar on openjdk:8-alpine
 b. Write a Dockerfile
 c. docker build -t basicapp .
 d. docker images


# 2. Remove old containers after they are run (use --rm option)

docker run -it basicapp
docker ps -a
docker rm ???

docker run --rm -it basicapp
docker ps -a


# 3. Sharing the files on main computer with the container (volumes)

docker run --rm -it -v ~/work/meetup/docker-dev/basic/project:/project basicapp


# 4. Mapping ports from the container to the host

- Even though you expose the container port you should also map it, otherwise docker will assign it a random port number on the host.

docker ps -a

docker run --rm -it -v ~/work/meetup/docker-dev/basic/project:/project -p 8080:8080 basicapp


# Problem 5 - Files Owned By root
- doesn't seem to be an issue in windows/mac, only an issue on linux
- inject your current user into the container
- use a startup script that sets user and permissions to same as current user.

We will see a solution to this in the make-dev solution.


# 6. Reloading of all app dependencies from repo on each container startup

- Store the dependencies on the host and share as a volume.
- For instance with java maven we have the .m2 folder which will shared as volume.


# 7. Your editor/ide/debugger does not work correctly when not "inside" the container

- the solution is to use SSHFS
  * install ssh in the container
  * use SSHFS to mount the root of the container
  * do some special simlink fixes
  * you should be able to use the file system as normal.


- I won't be attempting to show this today.




# Docker Compose Example

show the compose files...

cd compose-dev
docker-compose build
docker-compose up

- Then from another terminal
docker exec -it composedev_web_1 bash

lein version

lein new hello1

set the repl options in projet clj to listen on right port and host
:repl-options {:host "0.0.0.0" :port 9090}

start a repl
lein repl

connect to the repl from atom and execute some code


shutdown the compose instances
docker-compose down






# Using make to setup a dev container

look at Dockerfile
look at startup.sh
look at makefile

cd make-dev/web
docker build -t makedev_web .

make shell


lein new hello2

set the repl options
:repl-options {:host "0.0.0.0" :port 9090}

cd hello2
lein repl



# Reference Links

https://github.com/markmandel/wrapping-clojure-tooling-in-containers
https://www.youtube.com/watch?v=FtkHgQSSb3c



xx
