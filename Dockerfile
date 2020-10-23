FROM alpine:latest
RUN apk update
RUN apk add curl git make gcc libc-dev

# Setup ports and paths
ENV ADMIN_PATH=/cmesg/config
ENV PORT=8199
ENV ADMIN_PORT=8200
EXPOSE 8199
EXPOSE 8200

# Setup defualt access
RUN export ADMIN_USER="admin" && export ADMIN_PASS="admin"
RUN git clone https://github.com/skiqqy/cmesg
RUN cd cmesg && make server
RUN ln -s /cmesg/bin/cmesg /bin/cmesg

# Finish Config file, rm the one created by the make file, and create a new one
RUN rm $ADMIN_PATH && echo "user $ADMIN_USER\npassw $ADMIN_PASS\nport $ADMIN_PORT\n"

ENTRYPOINT ["cmesg"]
CMD ["-p", "$PORT", "-c", "$ADMIN_PATH"]
