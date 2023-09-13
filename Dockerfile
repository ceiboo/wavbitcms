FROM elmarit/harbour:3.2 as builder
WORKDIR /app
COPY ./src/*.* /app/
RUN hbmk2 -fullstatic cms.hbp -ocms 

FROM alpine:latest
COPY --from=builder /app/* /app/
WORKDIR /app
CMD ["./cms"]