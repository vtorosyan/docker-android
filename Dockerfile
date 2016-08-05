# Version 1.0.0
FROM ubuntu:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get --yes --force-yes install openssh-server unzip

RUN groupadd android
RUN useradd -m -g android -s /bin/bash android
RUN echo "android:android" | chpasswd

ADD bash_profile /home/android/.bash_profile

RUN chown -R android:android /home/android

# Install Java

RUN apt-get install -y software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update -y && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get remove software-properties-common -y && \
    apt-get autoremove -y && \
    apt-get clean

# Installs Android SDK

RUN dpkg --add-architecture i386 && \
    apt-get update -y && \
    apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean
    
ENV ANDROID_SDK_FILENAME android-sdk_r24.4.1-linux.tgz
ENV ANDROID_SDK_URL http://dl.google.com/android/${ANDROID_SDK_FILENAME}
ENV ANDROID_API_LEVELS android-24
ENV ANDROID_BUILD_TOOLS_VERSION 24.0.1
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN cd /opt && \
    wget -q ${ANDROID_SDK_URL} && \
    tar -xzf ${ANDROID_SDK_FILENAME} && \
    rm ${ANDROID_SDK_FILENAME} && \
    echo yes | android update sdk --no-ui -a --filter tools,platform-tools,${ANDROID_API_LEVELS},build-tools-${ANDROID_BUILD_TOOLS_VERSION},extra-android-support,extra-android-m2repository,extra-google-m2repository,extra-google-play_apk_expansion

# Install SSHD
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

EXPOSE 22

CMD /usr/sbin/sshd -D
