# --- Stage 1: Build ---
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# FIX: Your project produces a .war file, so we copy that instead of .jar
# We rename it to app.jar so the running stage works without changes
RUN cp target/*.war target/app.jar

# --- Stage 2: Run ---
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app
COPY --from=build /app/target/app.jar app.jar

ENV PORT=4041
EXPOSE 4041
ENTRYPOINT ["java","-jar","app.jar"]
