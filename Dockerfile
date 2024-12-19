# Dockerfile
FROM adoptopenjdk:11-jdk-hotspot

# Set the working directory
WORKDIR /app

# Copy the WAR file to the working directory
COPY target/demo-0.0.1-SNAPSHOT.war /app/demo.war

# Expose the port the application will run on
EXPOSE 9080

# Run the application
CMD ["java", "-jar", "/app/demo.war"]
