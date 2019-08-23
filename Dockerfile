FROM composer:1
LABEL maintainer="Varun Sridharan <varunsridharan23@gmail.com>"

RUN apk add lftp
RUN apk add zip
RUN apk add rsync

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /*.sh
ENTRYPOINT ["/entrypoint.sh"]