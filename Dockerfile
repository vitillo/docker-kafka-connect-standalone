FROM confluent/platform:3.0.0
MAINTAINER ra.vitillo@gmail.com

ENV DOCKERIZE_VERSION v0.2.0

RUN apt-get update && \
    wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

ADD resources/connect-standalone.properties.template connect-standalone.properties.template
ADD resources/entrypoint.sh entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
CMD ["connect-standalone connect-standalone.properties connector.properties"]
