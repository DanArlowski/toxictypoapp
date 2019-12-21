FROM openjdk:8u222-jre
#COPY ./settings.xml /root/.m2/settings.xml
ENV TAG="null"
ARG JAR_FILE
COPY ./target .
#RUN mvn verify
EXPOSE 8080
ENTRYPOINT java -jar toxictypoapp-${TAG}.jar