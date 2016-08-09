##docker-kafka-connect-standalone
Dockerized standalone Kafka Connect

###Build
docker build -t mozdata/docker-kafka-connect-standalone:${VERSION} .

###Docker Hub
docker push mozdata/docker-kafka-connect-standalone:${VERSION}
