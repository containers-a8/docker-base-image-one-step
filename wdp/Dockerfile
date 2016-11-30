#FROM rhel7:7.3-45
#Replaced RHEL with latest centos & changed Maintainer name
FROM centos
MAINTAINER WDP Poc Team


#Making changes to the file from here. We don't and we won't have access to the artifactory repository
#ADD artifactory.repo /etc/yum.repos.d/rhel-server.repo

ENV JAVA_HOME /usr/lib/jvm/jre
ENV PATH /usr/local/tomcat/bin:$PATH


RUN yum install curl tar openssl alternatives java-1.8.0-openjdk java-1.8.0-openjdk-headless -y  \
    && yum clean all  \
    && update-ca-trust enable \
    && update-ca-trust \
    && mkdir -p /usr/local/tomcat \
    && curl -S http://apache.mirror.serversaustralia.com.au/tomcat/tomcat-8/v8.5.8/bin/apache-tomcat-8.5.8.tar.gz \
    | tar xzC /usr/local/tomcat --strip-components=1 --exclude=webapps/\* --exclude=conf/server.xml --exclude=bin/\*.bat --exclude=conf/web.xml \
    && mkdir -p /usr/local/tomcat/lib/org/apache/catalina/util \
    && rm -rf /var/log /var/cache /root/* /tmp/*



WORKDIR /usr/local/tomcat
EXPOSE 8080

ADD ServerInfo.properties /usr/local/tomcat/lib/org/apache/catalina/util/ServerInfo.properties
ADD server.xml /usr/local/tomcat/conf/server.xml
ADD web.xml /usr/local/tomcat/conf/web.xml
RUN groupadd -g 900 tomcat \
    && useradd -d /usr/local/tomcat -u 900 -G tomcat -s /bin/sh -M -N tomcat \
    && chown -R tomcat:tomcat /usr/local/tomcat \
    && chmod 400 /usr/local/tomcat/conf/* \
    && chmod -R 300 /usr/local/tomcat/logs \
    && chmod -R 600 /usr/local/tomcat/temp \
    && rm -rf /var/log /var/cache

ENV "SERVICE_TAGS=centos,jre-180u111-2b15,tomcat-858"

#These are the additions that we made to add consul to the base image and other additions (e.g wrapper scripts)

#Copy the  wrapper file and use that to start Tomcat
COPY catalina-wrapper.sh /usr/local/tomcat/bin/catalina-wrapper.sh

#Change permissions so that execute permissions are available in catalina-wrapper.sh
RUN chmod 755 /usr/local/tomcat/bin/catalina-wrapper.sh

#Copy the script to check the status of tomcat server
COPY check_tomcat.sh /etc/consul/scripts/check_tomcat.sh

#Change permissions to execute check_tomcat.sh
RUN chmod 755 /etc/consul/scripts/check_tomcat.sh

RUN yum install unzip -y

# install consul agent
ADD https://releases.hashicorp.com/consul/0.7.1/consul_0.7.1_linux_amd64.zip /tmp/consul.zip
RUN cd /bin && \
    unzip /tmp/consul.zip&& \
    chmod +x /bin/consul && \
    mkdir -p {/data/consul,/etc/consul.d} && \
    rm /tmp/consul.zip

# copy service and check definition, as we wrote them earlier
ADD service-def.json /etc/consul.d/service-def.json

#Copy the file that changes the name in service-def.json to use the info from the ENV
COPY generate-service-from-template.sh /usr/local/generate-service-from-template.sh

#Change permissions to execute this script
RUN chmod 755 /usr/local/generate-service-from-template.sh


# launch the catalina-wrapper script. This CMD should be removed later. I am using it for testing purposes now 
CMD ["/usr/local/tomcat/bin/catalina-wrapper.sh", "run"]
