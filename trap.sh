#!/usr/bin/env bash
set -x

pid=0

# SIGUSR1-handler
my_handler() {
  echo "my_handler"
}

# SIGTERM-handler
term_handler() {
  if [ $pid -ne 0 ]; then
    echo "TERM HANDLER"
    kill -SIGTERM "$pid"
    wait "$pid"
  fi
  exit 143; # 128 + 15 -- SIGTERM
}

int_handler() {
  if [ $pid -ne 0 ]; then
    echo "INT HANDLER"
    kill -SIGTERM "$pid"
    wait "$pid"
  fi
  exit 143; # 128 + 9 -- SIGTERM
}

# setup handlers
# on callback, kill the last background process, which is `tail -f /dev/null` and execute the specified handler
trap 'kill ${!}; my_handler' SIGUSR1
trap 'kill ${!}; term_handler' SIGTERM
trap 'kill ${!}; int_handler' SIGINT

# run application
CONSOLE_LOG=/var/lib/neo4j/data/log/console.log
#CONSOLE_LOG=/tmp/testpipe
#mkfifo ${CONSOLE_LOG}
CLASSPATH=/var/lib/neo4j/lib/concurrentlinkedhashmap-lru-1.3.1.jar:/var/lib/neo4j/lib/geronimo-jta_1.1_spec-1.1.1.jar:/var/lib/neo4j/lib/lucene-core-3.6.2.jar:/var/lib/neo4j/lib/neo4j-cypher-2.1.8.jar:/var/lib/neo4j/lib/neo4j-cypher-commons-2.1.8.jar:/var/lib/neo4j/lib/neo4j-cypher-compiler-1.9-2.0.3.jar:/var/lib/neo4j/lib/neo4j-cypher-compiler-2.0-2.0.3.jar:/var/lib/neo4j/lib/neo4j-cypher-compiler-2.1-2.1.8.jar:/var/lib/neo4j/lib/neo4j-graph-algo-2.1.8.jar:/var/lib/neo4j/lib/neo4j-graph-matching-2.1.8.jar:/var/lib/neo4j/lib/neo4j-jmx-2.1.8.jar:/var/lib/neo4j/lib/neo4j-kernel-2.1.8.jar:/var/lib/neo4j/lib/neo4j-lucene-index-2.1.8.jar:/var/lib/neo4j/lib/neo4j-primitive-collections-2.1.8.jar:/var/lib/neo4j/lib/neo4j-shell-2.1.8.jar:/var/lib/neo4j/lib/neo4j-udc-2.1.8.jar:/var/lib/neo4j/lib/opencsv-2.3.jar:/var/lib/neo4j/lib/org.apache.servicemix.bundles.jline-0.9.94_1.jar:/var/lib/neo4j/lib/parboiled-core-1.1.6.jar:/var/lib/neo4j/lib/parboiled-scala_2.10-1.1.6.jar:/var/lib/neo4j/lib/scala-library-2.10.4.jar:/var/lib/neo4j/lib/server-api-2.1.8.jar:/var/lib/neo4j/system/lib/asm-3.1.jar:/var/lib/neo4j/system/lib/bcprov-jdk16-140.jar:/var/lib/neo4j/system/lib/commons-beanutils-1.8.0.jar:/var/lib/neo4j/system/lib/commons-beanutils-core-1.8.0.jar:/var/lib/neo4j/system/lib/commons-collections-3.2.1.jar:/var/lib/neo4j/system/lib/commons-compiler-2.6.1.jar:/var/lib/neo4j/system/lib/commons-configuration-1.6.jar:/var/lib/neo4j/system/lib/commons-digester-1.8.1.jar:/var/lib/neo4j/system/lib/commons-io-1.4.jar:/var/lib/neo4j/system/lib/commons-lang-2.4.jar:/var/lib/neo4j/system/lib/commons-logging-1.1.1.jar:/var/lib/neo4j/system/lib/jackson-core-asl-1.9.7.jar:/var/lib/neo4j/system/lib/jackson-jaxrs-1.9.7.jar:/var/lib/neo4j/system/lib/jackson-mapper-asl-1.9.7.jar:/var/lib/neo4j/system/lib/janino-2.6.1.jar:/var/lib/neo4j/system/lib/javax.servlet-3.0.0.v201112011016.jar:/var/lib/neo4j/system/lib/jcl-over-slf4j-1.6.1.jar:/var/lib/neo4j/system/lib/jersey-core-1.9.jar:/var/lib/neo4j/system/lib/jersey-multipart-1.9.jar:/var/lib/neo4j/system/lib/jersey-server-1.9.jar:/var/lib/neo4j/system/lib/jetty-http-9.0.5.v20130815.jar:/var/lib/neo4j/system/lib/jetty-io-9.0.5.v20130815.jar:/var/lib/neo4j/system/lib/jetty-security-9.0.5.v20130815.jar:/var/lib/neo4j/system/lib/jetty-server-9.0.5.v20130815.jar:/var/lib/neo4j/system/lib/jetty-servlet-9.0.5.v20130815.jar:/var/lib/neo4j/system/lib/jetty-util-9.0.5.v20130815.jar:/var/lib/neo4j/system/lib/jetty-webapp-9.0.5.v20130815.jar:/var/lib/neo4j/system/lib/jetty-xml-9.0.5.v20130815.jar:/var/lib/neo4j/system/lib/jsr311-api-1.1.2.r612.jar:/var/lib/neo4j/system/lib/logback-access-1.1.2.jar:/var/lib/neo4j/system/lib/logback-classic-1.1.2.jar:/var/lib/neo4j/system/lib/logback-core-1.1.2.jar:/var/lib/neo4j/system/lib/mimepull-1.6.jar:/var/lib/neo4j/system/lib/neo4j-browser-2.1.8.jar:/var/lib/neo4j/system/lib/neo4j-server-2.1.8-static-web.jar:/var/lib/neo4j/system/lib/neo4j-server-2.1.8.jar:/var/lib/neo4j/system/lib/opencsv-2.3.jar:/var/lib/neo4j/system/lib/rhino-1.7R4.jar:/var/lib/neo4j/system/lib/rrd4j-2.0.7.jar:/var/lib/neo4j/system/lib/slf4j-api-1.6.2.jar:/var/lib/neo4j/conf/
/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java -cp $CLASSPATH -server \
	-XX:+DisableExplicitGC -Dorg.neo4j.server.properties=conf/neo4j-server.properties \
	-Djava.util.logging.config.file=conf/logging.properties \
	-Dlog4j.configuration=file:conf/log4j.properties \
	-XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:-OmitStackTraceInFastThrow \
	-Dneo4j.home=/var/lib/neo4j -Dneo4j.instance=/var/lib/neo4j -Dfile.encoding=UTF-8 \
	org.neo4j.server.Bootstrapper > ${CONSOLE_LOG} &
pid="$!"

# wait forever
while true
do
	tail -f ${CONSOLE_LOG} & wait ${!}
done