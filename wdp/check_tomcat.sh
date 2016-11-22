#!/bin/bash

TOMCAT_PATH="/usr/local/tomcat/bin/bootstrap"

pid=$(ps x | grep "${TOMCAT_PATH}" | grep -v grep | awk '{print $1}')
echo "Tomcat PID is:" ${pid}


                                                                                                                                                                       
if [ "${pid}" ]                                                                                                                                                        
then                                                                                                                                                                   
  echo "Tomcat is online"                                                                                                                                              
  exit 0                                                                                                                                                               
else                                                                                                                                                                   
  echo "Tomcat is offline"                                                                                                                                             
  exit 2                                                                                                                                                               
fi    
