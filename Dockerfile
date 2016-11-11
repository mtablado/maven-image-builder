FROM docker-virtual.art.local/basic-image-builder:latest
RUN java -version \
	&& echo PATH=$PATH \
	&& echo JAVA_HOME=$JAVA_HOME
RUN apt-get update
RUN apt-get install -y software-properties-common python-software-properties

RUN sudo add-apt-repository ppa:openjdk-r/ppa \
	&& apt-get update \
	&& apt-get -y install openjdk-8-jdk-headless:amd64 && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

# Debug instructions.
RUN ls -lia /usr/lib/jvm/ 
RUN which java && ls -lia /usr/bin/java && ls -lia /etc/alternatives/java && ls -lia /usr/lib/jvm/ 
RUN which javac && ls -lia /usr/bin/javac && ls -lia /etc/alternatives/java && ls -lia /usr/lib/jvm/ 

# Set JAVA_HOME environment variable to new installed openjdk-8-jdk.
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
#ENV JAVA_HOME=/usr/lib/jvm/openjdk-8-jdk-amd64

# Update alternatives to use java 8.
RUN update-alternatives --install "/usr/bin/java" "java" "${JAVA_HOME}/bin/java" 1 && \
	update-alternatives --install "/usr/bin/javac" "javac" "${JAVA_HOME}/bin/javac" 1 && \
	update-alternatives --set java "${JAVA_HOME}/bin/java" && \
	update-alternatives --set javac "${JAVA_HOME}/bin/javac"
	
RUN java -version \
	&& javac -version \
	&& echo PATH=$PATH \
	&& echo JAVA_HOME=$JAVA_HOME

# It is convenient to delete openjdk-7-jdk for a better image size. 
RUN echo y | apt-get purge --auto-remove openjdk-7-jre-headless:amd64

# Debug instructions.
#RUN which java && ls -lia /usr/bin/java && ls -lia /etc/alternatives/java && ls -lia /usr/lib/jvm/ && ls /
#RUN which javac && ls -lia /usr/bin/javac && ls -lia /etc/alternatives/java && ls -lia /usr/lib/jvm/ && ls /

RUN apt-get update && apt-get -y install maven && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

RUN mkdir -p /home/jenkins/.m2/ && chown jenkins:jenkins /home/jenkins/.m2/
# Jenkins slave must save dependencies instead of download them at every mvn process.
VOLUME ["/home/jenkins/.m2/"]

RUN chown -R jenkins:jenkins /home/jenkins/.m2/

# set settings for maven
COPY settings.xml /home/jenkins/.m2/