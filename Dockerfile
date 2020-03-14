FROM alpine:3.10
LABEL maintainer="Canyan Engineering Team <team@canyan.io>"
ENV VERSION 1.0.0

RUN true \
    && apk add --update \
        bash \
        sipsak \
        sngrep \
        curl \
        netcat-openbsd \
        kamailio \
        kamailio-db \
        kamailio-dbtext \
        kamailio-jansson \
        kamailio-json \
        kamailio-utils \
        kamailio-extras \
        kamailio-outbound \
        kamailio-http_async \
        kamailio-ev

RUN mkdir -p /etc/kamailio
COPY kamailio/kamailio.cfg /etc/kamailio/kamailio.cfg
COPY kamailio/dispatcher.list /etc/kamailio/dispatcher.list

ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
CMD ["/docker-entrypoint.sh"]
