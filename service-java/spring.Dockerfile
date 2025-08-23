FROM maven:3.9.11-eclipse-temurin-17-alpine AS builder

WORKDIR /spring-boot-app

COPY pom.xml .

RUN mvn dependency:resolve

COPY src ./src

RUN mvn clean package

FROM eclipse-temurin:17-jre

WORKDIR /spring-boot-app

COPY --from=builder /spring-boot-app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]