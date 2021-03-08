FROM maven:3.6.3-jdk-11-slim as build-hapi
WORKDIR /tmp/hapi-fhir-jpaserver-starter

COPY pom.xml .
RUN mvn -ntp dependency:go-offline

COPY src/ /tmp/hapi-fhir-jpaserver-starter/src/
RUN mvn clean install -DskipTests

FROM tomcat:9.0.38-jdk11-openjdk-slim-buster

RUN groupadd -r hapi -g 2000 && \
    useradd -m -u 1000 hapi -g 2000 -G users && \
    mkdir -p /data/hapi/lucenefiles && \
    mkdir -p /data/hapi/app && \
    chown -R hapi:hapi /data/hapi && \
    chmod 775 /data/hapi/lucenefiles

WORKDIR /data/hapi/app
USER hapi
COPY --from=build-hapi /tmp/hapi-fhir-jpaserver-starter/target/*.war /data/hapi/app/
COPY --from=build-hapi /tmp/hapi-fhir-jpaserver-starter/src/main/resources/init.sh /data/hapi/app/init.sh

RUN chmod 775 /data/hapi/app/init.sh

EXPOSE 8080
CMD ["/data/hapi/app/init.sh"]
#CMD ["catalina.sh", "run"]
