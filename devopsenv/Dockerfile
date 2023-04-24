FROM ubuntu:22.04
LABEL maintainer "Antonio Di Motta"

# install base tools
RUN apt update \
    && apt install -y \
        ca-certificates \
        apt-transport-https \
        lsb-release \
        gnupg \
        curl \
        wget \
        git > /dev/null

# install kubectl
RUN curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list \
    && apt update \
    && apt install -y kubectl

# install programming languages runtime
RUN apt install -y \
    python3 \
    nodejs \
    npm > /dev/null

# install az-cli
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

ENTRYPOINT	["/bin/bash"]