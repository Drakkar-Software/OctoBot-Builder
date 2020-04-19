FROM quay.io/pypa/manylinux1_x86_64:latest

WORKDIR /builder
COPY build.sh .
RUN yum install -y libffi-devel.i386 openssl-devel libssl-devel python-devel patchelf \
    && chmod +x build.sh \
    && mkdir /project

ENV PYTHON_PATH="/opt/python/cp37-cp37m/bin"
ENV BUILD_TYPE="WHEEL"

CMD ["/bin/sh", "/builder/build.sh"]
