FROM alpine:3.7

# Without this goatcounter won't start.
RUN apk --update --no-cache add tzdata
ENV TZ Europe/London

# Get 2.5.0
RUN wget https://github.com/zgoat/goatcounter/releases/download/v2.5.0/goatcounter-v2.5.0-linux-arm64.gz
RUN gunzip goatcounter-v2.5.0-linux-arm64.gz
RUN mv goatcounter-v2.5.0-linux-arm64 goatcounter
RUN chmod a+x goatcounter

# Define build-time arguments
ARG GOATCOUNTER_DOMAIN
ARG GOATCOUNTER_EMAIL
ARG GOATCOUNTER_PASSWORD
ARG GOATCOUNTER_DB

# Use build-time arguments in the RUN command
RUN ./goatcounter db create site -createdb -vhost ${GOATCOUNTER_DOMAIN} -user.email ${GOATCOUNTER_EMAIL} -password ${GOATCOUNTER_PASSWORD}

ENTRYPOINT ./goatcounter serve -listen 0.0.0.0:5000 -tls none
