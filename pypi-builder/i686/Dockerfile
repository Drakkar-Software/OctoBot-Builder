FROM quay.io/pypa/manylinux1_i686:latest

WORKDIR /builder
COPY build.sh .
RUN yum install -y libffi-devel.i386 openssl-devel libssl-devel python-devel \
    && chmod +x build.sh \
    && mkdir /project

CMD ["/bin/sh", "/builder/build.sh"]
