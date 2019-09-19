FROM maven:3.6.1-jdk-8
COPY . .
ENTRYPOINT mvn verify