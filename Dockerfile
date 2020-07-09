# main image --------------------------------------------------------------------------------------------------------- #
FROM node:12-alpine

COPY . /tmp/build

RUN cd /tmp/build && \
    apk add --no-cache --virtual .build-deps git && apk --no-cache add openrc && \
    for i in *.init; do install -m755 $i /etc/init.d/${i%%.init} && rc-update add ${i%%.init}; done && \
    git clone https://github.com/genieacs/genieacs.git && cd genieacs && npm install && npm run build && \
    mv dist /opt/genieacs && cd /opt/genieacs && npm install && \
    sed -i 's/.*\(rc_env_allow\).*/\1="\*"/g' /etc/rc.conf && cd /etc/init.d && rm -f cgroups hw* mod* && \
    apk del --no-cache .build-deps && rm -rf /var/cache/apk/* /tmp/build

ENTRYPOINT /sbin/openrc-init

# -------------------------------------------------------------------------------------------------------------------- #
