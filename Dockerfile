# build image from small debian
FROM debian:stable-slim
MAINTAINER firrae

# update container and install dependencies
RUN apt-get -y update && apt-get install -y python-rrdtool python-pygame python-scipy python-twisted python-twisted-web python-imaging git make

ADD src/init.sh /init.sh
RUN chmod +x /init.sh

RUN mkdir /src
WORKDIR /src
RUN cd /src && git clone https://github.com/vertcoin-project/verthash-pospace
WORKDIR /src/verthash-pospace/tiny_sha3
RUN git submodule init
RUN git submodule update
WORKDIR /src/verthash-pospace
RUN make all
RUN python setup.py install
WORKDIR /src/
RUN git clone https://github.com/vertcoin-project/p2pool-vtc.git && \
    cd p2pool-vtc/ && \
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
EXPOSE 9171 9181 9346 9347

ENTRYPOINT ["/init.sh"]
