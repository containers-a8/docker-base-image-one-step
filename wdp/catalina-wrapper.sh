#!/bin/bash

cleanup()
{
  echo "Trapped signal. Cleaning up"
  deregister
}

deregister()
{
  echo "About to de-register service: TomcatWC"

   response=$(curl --write-out %{http_code} --silent --output /dev/null -X PUT  http://localhost:8500/v1/agent/service/deregister/TomcatWC)
   
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
  echo "About to register TomcatWC service"
  #  Start the consul agent
  #Start the consul agent in background
  consul agent -join $CONSUL_HOST -data-dir /data/consul -config-dir /etc/consul.d   &

}

trap cleanup SIGTERM SIGINT

register

/usr/local/tomcat/bin/catalina.sh run