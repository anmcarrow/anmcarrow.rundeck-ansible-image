# vim:set ft=dockerfile:
# FROM debian:stretch-slim
FROM anmcarrow/ansible

ENV ANSIBLE_HOST_KEY_CHECKING=false \
    RDECK_BASE=/opt/rundeck \
    MANPATH=${MANPATH}:${RDECK_BASE}/docs/man \
    PATH=${PATH}:${RDECK_BASE}/tools/bin \
    PROJECT_BASE=${RDECK_BASE}/projects/Test-Project \
    RDECK_ADMIN_PASS=admin \
    RDECK_HOST=0.0.0.0 \
    RDECK_PORT=4440 \
    RDECK_VERSION=3.0.1-20180803 \
    RDECK_WAR_URL=https://dl.bintray.com/rundeck/rundeck-maven
    # ENV RDECK_HOST=localhost \

## General package configuration
RUN apt-get -y update && \
    apt-get -y install \
        sudo \
        software-properties-common \
        debconf-utils \
        gnupg2 \
        uuid-runtime \
        openssh-client \
        apt-transport-https

## Install Oracle JVM
RUN \
     apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 \
  && mkdir -p /usr/share/man/man1 \
  && echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections \
  && add-apt-repository -y ppa:webupd8team/java \
  && apt-get update \
  && apt-get install -y oracle-java8-installer

## Install Rundeck

RUN \
     mkdir -p \
     ${PROJECT_BASE}/bin \
     ${PROJECT_BASE}/acls \
     ${PROJECT_BASE}/etc \
     ${RDECK_BASE}/libext
COPY files/realm.properties ${RDECK_BASE}/server/config/
COPY files/project.properties ${PROJECT_BASE}/etc/
ADD "${RDECK_WAR_URL}/rundeck-${RDECK_VERSION}.war" "/rundeck.war"

## Install Rundeck Ansible plugin
# ENV RDECK_ANSIBLE_VERSION=2.5.0 \
#    RDECK_ANSIBLE_URL=https://github.com/Batix/rundeck-ansible-plugin/releases/download/
# ADD "${RDECK_ANSIBLE_URL}/${RDECK_ANSIBLE_VERSION}/ansible-plugin-${RDECK_ANSIBLE_VERSION}.jar" "${RDECK_BASE}/libext/ansible-plugin-${RDECK_ANSIBLE_VERSION}.jar"


ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
# VOLUME $HOME/rundeck
WORKDIR ${RDECK_BASE}

EXPOSE 4440
# VOLUME /var/lib/cassandra

WORKDIR "/"
ENTRYPOINT ["/docker-entrypoint.sh"]
#CMD ["cassandra", "-f"]
# CMD ["bash"]
