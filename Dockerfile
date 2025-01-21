FROM alpine:3.20
MAINTAINER likinio365 <basilislikollari@gmail.com>

COPY repositories /etc/apk/repositories
COPY init.sh /init.sh

RUN apk add --update bash openssh-client && \
    rm -rf /var/cache/apk/* && \
    chmod +x /init.sh && \
    echo -e 'Host *\nStrictHostKeyChecking no' >> /etc/ssh/ssh_config

# Copy SSH keys and set permissions
CMD rm -rf /root/.ssh && mkdir /root/.ssh && cp -R /root/ssh/* /root/.ssh/ && chmod -R 600 /root/.ssh/*

ENTRYPOINT ["/init.sh"]
