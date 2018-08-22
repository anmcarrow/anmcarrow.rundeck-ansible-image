# vim:set ft=dockerfile:
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

## General package configuration
RUN apt-get -y update && \
    apt-get -yy --no-install-recommends install \
        sudo \
        software-properties-common \
        debconf-utils \
        gnupg2 \
        uuid-runtime \
        openssh-client \
        apt-transport-https \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

## Install Oracle JVM
RUN \
     apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 \
   && mkdir -p /usr/share/man/man1 \
   && echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections \
   && echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" > /etc/apt/sources.list.d/java8.list \
   && apt-get update \
   && apt-get -yy --no-install-recommends install oracle-java8-installer oracle-java8-set-default \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/* \
   && rm -rf /var/cache/oracle-jdk8-installer

## Install Rundeck
RUN \
     mkdir -p \
     ${PROJECT_BASE}/bin \
     ${PROJECT_BASE}/acls \
     ${PROJECT_BASE}/etc \
     ${RDECK_BASE}/libext
ADD files/realm.properties ${RDECK_BASE}/server/config/
ADD files/project.properties ${PROJECT_BASE}/etc/
ADD "${RDECK_WAR_URL}/rundeck-${RDECK_VERSION}.war" "/rundeck.war"

## Install Rundeck Ansible plugin
# ENV RDECK_ANSIBLE_VERSION=2.5.0 \
#    RDECK_ANSIBLE_URL=https://github.com/Batix/rundeck-ansible-plugin/releases/download/
# ADD "${RDECK_ANSIBLE_URL}/${RDECK_ANSIBLE_VERSION}/ansible-plugin-${RDECK_ANSIBLE_VERSION}.jar" "${RDECK_BASE}/libext/ansible-plugin-${RDECK_ANSIBLE_VERSION}.jar"


ADD docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 4440
HEALTHCHECK --interval=5s --timeout=10s --retries=3 CMD wget -q --spider 127.0.0.1:4440 || exit 1
WORKDIR ${RDECK_BASE}
ENTRYPOINT ["/docker-entrypoint.sh"]
# CMD ["bash"]
