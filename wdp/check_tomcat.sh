#!/bin/bash

TOMCAT_PATH="/usr/local/tomcat"
#pid=$(ps x | grep "${TOMCAT_PATH}" | grep -v grep |cut -d ' ' -f 1)
pid= $(/usr/bin/pgrep -f tomcat/bin/bootstrap)

echo "Tomcat PID is:" ${pid}

if [ "${pid}" ]
then
  echo "Tomcat is online"
  exit 0
else
  echo "Tomcat is offline"
  exit 2
fi
