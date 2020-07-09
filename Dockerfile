# main image --------------------------------------------------------------------------------------------------------- #
FROM node:12-alpine

COPY . /tmp/build

RUN cd /tmp/build && \
    apk add --no-cache --virtual .build-deps git && apk --no-cache add openrc && \
    for i in *.init; do install -m755 $i /etc/init.d/${i%%.init} && rc-update add ${i%%.init}; done && \
    git clone https://github.com/genieacs/genieacs.git && cd genieacs && npm install && npm run build && \
    mv dist /opt/genieacs && apk del --no-cache .build-deps && rm -rf /var/cache/apk/* /tmp/build

VOLUME [ "/sys/fs/cgroup" ]

ENTRYPOINT /sbin/openrc-init

# -------------------------------------------------------------------------------------------------------------------- #
