FROM openjdk:8
MAINTAINER cassiano.mangold@treasy.com.br

COPY target/hello-service-swarm.jar /service/hello-service-swarm.jar

WORKDIR /service

CMD ["java", "-jar", "/service/hello-service-swarm.jar", "-Xms128m", "-Xmx256m", "-Duser.language=pt", "-Duser.country=BR", "-Duser.timezone=America/Sao_Paulo"]