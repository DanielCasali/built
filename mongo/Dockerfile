FROM mongo:3
RUN rm -f /data/db/.firstrun && rm -rf /opt/*
# Make the new dir a VOLUME to persist it
ENTRYPOINT ["/usr/bin/mongod","--dbpath","/data/db","--bind_ip_all" ]
