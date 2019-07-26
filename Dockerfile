FROM debian:stretch-slim as phase0

WORKDIR /root

RUN apt-get update && apt-get install unzip

COPY instantclient-sqlplus-linux.x64-18.5.0.0.0dbru.zip   /root
COPY instantclient-basiclite-linux.x64-18.5.0.0.0dbru.zip /root

RUN unzip instantclient-sqlplus-linux.x64-18.5.0.0.0dbru.zip
RUN unzip instantclient-basiclite-linux.x64-18.5.0.0.0dbru.zip


FROM debian:stretch-slim

COPY --from=phase0 /root/instantclient_18_5 /root/instantclient_18_5

RUN apt-get update && apt-get install libaio1
RUN echo 'declare -x LD_LIBRARY_PATH=/root/instantclient_18_5' >> /root/.bashrc
RUN echo 'declare -x PATH="$PATH:/root/instantclient_18_5"'    >> /root/.bashrc

ADD entry.sh /root/

ENTRYPOINT ["/root/entry.sh"]
CMD ["--help"]
