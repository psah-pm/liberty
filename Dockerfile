# Base Image
FROM adoptopenjdk:11-jdk-hotspot

# Set the working directory
WORKDIR /app

# Copy the Pom file and the WAR file to the working directory
COPY target/demo-0.0.1-SNAPSHOT.war /app/demo.war
COPY pom.xml /app/

# Download Maven dependencies during the build time
RUN mvn dependency:go-offline

# Expose the port the application will run on
EXPOSE 9080

# Run the application
CMD ["java", "-jar", "/app/demo.war"]
