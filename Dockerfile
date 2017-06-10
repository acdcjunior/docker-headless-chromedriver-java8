FROM justinribeiro/chrome-headless

MAINTAINER Antonio "acdc" Jr. <acdcjunior@gmail.com>

# Base image changes user to 'chrome'
USER root

# Install Java8 (oraclejdk8)
# Inspired by: https://github.com/dockerfile/java/blob/master/oracle-java8/Dockerfile and https://linux-tips.com/t/how-to-install-java-8-on-debian-jessie/349
RUN \
   apt-get update && apt-get install -y gnupg --no-install-recommends && \
   echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" > /etc/apt/sources.list.d/webupd8team-java.list && \
   echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/webupd8team-java.list && \
   apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
   apt-get update && \
   echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
   apt-get install -y oracle-java8-installer && \
   apt-get clean && \
   apt-get autoremove && \
   rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/oracle-jdk8-installer
	
# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Restore base image's user (run Chrome non-privileged)
USER chrome

# All below is from parent

# Expose port 9222
EXPOSE 9222

# Autorun chrome headless with no GPU
ENTRYPOINT [ "google-chrome-stable" ]
CMD [ "--headless", "--disable-gpu", "--remote-debugging-address=0.0.0.0", "--remote-debugging-port=9222" ]
