FROM node:14.8.0-stretch

RUN mkdir -p /usr/src/app && chown node:node /usr/src/app

USER node:node 

WORKDIR /usr/src/app

COPY --chown=node:node . . 

RUN npm install && \
    npm install redis@0.8.1 && \
    npm install pg@4.1.1 && \
    npm install memcached@2.2.2 && \
    npm install aws-sdk@2.738.0 && \
    npm install rethinkdbdash@2.3.31

ENV HOST=0.0.0.0 \
    PORT=7777 \
    KEY_LENGTH=10 \
    MAX_LENGTH=400000 \
    STATIC_MAX_AGE=86400 \
    RECOMPRESS_STATIC_ASSETS=true \
    DOCUMENTS=about=./about.md \
    # Storage
    STORAGE_TYPE=file \
    STORAGE_FILEPATH= \
    STORAGE_HOST= \
    STORAGE_PORT= \
    STORAGE_EXPIRE_SECONDS= \
    STORAGE_DB= \
    STORAGE_AWS_BUCKET= \
    STORAGE_AWS_REGION= \
    STORAGE_USERNAME= \
    STORAGE_PASSWORD= \
    # Logging
    LOGGING_LEVEL=verbose \
    LOGGING_TYPE=Console \
    LOGGING_COLORIZE=true \
    # Key Generator
    KEYGENERATOR_TYPE=phonetic \
    KEYGENERATOR_KEYSPACE= \
    # Rate Limits
    RATELIMITS_NORMAL_TOTAL_REQUESTS=500\
    RATELIMITS_NORMAL_EVERY_MILLISECONDS=60000 \
    RATELIMITS_WHITELIST_TOTAL_REQUESTS= \
    RATELIMITS_WHITELIST_EVERY_MILLISECONDS=  \
    RATELIMITS_WHITELIST= \
    RATELIMITS_BLACKLIST_TOTAL_REQUESTS= \
    RATELIMITS_BLACKLIST_EVERY_MILLISECONDS= \
    RATELIMITS_BLACKLIST=

EXPOSE ${PORT}
STOPSIGNAL SIGINT
ENTRYPOINT ["/bin/sh", "./docker-entrypoint.sh"]

HEALTHCHECK CMD curl --fail ${HOST}:${PORT} || exit 1

CMD ["node", "server.js"]