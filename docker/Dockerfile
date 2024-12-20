# ####
# # This Dockerfile is used in order to build a container that runs the Spring Boot application
# #
# # Build the image with:
# #
# # docker build -f docker/Dockerfile -t springboot/sample-demo .
# #
# # Then run the container using:
# #
# # docker run -i --rm -p 8081:8081 springboot/sample-demo
# ####
# FROM registry.access.redhat.com/ubi8/openjdk-17:1.15-1.1682053058 AS builder

# # Build dependency offline to streamline build
# RUN mkdir project
# WORKDIR /home/jboss/project
# COPY pom.xml .
# RUN mvn dependency:go-offline

# COPY src src
# RUN mvn package -Dmaven.test.skip=true
# # compute the created jar name and put it in a known location to copy to the next layer.
# # If the user changes pom.xml to have a different version, or artifactId, this will find the jar
# RUN grep version target/maven-archiver/pom.properties | cut -d '=' -f2 >.env-version
# RUN grep artifactId target/maven-archiver/pom.properties | cut -d '=' -f2 >.env-id
# RUN mv target/$(cat .env-id)-$(cat .env-version).jar target/export-run-artifact.jar

# FROM registry.access.redhat.com/ubi8/openjdk-17-runtime:1.15-1.1682053056
# COPY --from=builder /home/jboss/project/target/export-run-artifact.jar  /deployments/export-run-artifact.jar
# EXPOSE 8081
# ENTRYPOINT ["/opt/jboss/container/java/run/run-java.sh", "--server.port=8081"]

# Stage 1: Build Phase
FROM registry.access.redhat.com/ubi8/openjdk-17:1.15-1.1682053058 AS builder

# Set the working directory
WORKDIR /home/jboss/project

# Copy the Gradle configuration
COPY gradle.properties .
COPY gradlew .
COPY gradlew.bat .

# Download dependencies
RUN ./gradlew dependencies --info

# Copy the application source code
COPY src src

# Build the WAR file
RUN ./gradlew bootWar -x test

# Stage 2: Deployment Phase
FROM openliberty/open-liberty:24.0.0.12-kernel-slim-java21-openj9-ubi-minimal

# Install Open Liberty runtime if not already present
RUN if [ ! -d "/opt/ol" ]; then \
        curl -L https://repo1.maven.org/maven2/io/openliberty/openliberty-runtime/24.0.0.12/openliberty-runtime-24.0.0.12.jar -o /opt/ol/openliberty-runtime.jar; \
        fi

# Copy the WAR file to the Liberty dropins directory
COPY --from=builder /home/jboss/project/build/libs/*.war /config/dropins/

# Copy Liberty server configuration
COPY src/main/liberty/config/server.xml /config/server.xml

# Expose the application port
EXPOSE 8081

# Start the Liberty server
CMD ["defaultServer"]
