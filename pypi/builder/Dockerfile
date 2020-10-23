ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-slim-stretch

WORKDIR /builder
COPY build.sh .
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential gcc libblas-dev liblapack-dev wget unzip libffi-dev libssl-dev patchelf \
    && chmod +x build.sh \
    && mkdir /project

ENV PYTHON_PATH="/usr/local/bin"
ENV BUILD_TYPE="WHEEL"

CMD ["/bin/sh", "/builder/build.sh"]
