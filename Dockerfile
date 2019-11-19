FROM maven:3-jdk-8 as builder

#COPY settings.xml /root/.m2/
RUN mkdir -p /build
WORKDIR /build

COPY pom.xml /build
RUN mvn -B dependency:go-offline dependency:resolve dependency:resolve-plugins

COPY src /build/src
RUN mvn package -DskipTests

FROM openjdk:8-slim as runtime
EXPOSE 8080
ENV APP_HOME /app
ENV JAVA_OPTS=""

RUN mkdir $APP_HOME
RUN mkdir $APP_HOME/config
RUN mkdir $APP_HOME/log

VOLUME $APP_HOME/log
VOLUME $APP_HOME/config

WORKDIR $APP_HOME
COPY --from=builder /build/target/*.jar app.jar

ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar app.jar" ]
