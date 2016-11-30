#!/bin/bash

echo "ServiceName:" $SERVICE_NAME


cleanup()
{
  echo "Trapped signal. Cleaning up"
  deregister
}

deregister()
{
  echo "About to de-register service: " $SERVICE_NAME

   response=$(curl --write-out %{http_code} --silent --output /dev/null -X PUT  http://localhost:8500/v1/agent/service/deregister/$SERVICE_NAME)
   
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
  echo "About to register service:" $SERVICE_NAME
  #  Start the consul agent
  #Start the consul agent in background

  #Create the JSON file with the SERVICE_NAME picked from the ENV
  /usr/local/generate-service-from-template.sh /etc/consul.d/service-def.json > /etc/consul.d/new-service-def.json
  
  #The service definition file is written  to a new-service-def file with the information and it can now be used for registration
  #The original service-def.json (template file) is deleted
  rm /etc/consul.d/service-def.json

  consul agent -join $CONSUL_HOST -data-dir /data/consul -config-dir /etc/consul.d   &

}

trap cleanup SIGTERM SIGINT

register

/usr/local/tomcat/bin/catalina.sh run
