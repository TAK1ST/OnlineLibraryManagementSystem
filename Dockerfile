FROM tomcat:10.0.27-jdk8

# Cài đặt curl cho HEALTHCHECK
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Xóa webapp mặc định
RUN rm -rf /usr/local/tomcat/webapps/*

# Tạo thư mục cho application
RUN mkdir -p /usr/local/tomcat/webapps

# Copy WAR file
COPY dist/*.war /usr/local/tomcat/webapps/OnlineLibraryManagementSystem.war

# Copy JDBC driver
COPY lib/*.jar /usr/local/tomcat/lib/

# Tải driver nếu cần
# RUN curl -L -o /usr/local/tomcat/lib/mssql-jdbc.jar https://github.com/microsoft/mssql-jdbc/releases/download/v12.8.1/mssql-jdbc-12.8.1.jre8.jar

# Tạo thư mục logs
RUN mkdir -p /usr/local/tomcat/logs && \
    chmod 755 /usr/local/tomcat/logs

# Sửa cổng Tomcat
RUN sed -i 's/Connector port="8080"/Connector port="8084"/' /usr/local/tomcat/conf/server.xml

# Set environment variables
ENV CATALINA_OPTS="-Xms512m -Xmx1024m"
ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom"

# Expose port
EXPOSE 8084

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8084/ || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"]