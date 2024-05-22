FROM apache/hive:4.0.0

USER root

# Install prerequisites
RUN apt-get update && apt-get install -y curl

RUN curl -O https://repo1.maven.org/maven2/org/postgresql/postgresql/42.7.3/postgresql-42.7.3.jar \
    && mv postgresql-42.7.3.jar /opt/hive/lib/postgres.jar

ENV export HADOOP_CLASSPATH=/opt/hadoop/share/hadoop/tools/lib/*

COPY metastore-site.xml /opt/hive/conf