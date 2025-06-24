FROM tomcat:10.0.27-jdk8

# Xóa webapp mặc định để tránh xung đột
RUN rm -rf /usr/local/tomcat/webapps/*

# Tạo thư mục cho application
RUN mkdir -p /usr/local/tomcat/webapps

# Copy WAR file từ NetBeans build output
# Thường ở thư mục dist/ sau khi clean and build
COPY dist/*.war /usr/local/tomcat/webapps/ROOT.war

# Copy JDBC driver cho SQL Server (nếu chưa có trong WAR)
# Download từ: https://docs.microsoft.com/en-us/sql/connect/jdbc/download-microsoft-jdbc-driver-for-sql-server
COPY lib/*.jar /usr/local/tomcat/lib/

# Tạo thư mục logs
RUN mkdir -p /usr/local/tomcat/logs && \
    chmod 755 /usr/local/tomcat/logs

# Set environment variables
ENV CATALINA_OPTS="-Xms512m -Xmx1024m -XX:PermSize=64m -XX:MaxPermSize=128m"
ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom"

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"]
