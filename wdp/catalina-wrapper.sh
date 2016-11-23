#!/bin/bash

cleanup()
{
  echo "Trapped signal. Cleaning up"
  deregister
}

deregister()
{
  echo "About to de-register service-tomcat"
#  curl -X PUT  http://localhost:8500/v1/agent/service/deregister/tomcat
#  response=$(curl --write-out %{http_code} --silent --output /dev/null servername)

   response=$(curl --write-out %{http_code} --silent --output /dev/null -X PUT  http://localhost:8500/v1/agent/service/deregister/tomcat)
   
   echo "Response code is:" ${response}
   if [ "${response}" == '200' ]                                                                                                                                                        
   then                                                                                                                                                                   
     echo "Tomcat service is successfully de-registered"                                                                                                                                                                                                                                                                                                          
   else                                                                                                                                                                   
     echo "ERROR occured during service deregistration - response code returned is:"  ${response}                                                                                                                                                                                                                                                                                                      
   fi   

}


register()
{
  echo "Register service"
  #  Start the consul agent
  #  Extract the Consul host from the environment variable - $CONSUL_HOST
  #consul agent -join $CONSUL_HOST -data-dir /data/consul -config-dir /etc/consul.d
}

trap cleanup SIGTERM SIGINT

register

/usr/local/tomcat/bin/catalina.sh run
