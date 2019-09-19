FROM openjdk:8u222-jre
#COPY ./settings.xml /root/.m2/settings.xml
COPY ./target .
#RUN mvn verify
EXPOSE 8080
WORKDIR /target
ENTRYPOINT [ "java", "-jar" , "toxictypoapp-1.0-SNAPSHOT.jar"]