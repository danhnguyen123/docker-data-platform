FROM bitnami/spark:3.3

USER root

# Install prerequisites
RUN apt-get update && apt-get install -y curl make gcc

RUN apt-get install -y --no-install-recommends \
    rsync && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ENV SPARK_HOME /opt/bitnami/spark
# ENV SPARK_CONF_DIR="$SPARK_HOME/conf"
# ENV SPARK_MASTER="spark://spark-master:7077"
# ENV SPARK_MASTER_HOST spark-master
# ENV SPARK_MASTER_PORT 7077
# ENV PYSPARK_PYTHON python3

RUN curl -O https://repo1.maven.org/maven2/software/amazon/awssdk/s3/2.18.41/s3-2.18.41.jar \
    && curl -O https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/1.12.367/aws-java-sdk-1.12.367.jar \
    && curl -O https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.1026/aws-java-sdk-bundle-1.11.1026.jar \
    && curl -O https://repo1.maven.org/maven2/io/delta/delta-core_2.12/2.2.0/delta-core_2.12-2.2.0.jar \
    && curl -O https://repo1.maven.org/maven2/io/delta/delta-storage/2.2.0/delta-storage-2.2.0.jar \
    && curl -O https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.2/hadoop-aws-3.3.2.jar  \
    && mv s3-2.18.41.jar /opt/bitnami/spark/jars \
    && mv aws-java-sdk-1.12.367.jar /opt/bitnami/spark/jars \
    && mv aws-java-sdk-bundle-1.11.1026.jar /opt/bitnami/spark/jars \
    && mv delta-core_2.12-2.2.0.jar /opt/bitnami/spark/jars \
    && mv delta-storage-2.2.0.jar /opt/bitnami/spark/jars \
    && mv hadoop-aws-3.3.2.jar /opt/bitnami/spark/jars

# Create and event logging directory to store job logs
RUN mkdir /tmp/spark-events

# RUN mkdir /opt/bitnami/spark/assets
COPY ./setup.sql ./
COPY ./count.sql ./
COPY ./tpch-dbgen ./tpch-dbgen/

RUN chmod u+x /opt/bitnami/spark/sbin/* && \
    chmod u+x /opt/bitnami/spark/bin/*

COPY ./conf/metrics.properties "$SPARK_HOME/conf/metrics.properties"
COPY ./conf/hive-site.xml "$SPARK_HOME/conf/hive-site.xml"
COPY ./conf/spark-defaults.conf "$SPARK_HOME/conf/spark-defaults.conf"

# COPY entrypoint.sh .

# ENTRYPOINT ["./entrypoint.sh"]