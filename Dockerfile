# --- Stage 1: Build ---
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
# Build the app
RUN mvn clean package -DskipTests

# DEBUGGING: This will print the file list in the logs so we can see if the jar was created
RUN echo "Checking target directory..." && ls -l target/

# Rename the built jar to 'app.jar' so the next step is guaranteed to find it
# If this step fails, we know the issue is that Maven didn't create a .jar file
RUN cp target/*.jar target/app.jar

# --- Stage 2: Run ---
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app
# Copy the specifically named file
COPY --from=build /app/target/app.jar app.jar

ENV PORT=4041
EXPOSE 4041
ENTRYPOINT ["java","-jar","app.jar"]
