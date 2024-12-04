# Stage 1: Build Kafka and dependencies
FROM alpine:3.18 AS builder

# Update repositories and install required tools
RUN apk update && apk upgrade --no-cache && \
    apk add --no-cache wget openjdk17 bash curl busybox-extras

# Set environment variables for Java
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
ENV PATH="$JAVA_HOME/bin:$PATH"

# Download Kafka
WORKDIR /tmp
RUN wget -qO- https://downloads.apache.org/kafka/3.8.0/kafka_2.13-3.8.0.tgz | tar xz

# Download fixed dependencies
RUN curl -fsSL -o /tmp/netty-common-4.1.115.Final.jar https://repo1.maven.org/maven2/io/netty/netty-common/4.1.115.Final/netty-common-4.1.115.Final.jar && \
    curl -fsSL -o /tmp/jetty-http-12.0.12.jar https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-http/12.0.12/jetty-http-12.0.12.jar && \
    curl -fsSL -o /tmp/jetty-server-12.0.9.jar https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-server/12.0.9/jetty-server-12.0.9.jar && \
    curl -fsSL -o /tmp/commons-io-2.14.0.jar https://repo1.maven.org/maven2/commons-io/commons-io/2.14.0/commons-io-2.14.0.jar && \
    curl -fsSL -o /tmp/protobuf-java-3.25.5.jar https://repo1.maven.org/maven2/com/google/protobuf/protobuf-java/3.25.5/protobuf-java-3.25.5.jar

# Stage 2: Final runtime image
FROM alpine:3.18

# Update and upgrade base packages, including OpenSSL
RUN apk update && apk upgrade --no-cache && \
    apk add --no-cache openjdk17 bash curl busybox-extras

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set up application directory and permissions
RUN mkdir -p /opt/kafka && chown -R appuser:appgroup /opt/kafka

# Set working directory
WORKDIR /opt/kafka

# Copy Kafka and fixed dependencies from the builder stage
COPY --from=builder /tmp/kafka_2.13-3.8.0 /opt/kafka
COPY --from=builder /tmp/netty-common-4.1.115.Final.jar /opt/kafka/libs/
COPY --from=builder /tmp/jetty-http-12.0.12.jar /opt/kafka/libs/
COPY --from=builder /tmp/jetty-server-12.0.9.jar /opt/kafka/libs/
COPY --from=builder /tmp/commons-io-2.14.0.jar /opt/kafka/libs/
COPY --from=builder /tmp/protobuf-java-3.25.5.jar /opt/kafka/libs/

# Ensure proper permissions for all files
RUN chown -R appuser:appgroup /opt/kafka && chmod -R u+w /opt/kafka

# Remove vulnerable JARs (executed as root to ensure deletion)
RUN rm -f /opt/kafka/libs/netty-common-4.1.110.Final.jar && \
    rm -f /opt/kafka/libs/jetty-http-9.4.54.v20240208.jar && \
    rm -f /opt/kafka/libs/jetty-server-9.4.54.v20240208.jar && \
    rm -f /opt/kafka/libs/commons-io-2.11.0.jar && \
    rm -f /opt/kafka/libs/protobuf-java-3.23.4.jar

# Switch to the non-root user
USER appuser

# Add Kafka CLI to PATH
ENV PATH="/opt/kafka/bin:$PATH"

# Default entrypoint
ENTRYPOINT ["/bin/bash"]
