FROM python:3.7.7-slim-stretch

WORKDIR /builder
COPY build.sh .
RUN chmod +x build.sh && mkdir /project

CMD ["./build.sh"]
