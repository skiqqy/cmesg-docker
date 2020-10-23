FROM alpine:latest
RUN apk update
RUN apk add curl git make gcc libc-dev

# Setup ports and paths
ENV PORT=8199
ENV ADMIN_PORT=8200

#EXPOSE 8199
#EXPOSE 8200
EXPOSE $PORT
EXPOSE $ADMIN_PORT

# Setup defualt access
RUN export ADMIN_USER="admin" && \
	export ADMIN_PASS="admin" && \
	export ADMIN_PATH=/cmesg/config && \
	export PORT=8199 && \
	export ADMIN_PORT=8200

RUN git clone https://github.com/skiqqy/cmesg
RUN cd cmesg && make server
RUN ln -s /cmesg/bin/cmesg /bin/cmesg

# Finish Config file, rm the one created by the make file, and create a new one
RUN rm /cmesg/config && echo "user $ADMIN_USER\npassw $ADMIN_PASS\nport $ADMIN_PORT\n" > /cmesg/config

ENTRYPOINT ["cmesg"]
CMD ["-p", "$PORT", "-c", "/cmesg/config"]
