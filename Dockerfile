FROM alpine
RUN apk update && apk add jq bash curl coreutils util-linux
COPY ./piratebay.sh /bin
RUN chmod 755 /bin/piratebay.sh
ENTRYPOINT ["/bin/piratebay.sh"]
