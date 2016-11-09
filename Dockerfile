FROM docker-virtual.art.local/basic-image-builder:latest
RUN apt-get update && apt-get -y install maven
