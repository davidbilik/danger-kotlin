FROM ackee/gitlab-builder-android

# nvm environment variables
ENV NVM_DIR=/usr/local/nvm \
    NODE_VERSION=12.2.0

# install nvm
# https://github.com/creationix/nvm#install-script
RUN mkdir $NVM_DIR && \
    curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.37.2/install.sh | bash

RUN source $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH=$NVM_DIR/v$NODE_VERSION/lib/node_modules \
    PATH=$NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# install make which is needed in danger-kotlin install phase
RUN apt-get update && apt-get install -y \
    make

# install danger-js which is needed for danger-kotlin to work
RUN npm install -g danger@10.2.1

# install kotlin compiler
RUN curl -o kotlin-compiler.zip -L https://github.com/JetBrains/kotlin/releases/download/v1.4.10/kotlin-compiler-1.4.10.zip && \
    unzip -d /usr/local/ kotlin-compiler.zip && \
    rm -rf kotlin-compiler.zip

# install danger-kotlin
RUN git clone https://github.com/danger/kotlin.git _danger-kotlin && \
    cd _danger-kotlin && git checkout 0.7.1 && \
    make install  && \
    cd ..  && \
    rm -rf _danger-kotlin

# setup environment variables
ENV PATH=$PATH:/usr/local/kotlinc/bin

VOLUME /root/.gradle