# Makefile to manage this project
TAG=makedev_web

#Directory that this Makefile is in.
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_path := $(dir $(mkfile_path))



# Start a development shell
shell:
	mkdir -p ~/.m2
	docker run --rm \
		--name=$(NAME) \
		-P=true \
		-e HOST_GID=`id -g` \
		-e HOST_UID=`id -u` \
		-e HOST_USER=$(USER) \
		-v ~/.m2:/home/$(USER)/.m2 \
		-v $(current_path):/project \
		-p 8080:8080 -p 9090:9090 \
		-it $(TAG) /root/startup.sh
