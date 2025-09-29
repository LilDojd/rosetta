FROM ubuntu:22.04 AS builder
ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get -y update && apt-get -y install --no-install-recommends \
    build-essential clang cmake ninja-build rsync \
    zlib1g-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev libffi-dev \
    python3 python3-dev python3-setuptools python3-distutils python3-venv \
    ca-certificates git curl doxygen graphviz && \
  update-alternatives --install /usr/bin/python python /usr/bin/python3 1

COPY . /opt/rosetta
WORKDIR /opt/rosetta/source

RUN ./scons.py -j6 mode=release cxx=clang extras=static bin
# Stage actual binaries and database with symlinks resolved
WORKDIR /opt/rosetta
# RUN mkdir -p /opt/rosetta/install/bin /opt/rosetta/install/database && \
#     cp -L source/bin/ab_binding.linuxclangrelease /opt/rosetta/install/bin/ && \
#     cp -L source/bin/docking_protocol.linuxclangrelease /opt/rosetta/install/bin/ && \
#     rsync -a database/ /opt/rosetta/install/database/

# FROM ubuntu:22.04 AS runtime
# ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8 LC_ALL=C.UTF-8

# RUN apt-get -y update && apt-get -y install --no-install-recommends \
#     ca-certificates zlib1g libbz2-1.0 libreadline8 libsqlite3-0 liblzma5 libffi8 && \
#     rm -rf /var/lib/apt/lists/*

# COPY --from=builder /opt/rosetta/install /rosetta

# ENV ROSETTA_ROOT=/rosetta \
#     ROSETTA_BIN=/rosetta/bin \
#     ROSETTA_DATABASE=/rosetta/database
# ENV PATH="${ROSETTA_BIN}:${PATH}"

# WORKDIR /work
