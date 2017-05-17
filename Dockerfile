FROM docker-hdp/centos-base:1.0
MAINTAINER Arturo Bayo <arturo.bayo@gmail.com>
USER root

# Configure environment variables
ENV ZOO_LOG_DIR /var/log/zookeeper
ENV ZOO_PID_DIR /var/run/zookeeper
ENV ZOO_CONF_DIR /etc/zookeeper/conf
ENV ZOO_DATA_DIR /grid/hadoop/zookeeper/data
ENV ZOO_USER zookeeper
ENV ZOO_PORT 2181
ENV ZOO_JVMOPTS=-Xmx1024m

# Install software
RUN yum clean all
RUN yum -y install zookeeper-server

# Configure zookeeper directories
RUN mkdir -p $ZOO_CONF_DIR && chmod a+x $ZOO_CONF_DIR/ && chown -R $ZOO_USER:$HADOOP_GROUP $ZOO_CONF_DIR/../ && chmod -R 755 $ZOO_CONF_DIR/../
RUN mkdir -p $ZOO_LOG_DIR && chown -R $ZOO_USER:$HADOOP_GROUP $ZOO_LOG_DIR && chmod -R 755 $ZOO_LOG_DIR
RUN mkdir -p $ZOO_PID_DIR && chown -R $ZOO_USER:$HADOOP_GROUP $ZOO_PID_DIR && chmod -R 755 $ZOO_PID_DIR
RUN mkdir -p $ZOO_DATA_DIR && chmod -R 755 $ZOO_DATA_DIR && chown -R $ZOO_USER:$HADOOP_GROUP $ZOO_DATA_DIR

# Copy configuration files
COPY tmp/conf/ $ZOO_CONF_DIR/
RUN chown -R $ZOO_USER:$HADOOP_GROUP $ZOO_CONF_DIR

# Expose volumes
VOLUME $ZOO_LOG_DIR

# Expose ports
EXPOSE $ZOO_PORT

# Deploy entrypoint
COPY files/entrypoint.sh /opt/run/00_zookeeper-server.sh
RUN chmod +x /opt/run/00_zookeeper-server.sh

# Determine running user
#USER zookeeper

# Execute entrypoint
ENTRYPOINT ["/opt/bin/run_all.sh"]

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --retries=5 \
  CMD curl -f http://localhost:$ZOO_PORT/ || exit 1