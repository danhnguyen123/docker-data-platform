FROM bitnami/spark:3.3

USER root

# Install prerequisites
RUN apt-get update && apt-get install -y curl make gcc wget

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

##################################################### Install Hadoop CLI (Optional) #######################################################    
### Install hadoop ###
# ENV HADOOP_VERSION=3.3.6
# RUN wget -O hadoop.tgz "https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \
#     && mkdir -p /opt/hadoop \
#     && tar -xf hadoop.tgz -C /opt/hadoop --strip-components=1 \
#     && rm hadoop.tgz
# ENV HADOOP_HOME=/opt/hadoop
# ENV PATH=$PATH:$HADOOP_HOME/bin
# # Add classpath jar lib to Hadoop 
# RUN echo "export HADOOP_CLASSPATH=\$HADOOP_CLASSPATH:\$(hadoop classpath):/opt/bitnami/spark/jars/*" >> /opt/hadoop/etc/hadoop/hadoop-env.sh

####################################################### Install Datalake connectors ###########################################################

# AWS S3/Minio Connector 
# Already have hadoop-aws: /opt/bitnami/spark/jars/hadoop-aws-*.jar , aws-java-sdk-bundle-*.jar
RUN curl -O https://repo1.maven.org/maven2/software/amazon/awssdk/s3/2.18.41/s3-2.18.41.jar \
    && curl -O https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/1.11.1026/aws-java-sdk-1.11.1026.jar \
    && curl -O https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.1026/aws-java-sdk-bundle-1.11.1026.jar \
    && curl -O https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.2/hadoop-aws-3.3.2.jar  \
    && mv s3-2.18.41.jar /opt/bitnami/spark/jars \
    && mv aws-java-sdk-1.11.1026.jar /opt/bitnami/spark/jars \
    && mv aws-java-sdk-bundle-1.11.1026.jar /opt/bitnami/spark/jars \
    && mv hadoop-aws-3.3.2.jar /opt/bitnami/spark/jars

# Google Cloud Storage Connector
RUN curl -O https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop3-latest.jar \
    && mv gcs-connector-hadoop3-latest.jar /opt/bitnami/spark/jars

# Microsoft Azure Blob/Data Lake Storage Gen2 Connector
# Already have hadoop-azure if hadoop is installed: /opt/hadoop/share/hadoop/tools/lib/hadoop-azure-*.jar
RUN curl -O https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/3.3.5/hadoop-azure-3.3.5.jar \
    && curl -O https://repo1.maven.org/maven2/com/microsoft/azure/azure-storage/7.0.1/azure-storage-7.0.1.jar \
    && curl -O https://repo1.maven.org/maven2/com/azure/azure-storage-blob/12.14.1/azure-storage-blob-12.14.1.jar \
    && mv hadoop-azure-3.3.5.jar /opt/bitnami/spark/jars \
    && mv azure-storage-7.0.1.jar /opt/bitnami/spark/jars \
    && mv azure-storage-blob-12.14.1.jar /opt/bitnami/spark/jars 

###################################################### Install table format #################################################################

# Delta Lake 
RUN curl -O https://repo1.maven.org/maven2/io/delta/delta-core_2.12/2.2.0/delta-core_2.12-2.2.0.jar \
    && curl -O https://repo1.maven.org/maven2/io/delta/delta-storage/2.2.0/delta-storage-2.2.0.jar \
    && mv delta-core_2.12-2.2.0.jar /opt/bitnami/spark/jars \
    && mv delta-storage-2.2.0.jar /opt/bitnami/spark/jars

# Apache Iceberg    
RUN curl -O https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.3_2.12/1.5.2/iceberg-spark-runtime-3.3_2.12-1.5.2.jar \
    && curl -O https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-hive-runtime/1.5.2/iceberg-hive-runtime-1.5.2.jar \
    && curl -O https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-aws/1.5.2/iceberg-aws-1.5.2.jar \
    && mv iceberg-spark-runtime-3.3_2.12-1.5.2.jar /opt/bitnami/spark/jars \
    && mv iceberg-hive-runtime-1.5.2.jar /opt/bitnami/spark/jars \
    && mv iceberg-aws-1.5.2.jar /opt/bitnami/spark/jars

# Apache Hudi    
RUN curl -O https://repo1.maven.org/maven2/org/apache/hudi/hudi-spark3-bundle_2.12/0.13.1/hudi-spark3-bundle_2.12-0.13.1.jar \
    && mv hudi-spark3-bundle_2.12-0.13.1.jar /opt/bitnami/spark/jars


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