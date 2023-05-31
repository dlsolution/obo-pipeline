FROM maven:3.6.1

WORKDIR /app

COPY pom.xml .
COPY src ./src

# EXPOSE 8080
CMD ["mvn", "spring-boot:run", "-Dspring.config.location=application-dev.properties"]