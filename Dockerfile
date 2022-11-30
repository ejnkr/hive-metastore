FROM openjdk:8u282-jre-slim-buster

# CI tool should parses below line to determine the image version
ENV VERSION=0.0.5


ENV HADOOP_VERSION=3.3.1
ENV METASTORE_VERSION=3.1.2
ENV POSTGRESQL_VERSION=42.2.18

ENV HADOOP_HOME=/opt/hadoop
ENV HIVE_HOME=/opt/metastore

RUN apt-get update && apt-get -qq -y install curl

RUN curl -o hadoop.tar.gz http://apache.mirrors.hoobly.com/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
  tar -xf hadoop.tar.gz && \
  rm hadoop.tar.gz && \
  mv hadoop-${HADOOP_VERSION} ${HADOOP_HOME} && \
  rm -rf ${HADOOP_HOME}/share/doc/

RUN curl -o metastore.tar.gz https://repo1.maven.org/maven2/org/apache/hive/hive-standalone-metastore/${METASTORE_VERSION}/hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz && \
  tar -xf metastore.tar.gz && \
  rm metastore.tar.gz && \
  mv apache-hive-metastore-${METASTORE_VERSION}-bin ${HIVE_HOME} && \
  rm -f ${HIVE_HOME}/lib/guava-19.0.jar && \
  cp ${HADOOP_HOME}/share/hadoop/common/lib/guava-27.0-jre.jar ${HIVE_HOME}/lib/ && \
  cp ${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-${HADOOP_VERSION}.jar ${HIVE_HOME}/lib/ && \
  cp ${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-bundle-*.jar ${HIVE_HOME}/lib/

RUN curl -o postgresql-${POSTGRESQL_VERSION}.jar https://jdbc.postgresql.org/download/postgresql-${POSTGRESQL_VERSION}.jar && \
  mv postgresql-${POSTGRESQL_VERSION}.jar ${HIVE_HOME}/lib/


WORKDIR ${HIVE_HOME}

EXPOSE 9083

ENTRYPOINT /opt/metastore/bin/start-metastore

#COPY entrypoint /bin/entrypoint

#ENTRYPOINT /bin/entrypoint
