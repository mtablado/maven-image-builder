# maven-image-builder

Creates docker images from maven sources. It extends [mtablado/basic-image-builder](https://github.com/mtablado/basic-image-builder) that allows this image to work with Docker in Docker.

## Configuration

The docker container declares a volume at `/home/jenkins/.m2`where dependencies and maven configuration will be persisted, as a requirement to avoid download dependencies each time (and boost time to market).

This image is currently injecting a settings.xml with a local artifactory repository that stores maven dependencies.

So, your docker container must declare a volume like `docker run -d -v /tmp/.m2:/home/jenkins/.m2`

## Jenkins Docker Plugin configuration

The following parameters must be configured at Docker Template section inside the Cloud one:

- [ ] Docker image: `docker-virtual.art.local/maven-image-builder` 
- [ ] Docker command: `/jenkins-slave-startup.sh` This script is inherited from base `tehranian/dind-jenkins-slave`image. If you leave it empty, the plugin will run SSH command.
- [ ] Volumes: `/tmp/.m2:/home/jenkins/.m2`. You may want to modify the host location.
- [ ] Run container privileged `true` To allow Docker in Docker.
- [ ] Extra Hosts: `docker-virtual.art.local:192.168.99.100` This example is using a private Docker Registry, leave it blank if you don't need it.
- [ ] Instance Capacity: >=1 Take in mind that this builder is not exactly fast and you would like to compile multiple projects simultaneously.
- [ ] Remote Filing System Root: `/home/jenkins`
- [ ] Labels: `maven-image-builder` To reference this slave at jenkinsfile.
- [ ] Launch method: `Docker SSH computer launcher`
	- [ ] Credentials: `jenkins/jenkins`
- [ ] Remote FS Root Mapping: `/var/jenkins_home`

The rest of them can be the default values.