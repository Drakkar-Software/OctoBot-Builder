FROM quay.io/pypa/manylinux2014_i686:latest

WORKDIR /builder
COPY build.sh .
RUN yum install -y libffi libffi-devel openssl-devel wget unzip blas-devel lapack-devel \
    && chmod +x build.sh \
    && mkdir /project

ENV PYTHON_PATH="/opt/python/cp37-cp37m/bin"
ENV BUILD_TYPE="WHEEL"

CMD ["/bin/sh", "/builder/build.sh"]
