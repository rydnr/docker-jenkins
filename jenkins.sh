#!/bin/sh

exec /sbin/setuser jenkins /usr/bin/java -jar jenkins.war >> /var/log/jenkins.log 2>&1
