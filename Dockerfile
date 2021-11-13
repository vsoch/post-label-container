ARG base=ubuntu:20.04
FROM $base

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles

RUN apt update -y \
  && apt install -y \
      autoconf \
      automake \
      bzip2 \
      clang \
      cpio \
      curl \
      file \
      findutils \
      g++ \
      gcc \
      gettext \
      gfortran \ 
      git \
      gpg \
      iputils-ping \
      jq \
      libffi-dev \
      libssl-dev \
      libtool \
      libxml2-dev \
      locales \
      locate \
      m4 \
      make \
      mercurial \
      ncurses-dev \
      patch \
      patchelf \
      pciutils \
      python3-pip \
      rsync \
      unzip \
      wget \
      xz-utils \
      zlib1g-dev \
  && locale-gen en_US.UTF-8 \
  && apt autoremove --purge \
  && apt clean \
  && ln -s /usr/bin/gpg /usr/bin/gpg2 \
  && ln -s `which python3` /usr/bin/python

RUN python -m pip install --upgrade pip setuptools wheel \
 && python -m pip install gnureadline boto3 pyyaml pytz minio requests clingo \
 && rm -rf ~/.cache

ENV SPACK_ROOT=/opt/spack
    
RUN git clone --depth 1 -b vsoch/db-1 https://github.com/vsoch/spack /opt/spack && \
    cd /opt/spack && \
    . share/spack/setup-env.sh && \
    spack compiler find

CMD ["/bin/bash"]

ENV PATH=/opt/spack/bin:$PATH \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility \
    LANGUAGE=en_US:en \
    LANG=en_US.UTF-8
