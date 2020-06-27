FROM alpine:latest

LABEL maintainer="Varun Sridharan <varunsridharan23@gmail.com>"

RUN apk add lftp

RUN apk add zip

RUN apk add rsync

COPY entrypoint.sh /entrypoint.sh

COPY scripts /envato-action-scripts/

RUN chmod +x /*.sh
RUN chmod -R 777 /envato-action-scripts/

ENTRYPOINT ["/entrypoint.sh"]