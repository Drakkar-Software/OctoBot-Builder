FROM quay.io/pypa/manylinux2014_x86_64:latest

WORKDIR /builder
COPY build.sh .
RUN yum install -y libffi libffi-devel openssl-devel wget unzip  blas-devel lapack-devel libxml2-devel libxslt-devel \
    && chmod +x build.sh \
    && mkdir /project

ENV PYTHON_PATH="/opt/python/${PYTHON_VERSION}/bin"
ENV BUILD_TYPE="WHEEL"

CMD ["/bin/sh", "/builder/build.sh"]
