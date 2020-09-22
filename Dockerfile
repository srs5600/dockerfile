FROM alpine/git AS clone
WORKDIR /app
RUN git clone https://github.com/srs5600/webtestApp.git /app

#RUN echo "$PWD"


FROM maven:3.6.3-adoptopenjdk AS build
#FROM maven:3-alpine as build
#FROM maven:3-jdk-14 as build
#RUN echo "$PWD"
WORKDIR /root/
#COPY --from=clone /app/webtestApp/ /home/app/
COPY --from=clone /app/webtestApp/src /home/app/src
COPY --from=clone /app/webtestApp/WebContent /home/app/WebContent
COPY --from=clone /app/webtestApp/pom.xml /home/app
#RUN echo "$PWD"
RUN mvn -f /home/app/pom.xml clean package
#RUN echo "$PWD"
RUN mvn install -f /home/app/pom.xml
#RUN echo "$PWD"

#FROM tomcat:9.0.37 AS deploy
FROM tomcat:jdk14-openjdk-slim AS deploy
#WORKDIR /app
RUN echo "$PWD"

#COPY  --from=build /home/app/target/webtestApp-0.0.1-SNAPSHOT.war /usr/local/tomcat/webapps/
COPY  --from=build /home/app/target/webtestApp.war /usr/local/tomcat/webapps/
#COPY  --from=build /home/app/ /usr/local/tomcat/temp/
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin

EXPOSE 8080
