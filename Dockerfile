# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:0.9.11

MAINTAINER Rydnr "docker@acm-sl.org"

# Set correct environment variables.
ENV HOME /root

# Disabling sshd
#RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update && apt-get clean
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
RUN apt-get install -q -y oracle-java8-installer && apt-get clean
ADD http://mirrors.jenkins-ci.org/war/latest/jenkins.war /opt/jenkins.war
RUN chmod 644 /opt/jenkins.war
RUN /usr/sbin/useradd -U -m -d /jenkins -s /bin/bash -c "Jenkins user running java -jar /opt/jenkins.war" jenkins
ADD jenkins-.bashrc /jenkins/.bashrc
RUN mkdir /etc/service/jenkins
ADD jenkins.sh /etc/service/jenkins/run
RUN chmod 777 /etc/service/jenkins/run

#ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]
EXPOSE 8080

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Clean up APT when done.

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
