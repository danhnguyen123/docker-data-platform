FROM apache/hive:4.0.0

USER root

# Install prerequisites
RUN apt-get update && apt-get install -y curl

# Need to connect Postgres metastore-db (not rename /opt/hive/lib/postgres.jar)
RUN curl -O https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.3/postgresql-42.7.3.jar \
    && mv postgresql-42.7.3.jar /opt/hive/lib/postgres.jar

# RUN curl -O https://repo1.maven.org/maven2/software/amazon/awssdk/s3/2.18.41/s3-2.18.41.jar \
#     && curl -O https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/1.11.1026/aws-java-sdk-1.11.1026.jar \
#     && curl -O https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.1026/aws-java-sdk-bundle-1.11.1026.jar \
#     && curl -O https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.2/hadoop-aws-3.3.2.jar  \
#     && mv s3-2.18.41.jar /opt/hive/lib/jars \
#     && mv aws-java-sdk-1.11.1026.jar /opt/hive/lib/jars \
#     && mv aws-java-sdk-bundle-1.11.1026.jar /opt/hive/lib/jars \
#     && mv hadoop-aws-3.3.2.jar /opt/hive/lib/jars

# # Delta Lake 
# RUN curl -O https://repo1.maven.org/maven2/io/delta/delta-core_2.12/2.2.0/delta-core_2.12-2.2.0.jar \
#     && curl -O https://repo1.maven.org/maven2/io/delta/delta-storage/2.2.0/delta-storage-2.2.0.jar \
#     && mv delta-core_2.12-2.2.0.jar /opt/hive/lib/jars \
#     && mv delta-storage-2.2.0.jar /opt/hive/lib/jars
# # Apache Iceberg    
# RUN curl -O https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.3_2.12/1.5.2/iceberg-spark-runtime-3.3_2.12-1.5.2.jar \
#     && curl -O https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-hive-runtime/1.5.2/iceberg-hive-runtime-1.5.2.jar \
#     && curl -O https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-aws/1.5.2/iceberg-aws-1.5.2.jar \
#     && mv iceberg-spark-runtime-3.3_2.12-1.5.2.jar /opt/hive/lib/jars \
#     && mv iceberg-hive-runtime-1.5.2.jar /opt/hive/lib/jars \
#     && mv iceberg-aws-1.5.2.jar /opt/hive/lib/jars 
# # Apache Hudi    
# RUN curl -O https://repo1.maven.org/maven2/org/apache/hudi/hudi-spark3-bundle_2.12/0.13.1/hudi-spark3-bundle_2.12-0.13.1.jar \
#     && mv hudi-spark3-bundle_2.12-0.13.1.jar /opt/hive/lib/jars 

ENV HADOOP_CLASSPATH=/opt/hadoop/share/hadoop/tools/lib/*:/opt/hive/lib/jars/*

COPY metastore-site.xml /opt/hive/conf