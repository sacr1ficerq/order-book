# I generated this Dockerfile with help of LLM. 
# I used simpler install script with apt and "./llvm.sh 18" which
# included "curl-bash" anti-pattern. Apperently it's a security fault.

FROM ubuntu:24.04

ARG CLANG_VERSION=20

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    gnupg \
    wget \
    build-essential \
    cmake \
    vim \
    protobuf-compiler \
    libprotobuf-dev \
    linux-tools-$(uname -r) \
    linux-tools-common \
    git && \
    # add LLVM GPG key and repository directly
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | gpg --dearmor > /etc/apt/trusted.gpg.d/llvm-archive-keyring.gpg && \
    echo "deb http://apt.llvm.org/noble/ llvm-toolchain-noble-${CLANG_VERSION} main" > /etc/apt/sources.list.d/llvm.list && \
    # update package list and install the full clang toolchain
    apt-get update && \
    apt-get install -y --no-install-recommends \
    clang-${CLANG_VERSION} \
    lld-${CLANG_VERSION} \
    libc++-${CLANG_VERSION}-dev \
    libc++abi-${CLANG_VERSION}-dev && \
    # clean up apt cache to reduce final image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# set up alternatives to use the new clang version as the default compiler and linker
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang-${CLANG_VERSION} 100 && \
    update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-${CLANG_VERSION} 100 && \
    update-alternatives --install /usr/bin/clang clang /usr/bin/clang-${CLANG_VERSION} 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-${CLANG_VERSION} 100 && \
    update-alternatives --install /usr/bin/lld lld /usr/bin/lld-${CLANG_VERSION} 100

WORKDIR /workspace

CMD ["bash"]
