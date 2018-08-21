#!/usr/bin/env bash

if [ -d /data/libext ]; then
  echo adding custom plugins...
  cp -r /data/libext/* ${RDECK_BASE}/libext
fi

rm -f /opt/rundeck/rundeck.war
ln -s /rundeck.war /opt/rundeck/rundeck.war

sed -i -e "s/_ADMINPW_/${RDECK_ADMIN_PASS}/" ${RDECK_BASE}/server/config/realm.properties

java -Xmx1g "-Dserver.hostname=${RDECK_HOST}" "-Dserver.http.port=${RDECK_PORT}" -jar "${RDECK_BASE}/rundeck.war"
