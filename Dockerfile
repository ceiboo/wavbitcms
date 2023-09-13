FROM elmarit/harbour:3.2 as builder
WORKDIR /app
COPY ./src/*.* /app/
RUN apt-get install libmysqlclient-dev
RUN hbmk2 -fullstatic cms.hbp -ocms -llibmysql

FROM alpine:latest
COPY --from=builder /app/* /app/
WORKDIR /app
RUN apt-get install libmysqlclient-dev
CMD ["./cms"]