# maven-image-builder

Creates docker images from maven sources. It extends [mtablado/basic-image-builder](https://github.com/mtablado/basic-image-builder) that allows this image to work with Docker in Docker.

## Configuration

The docker container declares a volume at `/home/jenkins/.m2`where dependencies and maven configuration will be persisted, as a requirement to avoid download dependencies each time (and boost time to market).

This image is currently injecting a settings.xml with a local artifactory repository that stores maven dependencies.

So, your docker container must declare a volume like `docker run -d -v /tmp/.m2:/home/jenkins/.m2`

## Jenkins Docker Plugin configuration

The following parameters must be configured:

##### TODO Tasks
- [ ] Template
- [ ] Docker command
- [ ] Docker plugin with slaves reference
- [ ] Etc.
