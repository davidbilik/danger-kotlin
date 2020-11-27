FROM node:12.20.0-buster

RUN apt-get update && apt-get install -y \
    curl \
    git \
    libncurses5 \
    openjdk-11-jre-headless

RUN cd /usr/local/bin && curl -sSLO https://github.com/pinterest/ktlint/releases/download/0.34.2/ktlint && chmod +x ktlint

RUN npm install -g danger@10.2.1
# Currently danger-kotlin has sparse releases and we are in the phase of discovery of this technology.
# For that reason we don't use their versions and we build the binaries from the source code. Docker 
# caches this RUN command because it did not change. which makes it impossible to rebuild the image without 
# pruning the cache. To be able to easily force this commant to rebuild, we add this artificial dummy property.
# Everytime we want rebuild the image we need to change value of this property.
ARG dummy_version=1
RUN curl -s https://raw.githubusercontent.com/danger/kotlin/d06e9bc166b26a3847d6a17677950e2d23f9c252/scripts/install.sh?dummy=$dummy_version | bash && \
    rm -r /root/.gradle

ENV PATH=$PATH:/usr/local/kotlinc/bin:/opt/gradle/gradle-5.6.2/bin

VOLUME /root/.gradle
