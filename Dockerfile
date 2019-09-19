FROM maven:3.6.1-jdk-8
#COPY ./settings.xml /root/.m2/settings.xml
COPY . .
#RUN mvn verify
EXPOSE 8080
WORKDIR /target
ENTRYPOINT [ "java", "-jar" , "toxictypoapp-1.0-SNAPSHOT.jar"]