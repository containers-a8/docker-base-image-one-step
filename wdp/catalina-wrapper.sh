#!/bin/bash

echo "Starting catalina-wrapper.sh"


cleanup()
{
  echo "Trapped signal. Cleaning up"
  deregister
}

deregister()
{
  echo "De-register service"
}

register()
{
  echo "Register service"
}

trap cleanup SIGTERM SIGINT

register

/usr/local/tomcat/bin/catalina.sh run
