FROM alpine:3.14
RUN apk add --no-cache openssh-client-default
COPY ssh-tunnel.sh .
CMD ["./ssh-tunnel.sh"]
