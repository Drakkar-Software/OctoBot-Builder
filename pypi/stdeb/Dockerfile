ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION}-slim-stretch

WORKDIR /builder
COPY build.sh .
RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential gcc wget libblas-dev liblapack-dev unzip libffi-dev libssl-dev patchelf fakeroot python-stdeb python-all-dev python3-all-dev debhelper python-setuptools python3-setuptools apt-file python-requests \
    && chmod +x build.sh \
    && mkdir /project

ENV PYTHON_PATH="/usr/local/bin"
ENV BUILD_TYPE="STDEB"

CMD ["/bin/sh", "/builder/build.sh"]
