FROM elmarit/harbour:3.4 as builder
WORKDIR /app
COPY ./harbour/src/ /app/
RUN hbmk2 -fullstatic cms.hbp cms.hbc -ocms 

FROM ubuntu:latest
COPY --from=builder /app/* /app/
#RUN apt-get update && apt-get install -y curl 
WORKDIR /app

CMD ["./cms"]