FROM maven:3.6.1

WORKDIR /app

COPY . .

CMD ["mvn", "spring-boot:run", "-Dspring.config.location=application-dev.properties"]
