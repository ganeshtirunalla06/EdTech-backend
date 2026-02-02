# --- Stage 1: Build the Application ---
# We use a Maven image that is based on the modern Eclipse Temurin JDK
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# --- Stage 2: Run the Application ---
# We use the official Eclipse Temurin image for the runtime
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

ENV PORT=4041
EXPOSE 4041
ENTRYPOINT ["java","-jar","app.jar"]
