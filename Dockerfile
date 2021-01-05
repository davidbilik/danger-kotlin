FROM node:12.20.1-buster

RUN apt-get update && apt-get install -y \
    curl \
    git \
    libncurses5 \
    openjdk-11-jre-headless

RUN cd /usr/local/bin && curl -sSLO https://github.com/pinterest/ktlint/releases/download/0.34.2/ktlint && chmod +x ktlint

RUN npm install -g danger@10.2.1

RUN curl -o kotlin-compiler.zip -L https://github.com/JetBrains/kotlin/releases/download/v1.4.10/kotlin-compiler-1.4.10.zip && \
    unzip -d /usr/local/ kotlin-compiler.zip && \
    rm -rf kotlin-compiler.zip

RUN curl -o gradle.zip -L https://downloads.gradle-dn.com/distributions/gradle-5.6.2-bin.zip && \
    mkdir /opt/gradle && \
    unzip -d /opt/gradle gradle.zip && \
    rm -rf gradle.zip

RUN git clone https://github.com/danger/kotlin.git _danger-kotlin && \
    cd _danger-kotlin && git checkout 0.7.1 && \
    make install  && \
    cd ..  && \
    rm -rf _danger-kotlin

ENV PATH=$PATH:/usr/local/kotlinc/bin:/opt/gradle/gradle-5.6.2/bin

VOLUME /root/.gradle
