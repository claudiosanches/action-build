FROM ubuntu:latest

RUN apt-get update && apt-get install -y zip

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]