FROM python:3.7.7-slim-stretch

WORKDIR /builder
COPY build.sh .
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential gcc libffi-dev libssl-dev \
    && chmod +x build.sh \
    && mkdir /project

CMD ["/bin/sh", "/builder/build.sh"]
