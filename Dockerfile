FROM alpine:latest
RUN apk update
RUN apk add curl git make gcc libc-dev

ENV ADMIN_USER=admin
ENV ADMIN_PASS=admin

EXPOSE 8199
EXPOSE 8200

RUN git clone https://github.com/skiqqy/cmesg
RUN cd cmesg && make server
RUN ln -s /cmesg/bin/cmesg /bin/cmesg

# Finish Config file, rm the one created by the make file, and create a new one
RUN rm /cmesg/config && echo -e "user $ADMIN_USER\npassw $ADMIN_PASS\nport 8200\n" > /cmesg/config

ENTRYPOINT ["cmesg"]
CMD ["-p", "8199", "-c", "/cmesg/config"]
