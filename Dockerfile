# build image from small debian
FROM debian:stable-slim
MAINTAINER joeknock

# update container and install dependencies
RUN apt-get update && apt-get install -y \
  git \
  python python-pip

ADD src/init.sh /init.sh

# download python source files
RUN chmod +x /init.sh && \
    git clone https://github.com/vertcoin/p2pool-vtc.git && \
    cd p2pool-vtc/ && \
    rm -rf web-static/ && \
    git clone https://github.com/justino/p2pool-ui-punchy.git && \
    mv p2pool-ui-punchy/ web-static/ && \
    pip install -r requirements.txt && \
    cd lyra2re-hash-python && \
    git submodule init && git submodule update && \
    python setup.py install

# create configuration volume
VOLUME /config /data

# default environment variables
ENV RPC_USER user
ENV RPC_PASSWORD changethisfuckingpassword
ENV VERTCOIND_HOST 127.0.0.1
ENV VERTCOIND_HOST_PORT 5888
ENV FEE 0
ENV MAX_CONNECTIONS 50
ENV FEE_ADDRESS VnfNKCy5Aq7vZq5W9UKgMwfDLT7NrPRWZK
ENV NET vertcoin2


# expose mining port
EXPOSE 9171 9181 9346

ENTRYPOINT ["/init.sh"]
