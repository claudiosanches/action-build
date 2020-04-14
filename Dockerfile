FROM ubuntu:latest

ENV TZ=GMT+0
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y build-essential zip
RUN apt-get install -y nodejs wget php
RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer -O - -q | php -- --quiet

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]