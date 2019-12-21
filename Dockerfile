FROM openjdk:8u222-jre
#COPY ./settings.xml /root/.m2/settings.xml
ENV TAG="null"
ARG JAR_FILE
COPY ./target .
RUN mv ${JAR_FILE}.jar toxictypoappRUNNABLE.jar
#RUN mvn verify
EXPOSE 8080
ENTRYPOINT java -jar toxictypoappRUNNABLE.jar